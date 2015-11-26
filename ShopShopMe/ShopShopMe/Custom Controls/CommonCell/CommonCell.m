//
//  ProductCell.m
//  ShopShopMe
//
//  Created by Admin on 6/21/15.
//  Copyright (c) 2015 Bobz Kobob. All rights reserved.
//

#import "CommonCell.h"
#import "Define.h"

@implementation CommonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.m_productImage.frame = CGRectMake(2, 4, self.frame.size.width-4, self.frame.size.height*3/4);
    self.m_productName.frame = CGRectMake(8, self.m_productImage.frame.size.height + 4, self.frame.size.width - 16, self.frame.size.height/4 - 4);
    self.m_productName.textColor = [UIColor lightGrayColor];
    self.m_productName.font = [UIFont fontWithName:FONT_HELVETICA_ROMAN size:14.0f];
}

@end
