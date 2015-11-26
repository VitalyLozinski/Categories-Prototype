//
//  Category.h
//  ShopShopMe
//
//  Created by Admin on 6/22/15.
//  Copyright (c) 2015 Bobz Kobob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categories : NSObject

@property (nonatomic, retain) NSString              *objectID;
@property (nonatomic, retain) NSString              *name;
@property (nonatomic, assign) int                   position;
@property (nonatomic, retain) NSMutableArray        *terms;
@property (nonatomic, retain) NSString              *query;
@property (nonatomic, assign) BOOL                  isPromoted;
@property (nonatomic, assign) BOOL                  isTrending;
@property (nonatomic, retain) NSString              *imageURLThumb;
@property (nonatomic, retain) NSString              *imageURLMedium;
@property (nonatomic, retain) NSString              *imageURLOriginal;

@end
