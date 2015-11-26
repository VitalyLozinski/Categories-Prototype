//
//  ServiceClass.h
//  ShopShopMe
//
//  Created by Admin on 6/21/15.
//  Copyright (c) 2015 Bobz Kobob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceClass : NSObject


+ (ServiceClass *)sharedServiceClass;

- (void)hitServiceToGetCollections;
- (void)hitServiceToGetCategories;
- (void)hitServiceToGetBrands;
- (void)hitServiceToGetShops;
- (void)hitServiceToGetCollectionInfo:(NSString*) objectID;

@end
