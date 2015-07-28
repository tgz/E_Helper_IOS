//
//  LocationViewController.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/28.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "LocationViewController.h"
#import <BaiduMapAPI/BMapKit.h>



@interface LocationViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property(strong,nonatomic)BMKLocationService *locationService;
@end

@implementation LocationViewController

#pragma mark - lifeCycle

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(!self){
        return nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.mapView.showsUserLocation = NO;
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [self.locationService startUserLocationService];
    self.mapView.showsUserLocation=NO;
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
    self.mapView.showsUserLocation = YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - BDMap
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}


#pragma mark - getters and setters


- (BMKLocationService *)locationService{
    if(_locationService ==nil){
        _locationService = [[BMKLocationService alloc]init];
    }
    return _locationService;
}
@end
