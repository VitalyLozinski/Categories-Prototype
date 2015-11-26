//
//  SlideNavigationContorllerAnimationScale.h
//  ShopShopMe
//
//  Created by Vitaly on 6/6/15.
//  Copyright (c) 2015 Vitaly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SlideNavigationContorllerAnimator.h"

@interface SlideNavigationContorllerAnimatorScale : NSObject <SlideNavigationContorllerAnimator>

@property (nonatomic, assign) CGFloat minimumScale;

- (id)initWithMinimumScale:(CGFloat)minimumScale;

@end
