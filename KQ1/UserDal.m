//
//  UserDal.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/21.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "UserDal.h"
#import "AppDelegate.h"
#import "User.h"
#import <CoreData/CoreData.h>

@interface UserDal()
@property(nonatomic,strong)AppDelegate *appDelegate;

@end

@implementation UserDal




- (void)InsertUser:(User *)user {
    //插入数据
    User *myuser=(User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.appDelegate.managedObjectContext];
    [myuser setUserName:user.userName];
    [myuser setUserGuid:user.userGuid];
    [myuser setOuName:user.ouName];
    
    NSError* error;
    BOOL isSaveSuccess=[self.appDelegate.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }else{
        NSLog(@"Save successful! %@,%@,%@,%d",myuser.ouName,myuser.userName,myuser.userGuid,myuser.isLogin);
    }
}

- (NSArray *)loadUserList {
    //获取托管对象上下文
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    //创建FetchRequset
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    //创建实体 相当于表
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    //设置查询实体
    [fetchRequest setEntity:entityDescription];
    //排序描述
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"orderNum" ascending:YES];
    NSArray *sortArray = [[NSArray alloc]initWithObjects:sortDescriptor ,nil];
    [fetchRequest setSortDescriptors:sortArray];
    //创建查询条件
    //   NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name like %@)",@"李"];
    //    [fetchRequest setPredicate:pred]
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest
                                                                                             error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry: %i",[mutableFetchResult count]);
    for (User* user in mutableFetchResult) {
        NSLog(@"name:%@----guid:%@------ou:%@",user.userName,user.userGuid,user.ouName);
    }
    return [mutableFetchResult copy];
}


- (AppDelegate *)appDelegate {
    if (_appDelegate == nil) {
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    }
    return _appDelegate;
}
@end
