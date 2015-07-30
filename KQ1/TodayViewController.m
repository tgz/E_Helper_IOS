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
#import "AttendLocationViewController.h"
#import "ZeroReport.h"
#import "LocationViewController.h"


@interface TodayViewController () <UITextFieldDelegate,UITextViewDelegate,TodayViewPassValueDelegate>
@property (nonatomic,strong)UILabel *userInfo;
@property (nonatomic,strong)UIButton *loginButton;
@property (nonatomic,strong)UILabel *ouName;
@property (nonatomic,strong)UITextView *location;
@property (nonatomic,strong)UIButton *kaoQinButton;
@property (nonatomic,strong)User *user;
@property (nonatomic,strong)UIButton *getLocationHistory;
@property (nonatomic,strong)UIButton *zeroReport;

@property (nonatomic,strong)UIButton *openMap;

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
    /**用户登录按钮屏蔽，自动判断是否需要跳转*/
    //[self.view addSubview:self.loginButton];
    [self.view addSubview:self.ouName];
    
    [self.view addSubview:self.location];
    [self.view addSubview:self.kaoQinButton];
    
    [self.view addSubview:self.getLocationHistory];
    [self.view addSubview:self.zeroReport];
    
    [self.view addSubview:self.openMap];

    
    [self.ouName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.top.equalTo(self.userInfo.mas_bottom);
    }];
    
   
    
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.mas_equalTo(self.view).width.offset(20);
        //        make.right.mas_equalTo(self.view).width.offset(-20);
        
        //make.centerX.equalTo(self.view);
        make.leading.equalTo(self.view).with.offset(8);
        
        make.height.mas_equalTo(@50);
        make.top.equalTo(self.ouName.mas_bottom).with.offset(10);
        
        make.width.equalTo(self.view).with.offset(-60);
        
    }];
    [self.openMap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.location.mas_centerY);
        make.trailing.equalTo(self.view).with.offset(-10);
    }];
    
    ///隐藏基项部导航栏
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    /**添加通知监听--是否变更用户*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadUserFromUserDefaults)
                                                 name:@"SC_UserChanged" object:nil];
    
    /**添加通知---变更地点*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocation:) name:@"SC_LocationNew" object:nil];

    //self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",9];
}

/**
 *  手动移除通知监听
 */
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewWillLayoutSubviews{
    NSLog(@"TodayVC---> viewWillLayoutSubviews");
    [super viewWillLayoutSubviews];
    
    self.userInfo.frame = CGRectMake(20, 40, self.view.frame.size.width-40, 40);
    
    /**用户登录按钮屏蔽，自动判断是否需要跳转*/
    //self.loginButton.center = CGPointMake(kScreenWidth/6, kScreenHeight - kBorderBottom);
    
    self.zeroReport.center = CGPointMake(kScreenWidth/2, kScreenHeight-kBorderBottom);
    
    self.kaoQinButton.center = CGPointMake(kScreenWidth*5/6, kScreenHeight - kBorderBottom);
    
    self.getLocationHistory.center = CGPointMake(kScreenWidth/6, kScreenHeight-kBorderBottom);
    
//    self.openMap.center = CGPointMake(kScreenWidth/2, kScreenHeight-kBorderBottom*2);
//    self.openMap.frame = CGRectMake(kScreenWidth/2, kScreenHeight-kBorderBottom*2, 48, 48);
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
    
    /**如果没有用户Guid 则说明没有登录过，跳转到登陆界面*/
    if (!self.user.isLogin) {
        [self GoToLogin];
    }
    
    
    //隐藏顶部导航栏动画
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.userInfo.text = self.user.userName;
    self.ouName.text = self.user.ouName;
    NSLog(@"viewWillAppear：读取用户信息：%@,%@,%@,%d",self.user.userName , self.user.userGuid, self.user.ouName , self.user.isLogin);
  
    if ([self.location.text isEqualToString:@""]) {
        NSString *lastLocation = [Locator ReadLocation];
        if (![lastLocation isEqualToString:@""]) {
            lastLocation = @"草场门大街88号东门江苏建设大厦附近";
            self.location.textColor = [UIColor blackColor];
        }else{
            self.location.textColor = [UIColor blackColor];
        }
        self.location.text = lastLocation;
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - AlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==0)
    {
        if(buttonIndex==1)
        {
            [self KaoQin];
        }
        return;
    }
    if (alertView.tag==1) {
        if (buttonIndex==1) {
            [self reportZero];
        }
        return;
    }
}

