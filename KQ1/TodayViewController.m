//
//  TodayViewController.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/5.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "TodayViewController.h"
#import "Masonry.h"


@interface TodayViewController ()
@property (nonatomic,strong)UILabel *userInfo;
@end

@implementation TodayViewController

#pragma mark - property

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    [self.view addSubview:self.userInfo];
    
    NSLog(@"TodayViewController_viewDidLoad");
    
       //self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",9];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"TodayViewController_viewWillAppear");
    self.userInfo.frame = CGRectMake(60, 30, 300, 30);
//    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];

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

#pragma mark - private methods

#pragma mark - getters and setters
- (UILabel *) userInfo{
    if(nil ==_userInfo){
        _userInfo = [[UILabel alloc]init];
        _userInfo.text = @"用户信息";
        _userInfo.font = [UIFont systemFontOfSize:18];
        _userInfo.textColor = [UIColor blackColor];
    }
    
    return _userInfo;
}

@end
