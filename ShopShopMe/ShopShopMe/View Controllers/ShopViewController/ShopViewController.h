//
//  ShopViewController.h
//  ShopShopMe
//
//  Created by Admin on 6/22/15.
//  Copyright (c) 2015 Bobz Kobob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomSelectView.h"

@interface ShopViewController : UIViewController <BottomSelectViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *m_collectView;
@property (weak, nonatomic) IBOutlet BottomSelectView *m_bottomView;
@end
