//
//  BottomSelectView.h
//  ShopShopMe
//
//  Created by Admin on 6/22/15.
//  Copyright (c) 2015 Bobz Kobob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomSelectViewDelegate;

@interface BottomSelectView : UIView

@property (nonatomic, strong) NSString *strSelectedTitle;
@property (nonatomic, weak) id<BottomSelectViewDelegate> delgate;

- (id) initWithFrame:(CGRect)frame title:(NSString *)strTitle;

@end

@protocol BottomSelectViewDelegate <NSObject>

- (void)bottomSelectView:(BottomSelectView *)view;

@end
