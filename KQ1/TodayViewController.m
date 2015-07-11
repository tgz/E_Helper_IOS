//
//  TodayViewController.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/5.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "TodayViewController.h"
#import "import.h"
#import "LoginViewController.h"
#import "User.h"

@interface TodayViewController ()
@property (nonatomic,strong)UILabel *userInfo;
@property (nonatomic,strong)UIButton *loginButton;
@property (nonatomic,strong)UILabel *ouName;
@end

@implementation TodayViewController

#pragma mark - property

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.userInfo];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.ouName];
    NSLog(@"TodayViewController_viewDidLoad");
       //self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",9];
}

- (void)viewWillLayoutSubviews{
    NSLog(@"TodayVC---> viewWillLayoutSubviews");
    [super viewWillLayoutSubviews];
    
    self.userInfo.frame = CGRectMake(20, 40, self.view.frame.size.width-40, 40);
    
//    CGRect parentRect = self.view.frame;
//    self.loginButton.frame = CGRectMake(parentRect.size.width-150, parentRect.size.height-100, 120, 30);
    
    self.loginButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height-kBorderBottom);
    
    
    
    NSLog(@"TodayViewController_viewWillLayoutSubviews");
//    self.userInfo.frame = CGRectMake(60, 30, 300, 30);
    
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    

}

- (void)viewDidLayoutSubviews {
    NSLog(@"TodayVC---> viewDidLayoutSubviews");
    
    
//    [self.userInfo mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).width.offset(60);
//        make.width.equalTo(self.view);
//        make.centerX.equalTo(self.view);
//    }];
    
    
    [self.ouName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.top.equalTo(self.userInfo.mas_bottom);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"TodayVC---> viewWillAppear");
    [super viewWillAppear:animated];
    
    User *user = [[User alloc]initWithNSUserDefaults];
    
    self.userInfo.text = user.userName;
    self.ouName.text = user.ouName;
    NSLog(@"viewWillAppear：读取用户信息：%@,%@,%@,%d",user.userName , user.userGuid, user.ouName , user.isLogin);
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
- (void)GoToLogin
{
    NSLog(@"goToLogin!");
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [loginVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:loginVC animated:YES completion:nil];
    
}

#pragma mark - private methods

#pragma mark - getters and setters
- (UILabel *) userInfo{
    if(nil ==_userInfo){
        _userInfo = [[UILabel alloc]init];
        _userInfo.text = @"用户信息";
        _userInfo.font = [UIFont systemFontOfSize:20];
        _userInfo.textColor = [UIColor blackColor];
        _userInfo.textAlignment = NSTextAlignmentCenter;
    }
    return _userInfo;
}

- (UIButton *)loginButton{
    if(nil==_loginButton){
        _loginButton = [UIButton buttonWithStyle:StrapSuccessStyle andTitle:@"登录" andFrame:CGRectMake(20, 300, kButtonWidth, kButtonHeight) target:self action:@selector(GoToLogin)];
        
        
    }
    return _loginButton;
}

- (UILabel *)ouName{
    if(nil == _ouName){
        _ouName = [[UILabel alloc]init];
        _ouName.text = @"部门";
        _ouName.textAlignment = NSTextAlignmentCenter;
        _ouName.font = [UIFont systemFontOfSize:12];
        _ouName.textColor = [UIColor grayColor];
    }
    return _ouName;

}
@end
