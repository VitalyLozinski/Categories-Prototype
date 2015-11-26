//
//  Define.h
//  ShopShopMe
//
//  Created by Jin WeiYi on 6/19/15.
//  Copyright (c) 2015 Minhua. All rights reserved.
//

#ifndef ShopShopMe_Define_h
#define ShopShopMe_Define_h

#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworkReachabilityManager.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)         ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define APP_NAME                                        @"ShopShopMe"
#define AUTH_TOKEN                                      @"Ps3L9DjW4F1XE8ilyjS17sKoTDg6ftBZZsQ8n"
#define API_URL                                         @"http://api.shopshopme.com/api/v1/"

#define SCREEN_WIDTH                                    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT                                   [[UIScreen mainScreen] bounds].size.height
#define IS_IPHONE_5                                     SCREEN_HEIGHT >= 568.0f?YES:NO

#define STATUS_BAR_HEIGHT                               20
#define NAVIGATION_BAR_HEIGHT                           44

#define FONT_HELVETICA_ROMAN                            @"HelveticaNeueCyr-Roman"
#define FONT_HELVETICA_MEDIUM                           @"HelveticaNeueCyr-Medium"
#define FONT_HELVETICA_BOLD                             @"HelveticaNeueCyr-Bold"
#define FONT_CABIN_REGULAR                              @"Cabin-Regular"

#define MENU_BACKGROUND_COLOR                           [UIColor colorWithRed:36.0f/255.0f green:36.0f/255.0f blue:36.0f/255.0f alpha:1]
#define COMMON_BACKGROUND_COLOR                         [UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1]
#define SELECTED_MENU_COLOR                             [UIColor colorWithRed:27.0f/255.0f green:27.0f/255.0f blue:27.0f/255.0f alpha:1]
#define SEARCHBAR_TEXTFIELD_COLOR                       [UIColor colorWithRed:67.0f/255.0f green:66.0f/255.0f blue:66.0f/255.0f alpha:1]
#define COLLECT_VIEW_BACK_COLOER                        [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1];

#define MENU_SLIDE_ANIMATION_DURATION                   .3
#define MENU_SLIDE_ANIMATION_OPTION                     UIViewAnimationOptionCurveEaseOut
#define MENU_QUICK_SLIDE_ANIMATION_DURATION             .18
#define MENU_SHADOW_RADIUS                              10
#define MENU_SHADOW_OPACITY                             1
#define MENU_DEFAULT_SLIDE_OFFSET                       120
#define MENU_FAST_VELOCITY_FOR_SWIPE_FOLLOW_DIRECTION   1200

#define MENU_CELL_HEIGHT                                60
#define MENU_ICON_HEIGHT                                30
#define MENU_ICON_WIDTH                                 30

#define SLIDE_NAVIGATIONCONTROLLER_DID_OPEN             @"SlideNavigationControllerDidOpen"
#define SLIDE_NAVIGATIONCONTROLLER_DID_CLOSE            @"SlideNavigationControllerDidClose"
#define SLIDE_NAVIGATIONCONTROLLER_DID_REVEAL           @"SlideNavigationControllerDidReveal"

#define NOTIFICATION_USER_INFO_MENU_LEFT                @"left"
#define NOTIFICATION_USER_INFO_MENU                     @"menu"

#pragma mark - Service Notifications

#define NOTIFICATION_GET_COLLECTS                       @"notification_get_collects"
#define NOTIFICATION_GET_CATEGORIES                     @"notification_get_categories"
#define NOTIFICATION_GET_BRANDS                         @"notification_get_brands"
#define NOTIFICATION_GET_SHOPS                          @"notification_get_shops"
#define NOTIFICATION_GET_COLLECT_DETAILS                @"notification_get_collect_details"

#pragma mark - Alert Tags

#define ALERT_DEFAULT_TAG                               0

#pragma mark - Alerts Button And Alerts Messages

#define INTERNET_NOT_AVAILABLE                          @"Connection Error. Please check your internet connection and try again."
#define ALERT_BTN_OK                                    @"Ok"

#endif
