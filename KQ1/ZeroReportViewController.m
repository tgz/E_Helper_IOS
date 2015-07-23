//
//  ZeroReportViewController.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/5.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "ZeroReportViewController.h"
#import "import.h"
#import "ZeroReport.h"
#import "User.h"
#import "ZereReportEntity.h"


@interface ZeroReportViewController ()

@property(nonatomic,strong) UIButton *btn;
@property(nonatomic,strong) User *user;

@property(nonatomic,strong)UIAlertView *alertWait;
@end

@implementation ZeroReportViewController
#pragma mark - property



#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.btn];
    
//    UITabBarItem *barItem = [[UITabBarItem alloc]initWithTitle:@"零报告" image:[UIImage imageNamed:@"task_normal.png"] selectedImage:[UIImage imageNamed:@"task_selected.png"]];
//    self.tabBarItem = barItem;
    
    
}

-  (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.btn.frame = CGRectMake(30, 80, 100, 30);
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
- (void)queryTodayStatus {
    ZeroReport *zeroReport = [[ZeroReport alloc]init];
    NSDate *date = [NSDate date];
    [zeroReport queryZReportStatus:self.user.userGuid fromDate:date toDate:date];
    
    NSArray *zReport = [zeroReport.zReportList copy];
    NSMutableString *message = [[NSMutableString alloc]init];
    [zReport enumerateObjectsUsingBlock:^(ZereReportEntity   *obj, NSUInteger idx, BOOL * __nonnull stop) {
    
        [message appendString:[NSString stringWithFormat:@"%@ -> %@\n",obj.recordDate ,obj.isNullProblem?@"零":@"NO" ]];
    }];
    
    [self alertWaitWithTitle:@"查询结果" message:message cancelButtonTitle:@"确定"];
    


}

#pragma mark - private methods
/**
 *  弹出带标题的提示框
 *
 *  @param title             窗口标题
 *  @param message           提示框主体内容
 *  @param cancelButtonTitle 关闭提示框的按钮名<取消按钮>
 */
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

-(UIButton *) btn{
    if(_btn==nil){
        _btn = [UIButton buttonWithStyle:StrapPrimaryStyle andTitle:@"查询" andFrame:CGRectMake(0, 0, kButtonWidth, kButtonHeight) target:self action:@selector(queryTodayStatus)];
    }
    return _btn;
}
-(User *)user {
    if (_user == nil) {
        _user = [User userFromNSUserDefaults];
    }
    return _user;
}
@end
