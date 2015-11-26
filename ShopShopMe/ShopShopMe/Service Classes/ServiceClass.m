//
//  ServiceClass.m
//  ShopShopMe
//
//  Created by Admin on 6/21/15.
//  Copyright (c) 2015 Bobz Kobob. All rights reserved.
//

#import "ServiceClass.h"
#import "Reachability.h"
#import "AppHelper.h"
#import "Define.h"

@implementation ServiceClass

+(ServiceClass *) sharedServiceClass{
    
    static ServiceClass *singolton;
    
    if(!singolton){
        singolton=[[ServiceClass alloc] init];
    }
    
    return singolton;
}

- (BOOL)checkNetworkAbility
{
    Reachability *reg = [Reachability reachabilityWithHostName:API_URL];
    NetworkStatus internetStatus = [reg currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
        return NO;
    else
        return YES;
}

- (void)hitServiceToGetCollections
{
    if ([self checkNetworkAbility])
    {
        NSString *requestURL = [NSString stringWithFormat:@"%@collections?auth_token=%@", API_URL, AUTH_TOKEN];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dictionary = responseObject;
            
            if(dictionary)
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_COLLECTS object:nil userInfo:dictionary];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [AppHelper showAlertViewWithTag:ALERT_DEFAULT_TAG
                                      title:APP_NAME
                                    message:INTERNET_NOT_AVAILABLE
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:ALERT_BTN_OK];
            
        }];
    }
    else
    {
        [AppHelper showAlertViewWithTag:ALERT_DEFAULT_TAG
                                  title:APP_NAME
                                message:INTERNET_NOT_AVAILABLE
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:ALERT_BTN_OK];
    }
}

- (void)hitServiceToGetCollectionInfo:(NSString*) objectID
{
    if ([self checkNetworkAbility])
    {
        NSString *requestURL = [NSString stringWithFormat:@"%@collections/%@?auth_token=%@", API_URL, objectID, AUTH_TOKEN];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dictionary = responseObject;
            
            if(dictionary)
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_COLLECT_DETAILS object:nil userInfo:dictionary];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [AppHelper showAlertViewWithTag:ALERT_DEFAULT_TAG
                                      title:APP_NAME
                                    message:INTERNET_NOT_AVAILABLE
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:ALERT_BTN_OK];
            
        }];
    }
    else
    {
        [AppHelper showAlertViewWithTag:ALERT_DEFAULT_TAG
                                  title:APP_NAME
                                message:INTERNET_NOT_AVAILABLE
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:ALERT_BTN_OK];
    }
}

- (void)hitServiceToGetCategories
{
    if ([self checkNetworkAbility])
    {
        NSString *requestURL = [NSString stringWithFormat:@"%@categories?auth_token=%@", API_URL, AUTH_TOKEN];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dictionary = responseObject;
            
            if(dictionary)
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_CATEGORIES object:nil userInfo:dictionary];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [AppHelper showAlertViewWithTag:ALERT_DEFAULT_TAG
                                      title:APP_NAME
                                    message:INTERNET_NOT_AVAILABLE
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:ALERT_BTN_OK];
            
        }];
    }
    else
    {
        [AppHelper showAlertViewWithTag:ALERT_DEFAULT_TAG
                                  title:APP_NAME
                                message:INTERNET_NOT_AVAILABLE
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:ALERT_BTN_OK];
    }
}

- (void)hitServiceToGetBrands
{
    if ([self checkNetworkAbility])
    {
        NSString *requestURL = [NSString stringWithFormat:@"%@brands?auth_token=%@", API_URL, AUTH_TOKEN];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dictionary = responseObject;
            
            if(dictionary)
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_BRANDS object:nil userInfo:dictionary];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [AppHelper showAlertViewWithTag:ALERT_DEFAULT_TAG
                                      title:APP_NAME
                                    message:INTERNET_NOT_AVAILABLE
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:ALERT_BTN_OK];
            
        }];
    }
    else
    {
        [AppHelper showAlertViewWithTag:ALERT_DEFAULT_TAG
                                  title:APP_NAME
                                message:INTERNET_NOT_AVAILABLE
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:ALERT_BTN_OK];
    }
}


- (void)hitServiceToGetShops
{
    if ([self checkNetworkAbility])
    {
        NSString *requestURL = [NSString stringWithFormat:@"%@shops?auth_token=%@", API_URL, AUTH_TOKEN];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dictionary = responseObject;
            
            if(dictionary)
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_SHOPS object:nil userInfo:dictionary];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [AppHelper showAlertViewWithTag:ALERT_DEFAULT_TAG
                                      title:APP_NAME
                                    message:INTERNET_NOT_AVAILABLE
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:ALERT_BTN_OK];
            
        }];
    }
    else
    {
        [AppHelper showAlertViewWithTag:ALERT_DEFAULT_TAG
                                  title:APP_NAME
                                message:INTERNET_NOT_AVAILABLE
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:ALERT_BTN_OK];
    }
}

@end

