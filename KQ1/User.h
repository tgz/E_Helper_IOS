//
//  User.h
//  KQ1
//
//  Created by 邱 士川 on 15/7/6.
//  Copyright (c) 2015年 qsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic,strong) NSString *loginID,*userName, *userGuid ,*ouName;

+ (instancetype)userFromNSUserDefaults;
- (instancetype)initWithNSUserDefaults;

+ (void)saveUserInfoWithName:(NSString *)userName
                  andLoginID:(NSString *)loginID
                 andUserGuid:(NSString *)userGuid
                   andOUName:(NSString *)ouName;
@end