- (void)beforeKaoQin{
    NSString *message = [NSString stringWithFormat:@"确认考勤？"];
    UIAlertView *confirmAlert = [[UIAlertView alloc]initWithTitle:@"提醒：" message:message  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
    confirmAlert.tag=0;
    [confirmAlert show];
}
- (void)beforeReportZero{
    NSString *message = [NSString stringWithFormat:@"确认填写零报告？"];
    UIAlertView *confirmAlert = [[UIAlertView alloc]initWithTitle:@"提醒：" message:message  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
    confirmAlert.tag=1;
    [confirmAlert show];
}

#pragma mark - CustumDelegate
- (void)passUser:(User *)user {
    self.user.userName = user.userName;
    self.user.userGuid = user.userGuid;
    self.user.ouName = user.ouName;
    self.user.isLogin = user.isLogin;
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldEndEditing:(nonnull UITextView *)textView {
    [textView resignFirstResponder];
    if (textView.tag == 0 && [textView.text length]==0) {
        textView.text = @"请输入地点";
        textView.textColor = [UIColor lightGrayColor];
        
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(nonnull UITextView *)textView {
    if (textView.tag == 0 && [textView.text isEqualToString:@"请输入地点"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}


//- (void)textViewDidChange:(nonnull UITextView *)textView {
//    if (textView.tag == 0 && [textView.text length]==0) {
//        textView.text = @"请输入地点";
//        textView.textColor = [UIColor lightGrayColor];
//        
//    }
//}

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
    loginVC.delegate = self;
    [loginVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:loginVC animated:YES completion:nil];
    
}

- (void)goToMap{
    NSLog(@"OpenMap");
    LocationViewController *mapVC = [[LocationViewController alloc]init];
    //UINavigationController *mapNC = [[UINavigationController alloc]initWithRootViewController:mapVC];
    [mapVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:mapVC animated:YES completion:nil];
}



/**
 *  考勤
 */
- (void)KaoQin{
    NSLog(@"Kaoqin!");
    //如果没有地点，不进行考勤。
    if ([self.location.text isEqualToString:@""]) {
        [self alertWaitWithTitle:@"警告！" message:@"未输入考勤地点！" cancelButtonTitle:@"确定"];
        return;
    }
    
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
                
                if (array.count > 0) {
                    [self gotoAttendHistory:array];
                } else {
                    [self alertWaitWithTitle:@"获取记录成功！" message:@"没有考勤记录！" cancelButtonTitle:@"确定"];
                }
                
                return;
                /**以下弹出提示框的方法舍弃*/
                /*
                NSMutableString *message = [[NSMutableString alloc]init];
                
                [array enumerateObjectsUsingBlock:^(id  __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
                    [message appendString:[NSString stringWithFormat:@"%@\n",obj]];
                }];
                if ([message isEqualToString:@""]) {
                    [message setString: @"没有记录！"];
                }
                [self alertWaitWithTitle:@"考勤成功！" message:message cancelButtonTitle:@"确定"];
                */
                
            }else{
                [self.alertWait dismissWithClickedButtonIndex:0 animated:NO];
                [self alertWaitWithTitle:@"考勤失败！" message:locator.failDescription cancelButtonTitle:@"确定"];
            }
        });
    });

   
}

/**
 *  查询考勤记录
 */
- (void)KaoQinHistory{
    NSLog(@"KaoqinHistory!");
    
    
    /*
     *以下为直接查询考勤历史的方法。
     *替换为打开新页面，List页面展示考勤历史。
     *
     */
    
    
    
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

                /**弹窗提醒的方法*/
//                NSMutableString *message = [[NSMutableString alloc]init];
//                
//                [array enumerateObjectsUsingBlock:^(id  __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
//                    [message appendString:[NSString stringWithFormat:@"%@\n",obj]];
//                }];
//                if ([message isEqualToString:@""]) {
//                    [message setString: @"没有记录！"];
//                }
                //[self alertWaitWithTitle:@"获取记录成功！" message:message cancelButtonTitle:@"确定"];
                
                
                /**跳转到TableView的方法*/
                /**补充：如果没有考勤过，则弹出提示*/
                if(array.count<1){
                    [self alertWaitWithTitle:@"获取记录成功！" message:@"没有考勤记录！" cancelButtonTitle:@"确定"];
                } else {
                    [self gotoAttendHistory:array];
                   
                }
            } else {
                [self.alertWait dismissWithClickedButtonIndex:0 animated:NO];
                [self alertWaitWithTitle:@"获取记录失败！" message:locator.failDescription cancelButtonTitle:@"确定"];
                
            }
            
        });
    });
    
}

