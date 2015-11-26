//
//  MenuViewController.h
//  ShopShopMe
//
//  Created by Jin WeiYi on 6/19/15.
//  Copyright (c) 2015 Minhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *m_tblMenu;

@end
