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
#import "AppDelegate.h"
#import  "UserDal.h"

@interface SwicthUserViewController()

@property(strong,nonatomic)UITableView *userList;
@property(strong,nonatomic)AppDelegate *appDelegate;
@property(nonatomic,strong)NSArray *userArray;
@end

@implementation SwicthUserViewController

#pragma mark - property

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"用户切换"];
    
    ///右侧的添加按钮
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target:self action:@selector(goToLogin)];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
    
    ///左侧的编辑按钮
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                target:self
                                                                                action:@selector(editUserList)];
    [self.navigationItem setLeftBarButtonItem:leftBarItem];
    
    
    
    
    /**添加通知--->切换页面**/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchPage)
                                                 name:@"SC_UserChanged" object:nil];
    
    
    [self.view addSubview:self.userList];
    
   
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UserDal *userDal =  [[UserDal alloc]init];
    
    self.userArray = [userDal loadUserList];
    
    [self.userList reloadData];
}


#pragma mark - UITabViewDelegate
/**仅有一个section的情况下，此方法可以省略*/
//- (int)numberOfSectionsInTableView:(nonnull UITableView *)tableView {
//    return 1;
//}

- (int)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return self.userArray.count;
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
    User *user = [self.userArray objectAtIndex:indexPath.row];
    
    [User saveUserInfo:user ];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SC_UserChanged" object:nil];
    NSLog(@"发出通知--->SC_UserChanged");
    
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
    
    User *user = [self.userArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = user.userName;
    cell.detailTextLabel.text = user.ouName;
//    cell.textLabel.numberOfLines=2;
//    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    return  cell;
}
/**实现了此方法，左滑会显示删除按钮*/
- (void)tableView:(nonnull UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"delete %dscetion %drow",indexPath.section,indexPath.row);
        // userList removeObject:
    //    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
        
    }else if (editingStyle == UITableViewCellEditingStyleInsert){
        NSLog(@"insert %d section %d row",indexPath.section,indexPath.row);
    }
    
}
/**只要实现这个方法在编辑状态右侧就有排序图标*/
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
//    KCContactGroup *sourceGroup =_contacts[sourceIndexPath.section];
//    KCContact *sourceContact=sourceGroup.contacts[sourceIndexPath.row];
//    KCContactGroup *destinationGroup =_contacts[destinationIndexPath.section];
//    
//    [sourceGroup.contacts removeObject:sourceContact];
//    if(sourceGroup.contacts.count==0){
//        [_contacts removeObject:sourceGroup];
//        [tableView reloadData];
//    }
//    
//    [destinationGroup.contacts insertObject:sourceContact atIndex:destinationIndexPath.row];
    NSLog(@"remove %dSection %drow to %dSection %drow",
          sourceIndexPath.section,sourceIndexPath.row,destinationIndexPath.section,destinationIndexPath.row);
}

#pragma mark - CustumDelegate

#pragma mark - event Response
- (IBAction)goToLogin {
    NSLog(@"goToLogin!");
    LoginViewController *loginVC = [[LoginViewController alloc]init];
   
    [loginVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:loginVC animated:YES completion:nil];
    
}

- (void)editUserList {
    [self.userList setEditing:!self.userList.isEditing animated:YES];
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
