//
//  CustomLabel.m
//  ShopShopMe
//
//  Created by Admin on 6/23/15.
//  Copyright (c) 2015 Bobz Kobob. All rights reserved.
//

#import "CustomLabel.h"
#import "Define.h"

@implementation CustomLabel

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
    }
    return self;
}

- (float)heightForString:(NSString*)string font:(NSString*)fontName size:(float)fontSize color:(UIColor*)fontColor padding:(float)paddingInPx
{
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberOfLines = 0;
    self.textAlignment = NSTextAlignmentLeft;
    self.font = [UIFont fontWithName:fontName size:fontSize];
    self.textColor = fontColor;
    self.text = string;
    
    CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH - paddingInPx * 2, FLT_MAX);
    CGSize expectedSize = [self sizeThatFits:maximumLabelSize];
    return expectedSize.height;
}

@end
