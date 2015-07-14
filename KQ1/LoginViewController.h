//
//  LoginViewController.h
//  KQ1
//
//  Created by 邱 士川 on 15/7/7.
//  Copyright © 2015年 qsc. All rights reserved.
//
#import "TodayViewController.h"
#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (nonatomic,weak)id<TodayViewPassValueDelegate> delegate;
@end
