//
//  LoginViewController.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/7.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "LoginViewController.h"
#import "import.h"
#import "User.h"
#import "Masonry.h"
#import "TodayViewController.h"
#import "UserDal.h"
#define kPadding 20

@interface LoginViewController() <UITextFieldDelegate>
@property(nonatomic,strong)UITextField *loginID;
@property(nonatomic,strong)UITextField *password;


@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,strong)UIButton *cancleBtn;

@property(nonatomic,strong)UIAlertView *alertWait;

@end

@implementation LoginViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.cancleBtn];
    [self.view addSubview:self.loginID];
    [self.view addSubview:self.password];

    
    
    
}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.loginBtn.center = CGPointMake(self.view.center.x - kScreenWidth/5, self.view.frame.size.height/3+kBorderBottom);
    self.cancleBtn.center = CGPointMake(self.view.center.x +kScreenWidth/5, self.view.frame.size.height/3+kBorderBottom);
    
    CGPoint loginCenter = CGPointMake(self.view.center.x, kScreenHeight/5);
    CGPoint passwordCenter = CGPointMake(self.view.center.x, kScreenHeight/5+50);
    
    self.loginID.center = loginCenter;
    self.password.center = passwordCenter;
    
    if (![User userFromNSUserDefaults].isLogin){
        /**不存在已登陆用户，取消按钮隐藏*/
        [self.cancleBtn removeFromSuperview];
        self.loginBtn.center = CGPointMake(self.view.center.x, self.view.frame.size.height/3+kBorderBottom);
    }
    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
}

#pragma mark - CustumDelegate

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField{
    NSInteger index = textField.tag;
    [textField resignFirstResponder];
    if(index<1){
        [self.password becomeFirstResponder];
    }
    return YES;
}


#pragma mark - event Response
- (void)LoginBtnPress{

    [self alertWaitWithTitle:@"正在登陆中..." message:nil cancelButtonTitle:nil];
    
    //按下登陆按钮时，关闭键盘;
    [self.view endEditing:YES];
    
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        User *user = [[User alloc] loginWithUserName:self.loginID.text password:self.password.text];
        dispatch_async(main_queue, ^{
            //通过delegate将登录后的User传到第一个页面。
            
            //设置了代理的话，执行代理方法--->设置已登陆的用户。
            if (self.delegate) {
                [self.delegate passUser:user];
            }else { ///未设置代理对象，则发送通知
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SC_UserChanged" object:nil];
                NSLog(@"发出通知--->SC_UserChanged");
            }
            
            if(user.isLogin){
                //登陆成功后，回到主界面
                ///保存到数据库
                UserDal *userDal =  [[UserDal alloc]init];
                [userDal InsertUser:user];
                
                [self.alertWait dismissWithClickedButtonIndex:0 animated:NO];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                 [self.alertWait dismissWithClickedButtonIndex:0 animated:NO];
                [self alertWaitWithTitle:@"登陆失败！" message:user.failDescription cancelButtonTitle:@"确定"];
            }
        });
    });
}

-(void)CancleBtnPress{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"CanclePress");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
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
- (UIButton *)loginBtn{
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

- (UITextField *)loginID{
    if(nil == _loginID){
        _loginID = [[UITextField alloc]init];
        _loginID.placeholder = @"请输入登陆名";
        _loginID.frame = CGRectMake(0, 0, kScreenWidth-2*kPadding, 40);
        [_loginID setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_loginID setFont:[UIFont systemFontOfSize:16]];
        _loginID.tag=0;
        _loginID.returnKeyType = UIReturnKeyNext;
        _loginID.borderStyle = UITextBorderStyleRoundedRect;
        _loginID.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _loginID.delegate =self;
    }
    return _loginID;
}

- (UITextField *)password{
    if(nil==_password){
        
        _password = [[UITextField alloc]init];
        _password.placeholder = @"请输入登陆密码";
        _password.frame  = CGRectMake(0, 0, kScreenWidth-2*kPadding, 40);
        [_password setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_password setFont:[UIFont systemFontOfSize:16]];
        _password.tag=1;
        _password.returnKeyType = UIReturnKeyDone;
        _password.borderStyle = UITextBorderStyleRoundedRect;
        _password.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _password.delegate = self;
        _password.secureTextEntry =YES;

    }
    return _password;
}
@end
