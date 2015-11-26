//
//  SlideNavigationContorllerAnimationScale.m
//  ShopShopMe
//
//  Created by Vitaly on 6/6/15.
//  Copyright (c) 2015 Vitaly. All rights reserved.
//

#import "SlideNavigationContorllerAnimatorScale.h"

@implementation SlideNavigationContorllerAnimatorScale

#pragma mark - Initialization -

- (id)init
{
	if (self = [self initWithMinimumScale:1])
	{
	}
	
	return self;
}

- (id)initWithMinimumScale:(CGFloat)minimumScale
{
	if (self = [super init])
	{
		self.minimumScale = minimumScale;
	}
	
	return self;
}

#pragma mark - SlideNavigationContorllerAnimation Methods -

- (void)prepareMenuForAnimation
{
    UIViewController *menuViewController = [SlideNavigationController sharedInstance].leftMenu;
    menuViewController.view.transform = CGAffineTransformScale(menuViewController.view.transform, self.minimumScale, self.minimumScale);
}

- (void)animateMenuWithProgress:(CGFloat)progress
{
	UIViewController *menuViewController = [SlideNavigationController sharedInstance].leftMenu;
	
	CGFloat scale = MIN(1, (1-self.minimumScale) *progress + self.minimumScale);
	menuViewController.view.transform = CGAffineTransformScale([SlideNavigationController sharedInstance].view.transform, scale, scale);
}

- (void)clear
{
	[SlideNavigationController sharedInstance].leftMenu.view.transform = CGAffineTransformScale([SlideNavigationController sharedInstance].view.transform, 1, 1);
}

@end
