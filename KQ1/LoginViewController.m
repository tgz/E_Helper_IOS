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

#define kPadding 20

@interface LoginViewController() <UITextFieldDelegate>
@property(nonatomic,strong)UITextField *loginID;
@property(nonatomic,strong)UITextField *password;


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
    
    
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField
{
    NSInteger index = textField.tag;
    [textField resignFirstResponder];
    if(index<1){
        [self.password becomeFirstResponder];
    }
    return YES;
}
#pragma mark - CustumDelegate

#pragma mark - event Response
- (void)LoginBtnPress{
    NSLog(@"loginPress!");
    //按下登陆按钮时，关闭键盘;
    [self.view endEditing:YES];
    
    User *user = [[User alloc] loginWithUserName:self.loginID.text password:self.password.text];
    
}

-(void)CancleBtnPress{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"CanclePress");
}

- (void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - private methods

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

    }
    return _password;
}
@end
