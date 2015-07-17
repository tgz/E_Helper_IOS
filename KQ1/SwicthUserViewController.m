//
//  SwicthUserViewController.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/16.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "SwicthUserViewController.h"
#import "LoginViewController.h"
#import "User.h"
@implementation SwicthUserViewController

#pragma mark - property

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"用户管理"];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target:self action:@selector(goToLogin)];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
    
}

#pragma mark - UITabViewDelegate

#pragma mark - CustumDelegate

#pragma mark - event Response
- (IBAction)goToLogin {
    NSLog(@"goToLogin!");
    LoginViewController *loginVC = [[LoginViewController alloc]init];
   
    [loginVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:loginVC animated:YES completion:nil];
    
}
#pragma mark - private methods

#pragma mark - getters and setters


@end
