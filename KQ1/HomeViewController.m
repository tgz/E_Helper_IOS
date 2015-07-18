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
#import "AFNetworking.h"
#import "SwicthUserViewController.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

#pragma mark - property

#pragma mark - life cycle



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    
    NSMutableArray *tabBarArray = [[NSMutableArray alloc]init];
    
    /**主功能界面添加*/
    TodayViewController *todayVC = [[TodayViewController alloc]init];
    UINavigationController *todayNC = [[UINavigationController alloc]initWithRootViewController:todayVC];
    [tabBarArray addObject:todayNC];
    
    
    
    /**零报告View添加*/
    ZeroReportViewController * zeroVC = [[ZeroReportViewController alloc]init];
    UINavigationController *zeroNC = [[UINavigationController alloc]initWithRootViewController:zeroVC];
    [tabBarArray addObject:zeroNC];
    
   

    /**切换用户功能界面添加*/
    SwicthUserViewController *switchVC = [[SwicthUserViewController alloc]init];
    UINavigationController *switchNC = [[UINavigationController alloc]initWithRootViewController:switchVC];
    [tabBarArray addObject:switchNC];
    
     [self setViewControllers:tabBarArray animated:YES];
    
    /**TabbarItem*/
    
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
    
    UITabBarItem *switchUserItem = [self.tabBar.items objectAtIndex:2];
    [switchUserItem setTitle:@"用户"];
    [switchUserItem setSelectedImage:[UIImage imageNamed:@"me_selected.png"]];
    [switchUserItem setImage:[UIImage imageNamed:@"me_normal.png"]];
    [switchUserItem setTag:2];
    
    
    
   
    
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
    
    NSLog(@"-----%ldHomeView_response_Clicked",(long)item.tag);
    
    
}
#pragma mark - private methods
- (void)reach{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld", (long)status);
    }];
}




#pragma mark - getters and setters

@end
