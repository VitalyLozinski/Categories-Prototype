//
//  CollectionsViewController.m
//  ShopShopMe
//
//  Created by Admin on 6/23/15.
//  Copyright (c) 2015 Bobz Kobob. All rights reserved.
//

#import "CollectionsViewController.h"
#import "Define.h"
#import "ProductCell.h"
#import "Collections.h"
#import "AsyncImageView.h"
#import "ServiceClass.h"
#import "CollectionDetailViewController.h"

@interface CollectionsViewController ()
@property (nonatomic, retain) NSArray *sortedArray;
@property (nonatomic, retain) NSMutableArray *arrayCollections;
@end

@implementation CollectionsViewController
@synthesize sortedArray = _sortedArray;
@synthesize arrayCollections = _arrayCollections;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didCollectProduct:)
                                                 name:NOTIFICATION_GET_COLLECTS
                                               object:nil];
    
    [[ServiceClass sharedServiceClass] hitServiceToGetCollections];
    self.arrayCollections = [[NSMutableArray alloc] init];
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
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.m_collectionView.collectionViewLayout = layout;
    self.m_collectionView.backgroundColor = [UIColor whiteColor];
    self.m_collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.m_collectionView.delegate = self;
    self.m_collectionView.dataSource = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"ProductCell" bundle:nil];
    [self.m_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ProductCell"];
}

- (void)didCollectProduct:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_GET_COLLECTS object:nil];
    if (notification.userInfo)
    {
        NSArray *receivedArray = (NSArray *) notification.userInfo;
        
        self.sortedArray = [receivedArray sortedArrayUsingComparator:^NSComparisonResult(id lhs, id rhs) {
            int x1 = (int)[(NSDictionary*)lhs objectForKey:@"order"];
            int x2 = (int)[(NSDictionary*)rhs objectForKey:@"order"];
            
            return (x1 > x2) - (x2 > x1);
        }];
        
        [self.m_collectionView reloadData];
        self.m_collectionView.backgroundColor = COLLECT_VIEW_BACK_COLOER;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.sortedArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductCell" forIndexPath:indexPath];
    if (cell == nil) {
        UINib *cellNib = [UINib nibWithNibName:@"ProductCell" bundle:nil];
        [self.m_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ProductCell"];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dict = [self.sortedArray objectAtIndex:indexPath.row];
    if (dict) {
        Collections *collections = [[Collections alloc] init];
        NSDictionary *dictForImages = [dict objectForKey:@"image_url"];
        collections.imageURLMedium = [dictForImages objectForKey:@"medium"];
        collections.imageURLOriginal = [dictForImages objectForKey:@"original"];
        collections.imageURLThumb = [dictForImages objectForKey:@"thumb"];
        collections.name = [dict objectForKey:@"name"];
        collections.objectID = [dict objectForKey:@"id"];
        collections.order = (int)[dict objectForKey:@"order"];
        collections.desc = [dict objectForKey:@"description"];
        
        cell.m_productImage.image = nil;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.m_productImage];
        cell.m_productImage.imageURL = [NSURL URLWithString:collections.imageURLOriginal];
        cell.m_productName.text = [collections.name uppercaseString];
        
        [self.arrayCollections addObject:collections];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Collections *collection = [self.arrayCollections objectAtIndex:indexPath.row];
    
    CollectionDetailViewController *collectionDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectionDetailViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:collectionDetailViewController];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
    collectionDetailViewController.collectionID = collection.objectID;
}

#pragma mark - UICollectionViewFlowLayout Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/2-0.5, SCREEN_WIDTH/2-3);
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
