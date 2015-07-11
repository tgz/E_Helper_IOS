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
@property (nonatomic,assign) BOOL isLogin;

+ (instancetype)userFromNSUserDefaults;
- (instancetype)initWithNSUserDefaults;

+ (BOOL)saveUserInfoWithName:(NSString *)userName
                     loginID:(NSString *)loginID
                    userGuid:(NSString *)userGuid
                      oUName:(NSString *)ouName;

+ (void)saveUserInfo:(User *)user;

- (User *)loginWithUserName:(NSString *)userName
                   password:(NSString *)password;
@end
