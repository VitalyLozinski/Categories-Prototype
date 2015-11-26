//
//  CollectionCell.h
//  ShopShopMe
//
//  Created by Admin on 6/23/15.
//  Copyright (c) 2015 Bobz Kobob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface CollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet AsyncImageView *m_ImageCollection;
@property (weak, nonatomic) IBOutlet UILabel *m_lblCollectionName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblCurrency;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPlaceName;

@end
