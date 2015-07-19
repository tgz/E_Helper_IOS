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
#import "import.h"

@interface SwicthUserViewController()

@property(strong,nonatomic)UITableView *userList;

@end

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
    
    /**添加通知--->切换页面**/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchPage)
                                                 name:@"SC_UserChanged" object:nil];
    
    
    [self.view addSubview:self.userList];

    
}


#pragma mark - UITabViewDelegate
/**仅有一个section的情况下，此方法可以省略*/
//- (int)numberOfSectionsInTableView:(nonnull UITableView *)tableView {
//    return 1;
//}

- (int)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 5;
    }else
        return 1;
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        return 60;
    }else {
        return 40;
    }
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSLog(@"选择了%d个Section的第%d行！",indexPath.section,indexPath.row);
}

- (nullable NSString *)tableView:(nonnull UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return @"用户列表";
    }else {
        return @"其它";
    }
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        //
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
//    cell.accessoryType = UITableViewCellAccessoryDetailButton;
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = @"Name";
    cell.detailTextLabel.text = @"OUName";
//    cell.textLabel.numberOfLines=2;
//    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    return  cell;
}



#pragma mark - CustumDelegate

#pragma mark - event Response
- (IBAction)goToLogin {
    NSLog(@"goToLogin!");
    LoginViewController *loginVC = [[LoginViewController alloc]init];
   
    [loginVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:loginVC animated:YES completion:nil];
    
}
#pragma mark - private methods
#pragma mark - Notification

- (void)switchPage {
    [self.tabBarController setSelectedIndex:0];
    NSLog(@"switch--->Tabbar-0");
}


#pragma mark - getters and setters
- (UITableView *)userList {
    if (_userList==nil) {
//        _userList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, kScreenHeight)];
        _userList = [[UITableView alloc]initWithFrame:self.view.bounds];
        _userList.delegate = self;
        _userList.dataSource = self;
    }
    
    return _userList;
}

@end