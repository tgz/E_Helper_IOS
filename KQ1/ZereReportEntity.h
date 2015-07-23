//
//  ZereReportEntity.h
//  KQ1
//
//  Created by 邱 士川 on 15/7/21.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZereReportEntity : NSObject
@property (nonatomic,copy)NSString *recordDate;
@property (nonatomic,assign)BOOL isNullProblem;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *Content;
@end
