//
//  HomeViewController.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/4.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "HomeViewController.h"
#import "TodayViewController.h"
#import "ZeroReportViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

#pragma mark - property

#pragma mark - life cycle



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *tabBarArray = [[NSMutableArray alloc]init];
    
    TodayViewController *todayVC = [[TodayViewController alloc]init];
    [tabBarArray addObject:todayVC];
    
    ZeroReportViewController * zeroVC = [[ZeroReportViewController alloc]init];
    [tabBarArray addObject:zeroVC];
    
    [self setViewControllers:tabBarArray animated:YES];
    
    UITabBarItem *homeItem = [self.tabBar.items objectAtIndex:0];
    [homeItem setTitle:@"Today"];
    [homeItem setSelectedImage:[UIImage imageNamed:@"project_selected.png"]];
    [homeItem setImage:[UIImage imageNamed:@"project_normal.png"]];
    [homeItem setTag:0];
    
    UITabBarItem *reportItem = [self.tabBar.items objectAtIndex:1];
    [reportItem setTitle:@"ZeroReport"];
    [reportItem setSelectedImage:[UIImage imageNamed:@"task_selected.png"]];
    [reportItem setImage:[UIImage imageNamed:@"task_normal.png"]];
    [reportItem setTag:1];

    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITabViewDelegate

#pragma mark - CustumDelegate

#pragma mark - event Response
- (void)tabBar:(nonnull UITabBar *)tabBar didSelectItem:(nonnull UITabBarItem *)item {
    
    NSLog(@"-----%dHomeView_response_Clicked",item.tag);
    
    
}
#pragma mark - private methods

#pragma mark - getters and setters

@end
