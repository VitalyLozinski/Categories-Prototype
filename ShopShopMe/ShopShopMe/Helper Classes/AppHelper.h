//
//  AppHelper.h
//  SocialShipping
//
//  Created by Akansha on 04/02/14.
//  Copyright (c) 2014 Swati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppHelper : NSObject

+ (void)showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles;

@end
