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
#import "Locator.h"


@interface TodayViewController () <UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic,strong)UILabel *userInfo;
@property (nonatomic,strong)UIButton *loginButton;
@property (nonatomic,strong)UILabel *ouName;
@property (nonatomic,strong)UITextView *location;
@property (nonatomic,strong)UIButton *kaoQinButton;
@property (nonatomic,strong)User *user;
@property (nonatomic,strong)UIButton *getLocationHistory;

@property(nonatomic,strong)UIAlertView *alertWait;

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
    
    [self.view addSubview:self.location];
    [self.view addSubview:self.kaoQinButton];
    
    [self.view addSubview:self.getLocationHistory];

    
    [self.ouName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.top.equalTo(self.userInfo.mas_bottom);
    }];
    
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.mas_equalTo(self.view).width.offset(20);
        //        make.right.mas_equalTo(self.view).width.offset(-20);
        
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(@50);
        make.top.mas_equalTo(self.ouName.mas_bottom);
        
        make.width.mas_equalTo(self.view.frame.size.width);
        
    }];
    //隐藏基项部导航栏
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    NSLog(@"TodayViewController_viewDidLoad");
       //self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",9];
}

- (void)viewWillLayoutSubviews{
    NSLog(@"TodayVC---> viewWillLayoutSubviews");
    [super viewWillLayoutSubviews];
    
    self.userInfo.frame = CGRectMake(20, 40, self.view.frame.size.width-40, 40);
    
    self.loginButton.center = CGPointMake(kScreenWidth/6, kScreenHeight - kBorderBottom);
    
    
    self.kaoQinButton.center = CGPointMake(kScreenWidth/2, kScreenHeight - kBorderBottom);
    
    self.getLocationHistory.center = CGPointMake(kScreenWidth*5/6, kScreenHeight-kBorderBottom);
    
}

//- (void)viewDidLayoutSubviews {
//    NSLog(@"TodayVC---> viewDidLayoutSubviews");
//    
//    
//    
////    [self.userInfo mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(self.view).width.offset(60);
////        make.width.equalTo(self.view);
////        make.centerX.equalTo(self.view);
////    }];
//    
//        [super viewDidLayoutSubviews];
//    
//}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"TodayVC---> viewWillAppear");
    [super viewWillAppear:animated];
    //隐藏顶部导航栏动画
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.userInfo.text = self.user.userName;
    self.ouName.text = self.user.ouName;
    NSLog(@"viewWillAppear：读取用户信息：%@,%@,%@,%d",self.user.userName , self.user.userGuid, self.user.ouName , self.user.isLogin);
  
    NSString *lastLocation = [Locator ReadLocation];
    if (![lastLocation isEqualToString:@""]) {
        lastLocation = @"请输入地点";
    }
    self.location.text = lastLocation;
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

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldEndEditing:(nonnull UITextView *)textView {
    [textView resignFirstResponder];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range  replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}
#pragma mark - event Response
- (void)GoToLogin {
    NSLog(@"goToLogin!");
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [loginVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:loginVC animated:YES completion:nil];
    
}

- (void)KaoQin{
    NSLog(@"Kaoqin!");

    
    [self alertWaitWithTitle:@"正在考勤" message:@"请稍后..." cancelButtonTitle:nil];
    
    //按下按钮时，关闭键盘;
    [self.view endEditing:YES];

    
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        Locator *locator = [[Locator alloc]initWithUser:self.user.userGuid location:self.location.text];
        
        [locator kaoQin];
        
        dispatch_async(main_queue, ^{
            if(locator.isSuccess){
                //考勤成功后，显示考勤记录
                [self.alertWait dismissWithClickedButtonIndex:0 animated:NO];
                NSArray *array = [locator.locations copy];
                
                NSMutableString *message = [[NSMutableString alloc]init];
                
                [array enumerateObjectsUsingBlock:^(id  __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
                    [message appendString:[NSString stringWithFormat:@"%@\n",obj]];
                }];
                
                [self alertWaitWithTitle:@"考勤成功！" message:message cancelButtonTitle:@"确定"];
                
            }else{
                [self.alertWait dismissWithClickedButtonIndex:0 animated:NO];
                [self alertWaitWithTitle:@"考勤失败！" message:locator.failDescription cancelButtonTitle:@"确定"];
            }
        });
    });

   
}

