//
//  LaunchScreenViewController.h
//  ShopShopMe
//
//  Created by Jin WeiYi on 6/19/15.
//  Copyright (c) 2015 Minhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchScreenViewController : UIViewController

/**
 *  Instantiate a LaunchScreenViewController from a storyboard containing a view controller
 *  with the identifier LaunchScreenViewController.
 *
 *  @param storyboard A UIStoryboard object
 *
 *  @return LaunchScreenViewController whose view contains the UIView from your Launch Screen XIB
 */
-(instancetype)initFromStoryboard:(UIStoryboard *)storyboard;

/**
 *  Instantiate a LaunchScreenViewController from a storyboard containing a view controller
 *  with the identifier specified.
 *
 *  @param storyboard A UIStoryboard object
 *  @param identifier The storyboard identifier for your LaunchScreenViewController view controller
 *
 *  @return LaunchScreenViewController whose view contains the UIView from your Launch Screen XIB
 */
-(instancetype)initFromStoryboard:(UIStoryboard *)storyboard withIdentifier:(NSString *)identifier;

@end