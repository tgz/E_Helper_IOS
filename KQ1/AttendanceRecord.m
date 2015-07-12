//
//  AttendanceRecord.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/13.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "AttendanceRecord.h"

@implementation AttendanceRecord


- (NSString *)description{
    return [[NSString alloc]initWithFormat:@"地点:%@,时间:%@",self.AttendLocation,self.AttendTime];
}
@end