- (void)KaoQinHistory{
    NSLog(@"Kaoqin!");
    
    
    [self alertWaitWithTitle:@"正在查询" message:@"请稍后..." cancelButtonTitle:nil];
    
    //按下按钮时，关闭键盘;
    [self.view endEditing:YES];
    
    
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        Locator *locator = [[Locator alloc]initWithUser:self.user.userGuid location:self.location.text];
        
        [locator getAttendanceRecord];
        
        dispatch_async(main_queue, ^{
            if(locator.isSuccess){
                //考勤成功后，显示考勤记录
                [self.alertWait dismissWithClickedButtonIndex:0 animated:NO];
                NSArray *array = [locator.locations copy];
                
                NSMutableString *message = [[NSMutableString alloc]init];
                
                [array enumerateObjectsUsingBlock:^(id  __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
                    [message appendString:[NSString stringWithFormat:@"%@\n",obj]];
                }];
                
                [self alertWaitWithTitle:@"获取记录成功！" message:message cancelButtonTitle:@"确定"];
                
            }else{
                [self.alertWait dismissWithClickedButtonIndex:0 animated:NO];
                [self alertWaitWithTitle:@"考勤失败！" message:locator.failDescription cancelButtonTitle:@"确定"];
            }
        });
    });
    
    
}

- (void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - private methods
- (void)alertWaitWithTitle:(NSString *)title  message:(NSString *)message  cancelButtonTitle:(NSString *)cancelButtonTitle{
    self.alertWait = [[UIAlertView alloc]initWithTitle:title message:message
                                              delegate:self
                                     cancelButtonTitle:cancelButtonTitle
                                     otherButtonTitles:nil];
    //    if (cancelButtonTitle) {
    //        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
    //                                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //        indicator.center = CGPointMake(self.alertWait.bounds.size.width/2.0f, self.alertWait.bounds.size.height/2.0f);
    //        indicator.frame = CGRectMake(20, 20, self.alertWait.bounds.size.width-40, self.alertWait.bounds.size.height-40);
    //        [indicator startAnimating];
    //        [self.alertWait addSubview:indicator];
    //    }
    
    [self.alertWait show];
}

#pragma mark - getters and setters

- (User *)user{
    if(nil ==_user){
        _user = [[User alloc]initWithNSUserDefaults];
    }
    return _user;
}




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
        _loginButton = [UIButton buttonWithStyle:StrapSuccessStyle
                                        andTitle:@"登录"
                                        andFrame:CGRectMake(20, 300, kButtonWidth, kButtonHeight)
                                          target:self
                                          action:@selector(GoToLogin)];
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

- (UITextView *)location{
    if (nil==_location) {
        _location = [[UITextView alloc]init];
        _location.textAlignment = NSTextAlignmentLeft;
        _location.font = [UIFont systemFontOfSize:14];
//        _location.placeholder = @"请输入考勤地点";
//        _location.clearButtonMode = UITextFieldViewModeWhileEditing;
        _location.textColor = [UIColor blackColor];
//        _location.borderStyle = UITextBorderStyleRoundedRect;
        _location.returnKeyType = UIReturnKeyDone;
        _location.tag = 0;
        _location.delegate = self;
        _location.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _location.layer.borderColor = [UIColor grayColor].CGColor;
        _location.layer.cornerRadius = 6;
        _location.layer.borderWidth = 1.0;
    }
    return _location;
}

- (UIButton *)kaoQinButton {
    if(nil == _kaoQinButton){
        _kaoQinButton = [UIButton buttonWithStyle:StrapPrimaryStyle
                                         andTitle:@"考勤"
                                         andFrame:CGRectMake(0, 0, kButtonWidth,kButtonHeight)
                                           target:self
                                           action:@selector(KaoQin)];
    }
    
    return _kaoQinButton;
}

- (UIButton *)getLocationHistory{
    if(nil==_getLocationHistory){
        _getLocationHistory = [UIButton buttonWithStyle:StrapPrimaryStyle
                                               andTitle:@"考勤记录"
                                               andFrame:CGRectMake(0, 0, kButtonWidth, kButtonHeight)
                                                 target:self
                                                 action:@selector(KaoQinHistory)];
    }
    return _getLocationHistory;
}
@end
