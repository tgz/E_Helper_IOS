//
//  UserLoginResult.h
//  KQ1
//
//  Created by 邱 士川 on 15/7/11.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;
@interface UserLoginResult : NSObject
@property(nonatomic,copy)NSString *loginDescription;

- (instancetype)initWithResultContent:(NSString *)resultString;
- (BOOL)analyseLoginResultToUser:(User *)user;
@end
