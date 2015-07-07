//
//  LoginViewController.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/7.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "LoginViewController.h"
#import "import.h"

@interface LoginViewController ()
@property(nonatomic,strong)UITextField *loginID;
@property(nonatomic,strong)UITextField *password;

@property(nonatomic,strong)UILabel *labelID;
@property(nonatomic,strong)UILabel *labelPW;

@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,strong)UIButton *cancleBtn;

@end

@implementation LoginViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.cancleBtn];

    NSLog(@"LoginViewController-viewDidLoad");
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.loginBtn.center = CGPointMake(self.view.center.x - kScreenWidth/5, self.view.frame.size.height-kBorderBottom);
    self.cancleBtn.center = CGPointMake(self.view.center.x +kScreenWidth/5, self.view.frame.size.height-kBorderBottom);
    
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
- (void)LoginBtnPress{
    NSLog(@"loginPress!");
}

-(void)CancleBtnPress{
    [self dismissViewControllerAnimated:YES completion:^{}];
    NSLog(@"CanclePress");
}
#pragma mark - private methods

#pragma mark - getters and setters
-(UIButton *)loginBtn{
    if(nil==_loginBtn){
        _loginBtn = [UIButton buttonWithStyle:StrapPrimaryStyle
                                     andTitle:@"登陆"
                                     andFrame:CGRectMake(0, 0, kButtonWidth, kButtonHeight)
                                       target:self
                                       action:@selector(LoginBtnPress)];
        
    }
    return _loginBtn;
}
- (UIButton *)cancleBtn{
    if(nil==_cancleBtn){
        _cancleBtn = [UIButton buttonWithStyle:StrapInfoStyle andTitle:@"取消" andFrame:CGRectMake(0, 0, kButtonWidth, kButtonHeight) target:self action:@selector(CancleBtnPress)];
    }
    return _cancleBtn;
}
@end
