//
//  ProductViewController.m
//  ShopShopMe
//
//  Created by Vitaly on 6/19/15.
//  Copyright (c) 2015 Vitaly. All rights reserved.
//

#import "ProductViewController.h"
#import "LaunchScreenViewController.h"
#import "SlideNavigationController.h"
#import "ServiceClass.h"
#import "Define.h"
#import "ProductCell.h"
#import "Collections.h"
#import "AppHelper.h"
#import "AsyncImageView.h"
#import "CollectionDetailViewController.h"

#define USE_LAUNCH_AS_SPLASH 1

@interface ProductViewController ()
@property (nonatomic, strong) LaunchScreenViewController *launchScreenVC;
@property (nonatomic, retain) NSMutableArray *arrayCollections;
@property (nonatomic, retain) NSArray *sortedArray;
@end


@implementation ProductViewController
@synthesize arrayCollections = _arrayCollections;
@synthesize sortedArray = _sotedArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didCollectProduct:)
                                                 name:NOTIFICATION_GET_COLLECTS
                                               object:nil];
    
    self.arrayCollections = [[NSMutableArray alloc] init];
    [[ServiceClass sharedServiceClass] hitServiceToGetCollections];
}

- (void) setup
{
    UIImage *imageLogo = [UIImage imageNamed:@"logo.png"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:imageLogo];
    
    self.view.backgroundColor =             COMMON_BACKGROUND_COLOR;
    self.m_searchBar.barTintColor =         COMMON_BACKGROUND_COLOR;
    self.m_searchBar.layer.borderWidth =    1;
    self.m_searchBar.layer.borderColor =    [COMMON_BACKGROUND_COLOR CGColor];
    
    UITextField *txtSearchField = [self.m_searchBar valueForKey:@"_searchField"];
    [txtSearchField setBackgroundColor:SEARCHBAR_TEXTFIELD_COLOR];
    [txtSearchField setTextColor:[UIColor whiteColor]];
    [txtSearchField setTextAlignment:NSTextAlignmentCenter];
    self.m_searchBar.delegate = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.m_collectView.collectionViewLayout = layout;
    self.m_collectView.backgroundColor = [UIColor whiteColor];
    self.m_collectView.delegate = self;
    self.m_collectView.dataSource = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"ProductCell" bundle:nil];
    [self.m_collectView registerNib:cellNib forCellWithReuseIdentifier:@"ProductCell"];
    
    self.launchScreenVC = [[LaunchScreenViewController alloc] initFromStoryboard:self.storyboard];
    if (IS_IPHONE_5) {
        UIImageView *imageView = (UIImageView *)[self.launchScreenVC.view viewWithTag:1];
        imageView.image = [UIImage imageNamed:@"splash-568.png"];
    }
    
#if USE_LAUNCH_AS_SPLASH == 1
    UIView *v = _launchScreenVC.view;
    [self.view addSubview:v];
    
    [UIView animateWithDuration:0.5
                          delay:2.0
                        options:0
                     animations:^{
                         v.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [v removeFromSuperview];
                         [[self navigationController] setNavigationBarHidden:NO animated:YES];
                         self.m_searchBar.hidden = NO;
                         self.m_searchBar.frame = CGRectMake(0,
                                                             NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT,
                                                             SCREEN_WIDTH,
                                                             self.m_searchBar.frame.size.height
                                                             );
                         
                         self.m_collectView.frame = CGRectMake(0,
                                                               NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT + self.m_searchBar.frame.size.height,
                                                               SCREEN_WIDTH,
                                                               SCREEN_HEIGHT-(NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT + self.m_searchBar.frame.size.height)
                                                               );
                     }];
#endif
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
        
        [self.m_collectView reloadData];
        self.m_collectView.backgroundColor = COLLECT_VIEW_BACK_COLOER;
    }
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayMenu
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self.m_collectView registerNib:cellNib forCellWithReuseIdentifier:@"ProductCell"];
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
        collections.products = [[NSMutableArray alloc] init];
        
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

#pragma mark - UISearchBar Delegate
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0)
    {
        [searchBar performSelector:@selector(resignFirstResponder)
                        withObject:nil
                        afterDelay:0];
    }
}
@end
