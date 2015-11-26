//
//  MenuCell.m
//  ShopShopMe
//
//  Created by Jin WeiYi on 6/20/15.
//  Copyright (c) 2015 Minhua. All rights reserved.
//

#import "MenuCell.h"
#import "Define.h"

@implementation MenuCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.m_icon.frame = CGRectMake(12, MENU_CELL_HEIGHT/2 - MENU_ICON_HEIGHT/2, MENU_ICON_WIDTH, MENU_ICON_WIDTH);
    self.m_lblTitle.frame = CGRectMake(20 + MENU_ICON_WIDTH, MENU_CELL_HEIGHT/2 - MENU_ICON_HEIGHT/2 + 2, 100, MENU_ICON_WIDTH);
    self.m_lblTitle.font = [UIFont fontWithName:FONT_HELVETICA_ROMAN size:17];
    self.m_lblTitle.textColor = [UIColor whiteColor];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    UIView *selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:SELECTED_MENU_COLOR];
    [self setSelectedBackgroundView:selectedBackgroundView];
}

@end
