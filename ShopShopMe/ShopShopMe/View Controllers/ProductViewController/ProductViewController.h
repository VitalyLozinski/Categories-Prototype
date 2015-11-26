//
//  ProductViewController.h
//  ShopShopMe
//
//  Created by Jin WeiYi on 6/19/15.
//  Copyright (c) 2015 Minhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface ProductViewController : UIViewController <SlideNavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *m_searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *m_collectView;

@end
