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


@interface ZeroReportViewController ()

@property(nonatomic,strong) UIButton *btn;
@property(nonatomic,strong) User *user;
@property(nonatomic,strong) NSDate *dateSelected;
@property(nonatomic,strong)NSDateFormatter *dateFormatter;
@property(nonatomic,strong)UIAlertView *alertWait;
@property(nonatomic,strong)NSMutableDictionary *eventsByDate;
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
    
}

-  (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //self.btn.frame = CGRectMake(30, 80, 100, 30);
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
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    // Your method to test if a date have an event for example
    if([self haveEventForDay:dayView.date]){
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
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
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
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}
@end
