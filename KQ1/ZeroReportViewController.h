//
//  ZeroReportViewController.h
//  KQ1
//
//  Created by 邱 士川 on 15/7/5.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>

@interface ZeroReportViewController : UIViewController<JTCalendarDelegate>

@property (nonatomic,weak) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (nonatomic,weak) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@end
