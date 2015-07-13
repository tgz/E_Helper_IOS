//
//  Locator.h
//  KQ1
//
//  Created by 邱 士川 on 15/7/12.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Locator : NSObject
@property (nonatomic,copy) NSString *location,*userGuid,*locateTime,*failDescription;
@property (nonatomic,assign) BOOL isSuccess;
@property (nonatomic,strong) NSMutableArray *locations;

- (instancetype)initWithUser:(NSString *)userGuid location:(NSString *)location;
+ (instancetype)locatorWithUser:(NSString *)userGuid location:(NSString *)location;
- (void)kaoQin;
- (void)getAttendanceRecord;

+(BOOL)DoKaoQin:(NSString *)Location UserGuid:(NSString *)userGuid;
+(NSString *)DoKaoQin4XML:(NSString *)Location UserGuid:(NSString *)userGuid;
+(NSString *)ReadLocation;
+(BOOL)SaveLocation:(NSString *)location;
@end
