//
//  AttendLocationViewController.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/13.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "AttendLocationViewController.h"
#import "import.h"

@interface AttendLocationViewController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSUInteger rows;


@end

@implementation AttendLocationViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.navigationController setTitle:@"考勤记录"];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-44)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
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
    return 50;
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
    cell.textLabel.text = @"location----";
    return  cell;
}


#pragma mark - CustumDelegate

#pragma mark - event Response

#pragma mark - private methods

#pragma mark - getters and setters


@end
