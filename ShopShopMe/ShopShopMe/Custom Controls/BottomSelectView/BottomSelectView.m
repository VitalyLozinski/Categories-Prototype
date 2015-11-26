//
//  BottomSelectView.m
//  ShopShopMe
//
//  Created by Admin on 6/22/15.
//  Copyright (c) 2015 Bobz Kobob. All rights reserved.
//

#import "BottomSelectView.h"
#import "Define.h"

@implementation BottomSelectView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setup];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame title:(NSString *)strTitle
{
    self.strSelectedTitle = strTitle;
    return [self initWithFrame:frame];
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    self.backgroundColor = COMMON_BACKGROUND_COLOR;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:singleTap];
}

#pragma mark BottomSelectView Delegate

- (void) tapDetected
{
    id<BottomSelectViewDelegate> strongDelegate = self.delgate;
    
    if ([strongDelegate respondsToSelector:@selector(bottomSelectView:)])
    {
        [strongDelegate bottomSelectView:self];
    }
}

@end
