//
//  CustomLabel.h
//  ShopShopMe
//
//  Created by Admin on 6/23/15.
//  Copyright (c) 2015 Bobz Kobob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLabel : UILabel

- (float)heightForString:(NSString*)string font:(NSString*)fontName size:(float)fontSize color:(UIColor*)fontColor padding:(float)paddingInPx;

@end
