//
//  AppHelper.m
//  SocialShipping
//
//  Created by Akansha on 04/02/14.
//  Copyright (c) 2014 Swati. All rights reserved.
//

#import "AppHelper.h"
#import "Define.h"

@implementation AppHelper

+ (void) showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate
                                                                           cancelButtonTitle:CbtnTitle otherButtonTitles:otherBtnTitles, nil];
    
    alertView.tag = tag;
    alertView.delegate = delegate;
    [alertView show];

}

@end
