//
//  Product.h
//  ShopShopMe
//
//  Created by Admin on 6/23/15.
//  Copyright (c) 2015 Bobz Kobob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject
@property (nonatomic, retain) NSString          *objectID;
@property (nonatomic, retain) NSString          *name;
@property (nonatomic, retain) NSString          *desc;
@property (nonatomic, retain) NSString          *brand;
@property (nonatomic, assign) double            currentPrice;
@property (nonatomic, retain) NSString          *currency;
@property (nonatomic, assign) double            beforePrice;
@property (nonatomic, retain) NSMutableArray    *images;
@property (nonatomic, retain) NSString          *source;
@property (nonatomic, retain) NSString          *mappedCategory;
@property (nonatomic, retain) NSString          *productURL;
@property (nonatomic, assign) BOOL              isOnSale;
@property (nonatomic, assign) BOOL              isInStock;
@property (nonatomic, retain) NSString          *slug;
@end
