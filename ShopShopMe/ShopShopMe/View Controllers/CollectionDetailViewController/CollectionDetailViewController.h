//
//  CollectionDetailViewController.h
//  ShopShopMe
//
//  Created by Admin on 6/23/15.
//  Copyright (c) 2015 Bobz Kobob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"

@interface CollectionDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain) NSString *collectionID;
@property (weak, nonatomic) IBOutlet CustomLabel *m_lblTitle;
@property (weak, nonatomic) IBOutlet CustomLabel *m_lblDescription;
@property (weak, nonatomic) IBOutlet UICollectionView *m_collectionView;

@end
