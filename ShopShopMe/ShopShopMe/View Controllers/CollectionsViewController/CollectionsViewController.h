//
//  CollectionsViewController.h
//  ShopShopMe
//
//  Created by Admin on 6/23/15.
//  Copyright (c) 2015 Bobz Kobob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *m_collectionView;
@end
