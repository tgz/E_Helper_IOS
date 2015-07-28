//
//  LocationViewController.h
//  KQ1
//
//  Created by 邱 士川 on 15/7/28.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BMKMapView;
@interface LocationViewController : UIViewController
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
