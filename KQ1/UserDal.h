//
//  UserDal.h
//  KQ1
//
//  Created by 邱 士川 on 15/7/21.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

@interface UserDal : NSObject

- (void)InsertUser:(User *)user ;
- (NSArray *)loadUserList;
@end
