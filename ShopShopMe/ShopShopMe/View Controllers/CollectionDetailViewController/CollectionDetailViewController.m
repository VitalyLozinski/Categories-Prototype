//
//  CollectionDetailViewController.m
//  ShopShopMe
//
//  Created by Admin on 6/23/15.
//  Copyright (c) 2015 Bobz Kobob. All rights reserved.
//

#import "CollectionDetailViewController.h"
#import "Collections.h"
#import "Product.h"
#import "ServiceClass.h"
#import "Define.h"
#import "CollectionCell.h"
#import "AsyncImageView.h"

@interface CollectionDetailViewController ()
{
    Collections *collection;
}

@property (nonatomic, retain) NSMutableArray *arrayCollections;
@property (nonatomic, retain) NSArray *productsArray;
@end

@implementation CollectionDetailViewController

@synthesize collectionID = _collectionID;
@synthesize arrayCollections = _arrayCollections;
@synthesize productsArray = _productsArray;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetCollectDetails:)
                                                 name:NOTIFICATION_GET_COLLECT_DETAILS
                                               object:nil];
    
    [[ServiceClass sharedServiceClass] hitServiceToGetCollectionInfo:self.collectionID];
}

- (void)setup
{    
    UIImage *backButtonImage = [UIImage imageNamed:@"btn_back.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage
                forState:UIControlStateNormal];
    
    backButton.frame = CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height);
    
    [backButton addTarget:self
                   action:@selector(popViewController)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIColor lightGrayColor], UITextAttributeTextShadowColor, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
    
    self.m_lblTitle.text = @"";
    self.m_lblDescription.text = @"";

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.m_collectionView.collectionViewLayout = layout;
    self.m_collectionView.backgroundColor = [UIColor whiteColor];
    self.m_collectionView.delegate = self;
    self.m_collectionView.dataSource = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"CollectionCell" bundle:nil];
    [self.m_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"CollectionCell"];
}

- (void)didGetCollectDetails:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_GET_COLLECTS object:nil];
    
    if (notification.userInfo)
    {
        NSDictionary *dictForUserInfo = notification.userInfo;
        collection = [[Collections alloc] init];
        collection.objectID = [dictForUserInfo objectForKey:@"id"];
        collection.name = [dictForUserInfo objectForKey:@"name"];
        collection.desc = [dictForUserInfo objectForKey:@"description"];
        NSDictionary *dictForImages = [dictForUserInfo objectForKey:@"image_url"];
        collection.imageURLMedium = [dictForImages objectForKey:@"medium"];
        collection.imageURLOriginal = [dictForImages objectForKey:@"original"];
        collection.imageURLThumb = [dictForImages objectForKey:@"thumb"];
        collection.products = [[NSMutableArray alloc] init];
        collection.order = (int)[dictForUserInfo objectForKey:@"order"];
        
        NSArray *arrayForProducts = (NSArray *)[dictForUserInfo objectForKey:@"products"];
        
        for (int i=0; i<arrayForProducts.count; i++) {
            NSDictionary *dictForProduct = [arrayForProducts objectAtIndex:i];
            Product *product = [[Product alloc] init];
            product.objectID = [dictForProduct objectForKey:@"object_id"];
            product.name = [dictForProduct objectForKey:@"name"];
            product.desc = @"";
            product.brand = [dictForProduct objectForKey:@"brand"];
            product.currentPrice = [(NSNumber *)[dictForProduct objectForKey:@"after_price"] doubleValue];
            product.beforePrice = 0;
            product.currency = @"";
            product.images = [[NSMutableArray alloc] init];
            product.source = [dictForProduct objectForKey:@"source"];
            product.mappedCategory = [dictForProduct objectForKey:@"mapped_category"];
            product.productURL = @"";
            product.isOnSale = (int)[dictForProduct objectForKey:@"is_on_sale"];
            product.isInStock = (int)[dictForProduct objectForKey:@"is_in_stock"];
            product.slug = @"";
            
            NSArray *arrayForProductImage = [dictForProduct objectForKey:@"images"];
            for (int j=0; j<arrayForProductImage.count; j++)
            {
                NSString *strURL = [arrayForProductImage objectAtIndex:j];
                
                if (![strURL hasPrefix:@"http://"] && ![strURL hasPrefix:@"https://"])
                {
                    if ([strURL hasPrefix:@"//"])
                    {
                        strURL = [NSString stringWithFormat:@"https:%@", strURL];
                    }
                    else
                    {
                        strURL = [NSString stringWithFormat:@"https://%@", strURL];
                    }
                }
                
                [product.images addObject:strURL];
            }
            
            [collection.products addObject:product];
        }
        
        float heightForTitle = [self.m_lblTitle heightForString:collection.name font:FONT_HELVETICA_BOLD size:17.0f color:[UIColor blackColor] padding:5.0f];
        float heightForDescription = [self.m_lblDescription heightForString:collection.desc font:FONT_HELVETICA_MEDIUM size:14.5f color:[UIColor lightGrayColor] padding:5.0f];
        
        self.m_lblTitle.frame = CGRectMake(6.0f, 8.0f, SCREEN_WIDTH-12.0f, heightForTitle);
        self.m_lblDescription.frame = CGRectMake(6.0f, 19.0f+heightForTitle, SCREEN_WIDTH-12.0f, heightForDescription);
        self.m_collectionView.frame = CGRectMake(0, self.m_lblDescription.frame.origin.y + heightForDescription + 5, SCREEN_WIDTH, SCREEN_HEIGHT-self.m_lblDescription.frame.origin.y-heightForDescription-5-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
        [self.m_collectionView reloadData];
        self.m_collectionView.backgroundColor = COLLECT_VIEW_BACK_COLOER;
    }
}

- (void)popViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return collection.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        UINib *cellNib = [UINib nibWithNibName:@"CollectionCell" bundle:nil];
        [self.m_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"CollectionCell"];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    if (collection.products) {
        Product *product = [collection.products objectAtIndex:indexPath.row];
        cell.m_lblCollectionName.text = product.name;
        cell.m_lblCurrency.text = [NSString stringWithFormat:@"%@ %@", [product.currency isEqualToString:@""]?@"AED":product.currency, [NSString stringWithFormat:@"%1.0f", product.currentPrice]];
        cell.m_lblPlaceName.text = product.source;
        
        cell.m_ImageCollection.image = nil;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.m_ImageCollection];
        cell.m_ImageCollection.imageURL = [NSURL URLWithString:[product.images objectAtIndex:0]];
    }

    return cell;
}

#pragma mark - UICollectionViewFlowLayout Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/2-0.5, SCREEN_WIDTH*2/3-1);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionView *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    return 1;
}


@end
