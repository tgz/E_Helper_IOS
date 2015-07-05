//
//  ZeroReportViewController.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/5.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "ZeroReportViewController.h"

@interface ZeroReportViewController ()

@property(nonatomic,strong) UIButton *btn;

@end

@implementation ZeroReportViewController
#pragma mark -property



#pragma mark -life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    [self.view addSubview:self.btn];
    
    UITabBarItem *barItem = [[UITabBarItem alloc]initWithTitle:@"零报告" image:[UIImage imageNamed:@"task_normal.png"] selectedImage:[UIImage imageNamed:@"task_selected.png"]];
    self.tabBarItem = barItem;
    
    
}

-  (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.btn.frame = CGRectMake(30, 50, 100, 30);
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

#pragma mark -CustumDelegate

#pragma mark -event Response

#pragma mark -private methods

#pragma mark -getters and setters

-(UIButton *) btn{
    if(_btn==nil){
        _btn = [[UIButton alloc]init];
        [_btn setTitle:@"testAdd" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    return _btn;
}

@end
