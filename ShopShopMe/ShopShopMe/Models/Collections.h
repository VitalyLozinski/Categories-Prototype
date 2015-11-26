//
//  Collection.h
//  ShopShopMe
//
//  Created by Admin on 6/21/15.
//  Copyright (c) 2015 Bobz Kobob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Collections : NSObject

@property (nonatomic, retain) NSString          *objectID;
@property (nonatomic, retain) NSString          *name;
@property (nonatomic, retain) NSString          *desc;
@property (nonatomic, retain) NSString          *imageURLThumb;
@property (nonatomic, retain) NSString          *imageURLMedium;
@property (nonatomic, retain) NSString          *imageURLOriginal;
@property (nonatomic, retain) NSMutableArray    *products;
@property (nonatomic, assign) int               order;

@end
