//
//  AppDelegate.h
//  KQ1
//
//  Created by 邱 士川 on 15/7/4.
//  Copyright (c) 2015年 qsc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BMKMapManager;
@class CLLocationManager;
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
 BMKMapManager* _mapManager;
}


@property (strong, nonatomic) UIWindow *window;


/**添加CoreData的支持*/

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

