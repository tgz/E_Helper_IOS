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
#import <JTDateHelper.h>

@interface ZeroReportViewController (){
UIAlertView *remoteAlertView;
}

@property(nonatomic,strong) UIButton *btn;
@property(nonatomic,strong) User *user;
@property(nonatomic,strong) NSDate *dateSelected;
@property(nonatomic,strong) NSDateFormatter *dateFormatter;
@property(nonatomic,strong) UIAlertView *alertWait;
@property(nonatomic,strong) NSDictionary *statusByDate;
@end

@implementation ZeroReportViewController
#pragma mark - property



#pragma mark - life cycle
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(!self){
        return nil;
    }
    
    self.title = @"零报告查询";
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.btn];
    
//    UITabBarItem *barItem = [[UITabBarItem alloc]initWithTitle:@"零报告" image:[UIImage imageNamed:@"task_normal.png"] selectedImage:[UIImage imageNamed:@"task_selected.png"]];
//    self.tabBarItem = barItem;
    
    [self.view addSubview:self.calendarMenuView];
    [self.view addSubview:self.calendarContentView];
    
    self.calendarMenuView.frame = CGRectMake(0, 100, kScreenWidth, 100);
    self.calendarContentView.frame = CGRectMake(0, 200, kScreenWidth, 400);

    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    ///右侧的添加按钮
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                 target:self action:@selector(queryTodayStatus)];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
    
    
    [self loadStatus];
    
    
}

-  (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    
    // Test if the dayView is from another month than the page
    // Use only in month mode for indicate the day of the previous or next month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    // Today
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        //dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    // Your method to test if a date have an event for example
    if([self isZeroReportForDay:dayView.date]){
        dayView.dotView.backgroundColor = [UIColor greenColor];
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
    
    
}
- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    // Use to indicate the selected date
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    // Load the previous or next page if touch a day from another month
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
    
    ZereReportEntity *zeroStatus = [self.statusByDate objectForKey:[self.dateFormatter stringFromDate:_dateSelected]];
    if (!zeroStatus.isNullProblem) {
        NSString *dateStr = [self.dateFormatter stringFromDate:_dateSelected];
        NSString *message = [NSString stringWithFormat:@"确认补填%@的零报告？",dateStr];
        UIAlertView *confirmAlert = [[UIAlertView alloc]initWithTitle:@"提醒：" message:message  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
        confirmAlert.tag=0;
        [confirmAlert show];
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==0)
    {
        if(buttonIndex==1)
        {
            NSLog(@"%@",@"确认补零报告！");
            /**补零报告*/
            [self reportZero:_dateSelected];
        }
    }
}

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


- (BOOL)isZeroReportForDay:(NSDate *)date{
    NSString *key = [[self dateFormatter]stringFromDate:date];
    
    
    if(_statusByDate[key] ){
        ZereReportEntity *reportEntity = [_statusByDate objectForKey:key];
        
        return reportEntity.isNullProblem;
    }
    return NO;
    
}

/**
 *  判断日期是否在Dictionary内
 *
 *  @param date 要判断的日期
 *
 *  @return YES/NO
 */
- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_statusByDate[key]){
        return YES;
    }
    return NO;
}

/**
 *  补填指定日期的零报告
 *
 *  @param date 要补的日期
 */
- (void)reportZero:(NSDate *)date {
    
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        ZeroReport *zeroReport = [[ZeroReport alloc]init];
        BOOL success = [zeroReport reportZero:date UserGuid:self.user.userGuid];
        
        if(success){
            self.statusByDate = nil;
            [self loadStatus];
        }
        
        dispatch_async(main_queue, ^{
            if (success) {
                NSLog(@"零报告成功");
                [self.calendarManager reload];
                [self alertWaitWithTitle:@"零报告成功！" message:[self.dateFormatter stringFromDate:date] cancelButtonTitle:@"确定"];
                //TODO 零报告查询
            }else {
                [self alertWaitWithTitle:@"零报告失败！" message:zeroReport.failDescription cancelButtonTitle:@"确定"];
                
            }
        });
    });
    

    
    
    
}

#pragma mark - LoadMonthData
- (void)loadStatus{
    
    [self alertWaitWithTitle:@"正在加载数据..." message:nil cancelButtonTitle:nil];
    
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        ZeroReport *zeroReport = [[ZeroReport alloc]init];
        
        JTDateHelper *dateHelper = [[JTDateHelper alloc]init];
        NSDate *today = [NSDate date];
        NSDate *toDate = [dateHelper lastDayOfMonth:today];
        NSDate *fromDate = [dateHelper firstDayOfMonth:today];
        
        self.statusByDate = [zeroReport queryZReportStatus:self.user.userGuid fromDate:fromDate toDate:toDate];
        dispatch_async(main_queue, ^{
            
            [self.calendarManager reload];
            
            [self.alertWait dismissWithClickedButtonIndex:0 animated:NO];
           
        });
    });
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

- (JTCalendarManager *)calendarManager {
    if (_calendarManager == nil) {
        _calendarManager = [JTCalendarManager new];
        _calendarManager.delegate = self;
    }
    return _calendarManager;
}
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return dateFormatter;
}
@end
