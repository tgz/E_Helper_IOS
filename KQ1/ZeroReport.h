//
//  ZeroReport.h
//  KQ1
//
//  Created by 邱 士川 on 15/7/21.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZereReportEntity;

@interface ZeroReport : NSObject
@property (nonatomic,assign)BOOL status;
@property (nonatomic,copy)NSString  *failDescription;
@property (nonatomic,strong)NSMutableArray *zReportList;

- (BOOL)reportZero:(NSData *)data UserGuid:(NSString *)userGuid;
- (void)queryZReportStatus:(NSString *)userGuid fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
@end
