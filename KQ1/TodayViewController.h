//
//  TodayViewController.h
//  KQ1
//
//  Created by 邱 士川 on 15/7/5.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

@interface TodayViewController : UIViewController

@end


@protocol TodayViewPassValueDelegate

- (void)passUser:(User *)user;

@end