- (void)touchesBegan:(nonnull NSSet *)touches withEvent:(nullable UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)tabBar:(nonnull UITabBar *)tabBar didSelectItem:(nonnull UITabBarItem *)item {
    
    NSLog(@"-----%ldTodayView_response_Clicked",(long)item.tag);
    
    
}

/**
 *  零报告
 */
- (void)reportZero {
    
    [self alertWaitWithTitle:@"真在零报告" message:@"请稍后..." cancelButtonTitle:nil];
    
    //按下按钮时，关闭键盘;
    [self.view endEditing:YES];
    
    
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        ZeroReport *zeroReport = [[ZeroReport alloc]init];
        NSDate *data = [NSDate date];
        BOOL success = [zeroReport reportZero:data UserGuid:self.user.userGuid];
        
        dispatch_async(main_queue, ^{
            [self.alertWait dismissWithClickedButtonIndex:0 animated:NO];
            if (success) {
                NSLog(@"零报告成功");
                 [self alertWaitWithTitle:@"零报告成功！" message:nil cancelButtonTitle:@"确定"];
                //TODO 零报告查询
            }else {
                [self alertWaitWithTitle:@"零报告失败！" message:zeroReport.failDescription cancelButtonTitle:@"确定"];
            }
            
        });
    });
    
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

- (void)gotoAttendHistory:(NSArray *)attendRecord {
    AttendLocationViewController *alvc = [[AttendLocationViewController alloc]init];
    alvc.locations = attendRecord;
    [self.navigationController pushViewController:alvc animated:YES];
}

/**
 *  重新加载用户
 */
- (void)reloadUserFromUserDefaults {
    self.user = [User userFromNSUserDefaults];
    
    NSLog(@"收到通知--->SC_UserChanged---->重新加载用户");
}

/**
 *  收到通知后，更新界面数据
 *
 *  @param notification 通知消息
 */
- (void)updateLocation:(NSNotification *)notification {
    NSLog(@"收到通知-->SC_LocationNew --> %@%@%@",notification.name,notification.object,notification.userInfo);
    
    NSString *location = [notification.userInfo objectForKey:@"Location"];
    self.location.text = location;
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
        _location.font = [UIFont systemFontOfSize:15];
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
                                           action:@selector(beforeKaoQin)];
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

- (UIButton *)zeroReport {
    if (_zeroReport == nil) {
        _zeroReport = [UIButton buttonWithStyle:StrapPrimaryStyle andTitle:@"零报告" andFrame:CGRectMake(0, 0, kButtonWidth,kButtonHeight) target:self action:@selector(beforeReportZero)];
    }
    return _zeroReport;
}

- (UIButton *)openMap {
    if (_openMap == nil) {
//        _openMap = [UIButton buttonWithStyle:StrapPrimaryStyle andTitle:@"地图" andFrame:CGRectMake(0, 0, kButtonWidth, kButtonHeight) target:self action:@selector(goToMap)];

        _openMap = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2, kScreenHeight-kBorderBottom*2, 48, 48)];
        [_openMap addTarget:self action:@selector(goToMap) forControlEvents:UIControlEventTouchUpInside];
        [_openMap setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
        
    }
    return _openMap;
}



@end
