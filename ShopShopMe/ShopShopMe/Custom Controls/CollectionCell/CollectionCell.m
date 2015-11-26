//
//  CollectionCell.m
//  ShopShopMe
//
//  Created by Admin on 6/23/15.
//  Copyright (c) 2015 Bobz Kobob. All rights reserved.
//

#import "CollectionCell.h"
#import "Define.h"

@implementation CollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.m_ImageCollection.frame = CGRectMake(2, 4, self.frame.size.width-4, self.frame.size.height*4/5 - 8);
    self.m_lblCollectionName.frame = CGRectMake(8, self.m_ImageCollection.frame.size.height + 10, self.frame.size.width - 16, self.m_lblCollectionName.frame.size.height);
    self.m_lblCollectionName.textColor = [UIColor lightGrayColor];
    self.m_lblCollectionName.font = [UIFont fontWithName:FONT_HELVETICA_ROMAN size:12.0f];
    self.m_lblCurrency.frame = CGRectMake(8, self.m_lblCollectionName.frame.origin.y+self.m_lblCollectionName.frame.size.height+5, self.frame.size.width/2-8, self.m_lblCurrency.frame.size.height);
    self.m_lblCurrency.textColor = [UIColor blackColor];
    self.m_lblCurrency.font = [UIFont fontWithName:FONT_HELVETICA_MEDIUM size:13.0f];
    self.m_lblPlaceName.frame = CGRectMake(self.frame.size.width/2, self.m_lblCurrency.frame.origin.y, self.frame.size.width/2-8, self.m_lblPlaceName.frame.size.height);
    self.m_lblPlaceName.textColor = [UIColor redColor];
    self.m_lblPlaceName.font = [UIFont fontWithName:FONT_HELVETICA_ROMAN size:12.0f];
    self.m_lblPlaceName.textAlignment = NSTextAlignmentRight;
}

@end
