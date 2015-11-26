//
//  ShopViewController.m
//  ShopShopMe
//
//  Created by Admin on 6/22/15.
//  Copyright (c) 2015 Bobz Kobob. All rights reserved.
//

#import "ShopViewController.h"
#import "CommonCell.h"
#import "Define.h"
#import "ServiceClass.h"
#import "Shop.h"
#import "AsyncImageView.h"

@interface ShopViewController ()
@property (nonatomic, retain) NSMutableArray *arrayShops;
@property (nonatomic, retain) NSArray *sortedArray;
@end

@implementation ShopViewController
@synthesize arrayShops = _arrayShops;
@synthesize sortedArray = _sortedArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didCollectShops:)
                                                 name:NOTIFICATION_GET_SHOPS
                                               object:nil];
    
    [[ServiceClass sharedServiceClass] hitServiceToGetShops];
}

- (void)setup
{
    UIImage *imageLogo = [UIImage imageNamed:@"logo.png"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:imageLogo];
    
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
    
    UIImage *searchButtonImage = [UIImage imageNamed:@"btn_search_in_navi.png"];
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [searchButton setImage:searchButtonImage
                  forState:UIControlStateNormal];
    
    searchButton.frame = CGRectMake(0, 0, searchButtonImage.size.width, searchButtonImage.size.height);
    
    [searchButton addTarget:self
                     action:@selector(doSearch)
           forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = searchBarButtonItem;
    
    self.m_bottomView.delgate = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.m_collectView.collectionViewLayout = layout;
    self.m_collectView.backgroundColor = [UIColor whiteColor];
    self.m_collectView.frame = CGRectMake(0,
                                          STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT,
                                          SCREEN_WIDTH,
                                          SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-self.m_bottomView.frame.size.height
                                          );
    self.m_collectView.delegate = self;
    self.m_collectView.dataSource = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"CommonCell" bundle:nil];
    [self.m_collectView registerNib:cellNib forCellWithReuseIdentifier:@"CommonCell"];
}

- (void)didCollectShops:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_GET_SHOPS
                                                  object:nil];
    if (notification.userInfo)
    {
        NSArray *receivedArray = (NSArray *) notification.userInfo;
        
        self.sortedArray = [receivedArray sortedArrayUsingComparator:^NSComparisonResult(id lhs, id rhs) {
            int x1 = (int)[(NSDictionary*)lhs objectForKey:@"position"];
            int x2 = (int)[(NSDictionary*)rhs objectForKey:@"position"];
            
            return (x1 > x2) - (x2 > x1);
        }];
        
        [self.m_collectView reloadData];
        self.m_collectView.backgroundColor = COLLECT_VIEW_BACK_COLOER;
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

- (void)doSearch
{
    
}

#pragma mark BottomSelectView Delegate
- (void)bottomSelectView:(BottomSelectView *)view
{
    int abcd = 0;
    abcd = 1;
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
    CommonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommonCell" forIndexPath:indexPath];
    if (cell == nil) {
        UINib *cellNib = [UINib nibWithNibName:@"CommonCell" bundle:nil];
        [self.m_collectView registerNib:cellNib forCellWithReuseIdentifier:@"CommonCell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dict = [self.sortedArray objectAtIndex:indexPath.row];
    if (dict) {
        Shop *shop = [[Shop alloc] init];
        NSDictionary *dictForImages = [dict objectForKey:@"image_url"];
        shop.imageURLMedium = [dictForImages objectForKey:@"medium"];
        shop.imageURLOriginal = [dictForImages objectForKey:@"original"];
        shop.imageURLThumb = [dictForImages objectForKey:@"thumb"];
        shop.name = [dict objectForKey:@"display_name"];
        shop.objectID = [dict objectForKey:@"id"];
        shop.position = (int)[dict objectForKey:@"position"];
        shop.query = [dict objectForKey:@"query"];
        shop.isTrending = (BOOL)[dict objectForKey:@"is_trending"];
        shop.isPromoted = (BOOL)[dict objectForKey:@"is_promoted"];
        
        cell.m_productImage.image = nil;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.m_productImage];
        cell.m_productImage.imageURL = [NSURL URLWithString:shop.imageURLOriginal];
        cell.m_productName.text = [shop.name uppercaseString];
    }
    return cell;
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
