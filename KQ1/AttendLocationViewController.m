//
//  AttendLocationViewController.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/13.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "AttendLocationViewController.h"
#import "import.h"
#import "LoginViewController.h"
#import "AttendanceRecord.h"

@interface AttendLocationViewController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSUInteger rows;


@end

@implementation AttendLocationViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self setTitle:@"考勤记录"];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    //显示出NavigationBar
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    /*UIBarButtonItem 左侧按钮
     *
     *
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                target:self action:nil];
    [self.navigationItem setLeftBarButtonItem:leftBarItem];
    */
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target:self action:@selector(goToLogin)];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
    
    /*如果没有 self setTitle:@"" 则可以这里设置Bar的标题*/
    //[self.navigationItem setTitle:@"考勤记录"];
    
    //[self.navigationItem setBackBarButtonItem:rightBarItem];
    
    /*此处可以自定义Title显示的为segmentController/Button/其它*/
    // self.navigationItem.titleView = xxView
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.rows = [self.locations count];
}

#pragma mark - UITabViewDelegate
- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rows;
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //NSString *userInfo = [[NSString alloc]initWithFormat:@"地点地点地点地点地点%d",indexPath];
//    NSString *userInfo = @"地点地点地点地点地点地点"+  indexPath ;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        //
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    AttendanceRecord *record = [self.locations objectAtIndex:indexPath.row];
    cell.textLabel.text = record.AttendLocation;
    cell.detailTextLabel.text = record.AttendTime;
    return  cell;
}

- (NSString *)tableView:(nonnull UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    //if (tableView==self.tableView) {
        if (section == 0) {
            return @"已考勤记录列表";
        }else {
            return @"无标题";
        }
    //}
}


#pragma mark - CustumDelegate

#pragma mark - event Response
- (IBAction)goToLogin {
    NSLog(@"goToLogin!");
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    loginVC.delegate = self;
    [loginVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:loginVC animated:YES completion:nil];

}
#pragma mark - private methods

#pragma mark - getters and setters


@end
