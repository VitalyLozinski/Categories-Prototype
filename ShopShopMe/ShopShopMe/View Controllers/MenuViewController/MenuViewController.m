//
//  MenuViewController.m
//  ShopShopMe
//
//  Created by Vitaly on 6/19/15.
//  Copyright (c) 2015 Vitaly. All rights reserved.
//

#import "MenuViewController.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "MenuCell.h"
#import "Define.h"

@implementation MenuViewController

#pragma mark - UIViewController Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{    
    return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.m_tblMenu.delegate = self;
    self.m_tblMenu.dataSource = self;
    
    self.m_tblMenu.separatorColor = [UIColor clearColor];
    
    self.m_tblMenu.backgroundColor = MENU_BACKGROUND_COLOR;
    self.m_tblMenu.scrollEnabled = NO;
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    NSIndexPath *indexPathForHighlightCell = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.m_tblMenu selectRowAtIndexPath:indexPathForHighlightCell animated:YES scrollPosition:UITableViewScrollPositionBottom];
//}

#pragma mark - UITableView Delegate & Datasource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_tblMenu.frame.size.width, STATUS_BAR_HEIGHT)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return STATUS_BAR_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *menuTableIdentifier = @"MenuCell";
    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:menuTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    switch (indexPath.row)
    {
        case 0:
            cell.m_back.image = [UIImage imageNamed:@"cell_back.png"];
            cell.m_icon.image = [UIImage imageNamed:@"btn_home.png"];
            cell.m_lblTitle.text = @"Home";
            break;
            
        case 1:
            cell.m_icon.image = [UIImage imageNamed:@"btn_search.png"];
            cell.m_lblTitle.text = @"Search";
            break;
            
        case 2:
            cell.m_icon.image = [UIImage imageNamed:@"btn_categories.png"];
            cell.m_lblTitle.text = @"Categories";
            break;
            
        case 3:
            cell.m_icon.image = [UIImage imageNamed:@"btn_brands.png"];
            cell.m_lblTitle.text = @"Brands";
            break;
            
        case 4:
            cell.m_icon.image = [UIImage imageNamed:@"btn_shops.png"];
            cell.m_lblTitle.text = @"Shops";
            break;
            
        case 5:
            cell.m_icon.image = [UIImage imageNamed:@"btn_collection.png"];
            cell.m_lblTitle.text = @"Collections";
            break;
            
        case 6:
            cell.m_icon.image = [UIImage imageNamed:@"btn_favorite.png"];
            cell.m_lblTitle.text = @"My Favorites";
            break;
            
        case 7:
            cell.m_icon.image = [UIImage imageNamed:@"btn_aboutus.png"];
            cell.m_lblTitle.text = @"About Us";
            break;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                             bundle: nil];
    UIViewController *vc ;
    
    switch (indexPath.row)
    {
        case 0:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ProductViewController"];
            break;
            
        case 1:
            break;
            
        case 2:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"CategoryViewController"];
            break;
            
        case 3:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"BrandViewController"];
            break;
            
        case 4:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ShopViewController"];
            break;
            
        case 5:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"CollectionsViewController"];
            break;
    }
    
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                     withCompletion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MENU_CELL_HEIGHT;
}

@end
