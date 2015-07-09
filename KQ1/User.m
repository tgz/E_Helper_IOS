//
//  User.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/6.
//  Copyright (c) 2015年 qsc. All rights reserved.
//

#import "User.h"

@implementation User


+ (User*)userFromNSUserDefaults{
    return [[self alloc] initWithNSUserDefaults];
}

- (User*)initWithNSUserDefaults{
    if(self = [super init]){
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
        self.loginID = [userDefaults valueForKey:@"LoginID"];
        self.userGuid = [userDefaults valueForKey:@"UserGuid"];
        self.userName = [userDefaults valueForKey:@"UserName"];
    }
    return self;
}


@end
