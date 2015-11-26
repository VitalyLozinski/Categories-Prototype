//
//  LaunchScreenViewController.m
//  ShopShopMe
//
//  Created by Jin WeiYi on 6/19/15.
//  Copyright (c) 2015 Minhua. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import "Define.h"

@implementation LaunchScreenViewController

-(instancetype)initFromStoryboard:(UIStoryboard *)storyboard
{
    return [self initFromStoryboard:storyboard withIdentifier:@"LaunchScreenViewController"];
}

-(instancetype)initFromStoryboard:(UIStoryboard *)storyboard withIdentifier:(NSString *)identifier;
{
    self = [storyboard instantiateViewControllerWithIdentifier:identifier];
    if (self) {

    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

@end
