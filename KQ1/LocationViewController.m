//
//  LocationViewController.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/28.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "LocationViewController.h"
#import <BaiduMapAPI/BMapKit.h>



@interface LocationViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITableViewDataSource,UITableViewDataSource>

@property(strong,nonatomic)BMKGeoCodeSearch *codeSearch;

@property(strong,nonatomic)BMKLocationService *locationService;
@property(strong,nonatomic)NSArray *poiList;
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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear");
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.locationService.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"ViewDidAppear");
    [self.locationService startUserLocationService];
    self.mapView.showsUserLocation=NO;
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;//BMKUserTrackingModeNone;
    self.mapView.showsUserLocation = YES;
    self.mapView.zoomLevel=15.0;
    
}


- (void)viewWillDisappear:(BOOL)animated{
    
    self.mapView.showsUserLocation = NO;
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.locationService.delegate = nil;
    self.codeSearch.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self.mapView updateLocationData:userLocation];
    
    /**定位成功后，停止定位*/
    [_locationService stopUserLocationService];
    
    /**针对定位结果，进行POI检索*/
    [self startGeoSearch:userLocation.location.coordinate];
    
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

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *  点击底图空白处会调用此方法
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    /**发起发向地理编码检索*/
    [self startGeoSearch:coordinate];
    }

/**
 *  发起GEO检索
 *
 *  @param location 检索位置
 */
- (void)startGeoSearch:(CLLocationCoordinate2D)location{
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = location;
    BOOL flag = [self.codeSearch reverseGeoCode:reverseGeoCodeSearchOption];
    
    if (flag) {
        NSLog(@"反geo检索发送成功");
    }else{
        NSLog(@"反geo检索发送失败");
    }
    
}
#pragma mark - GeoCodeSearchDelegate
- (void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:
(BMKSearchErrorCode)error {

    /**清除标记*/
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    
    
    if (error == 0) {
        BMKPointAnnotation *item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        
        
//        NSString* titleStr;
//        NSString* showmeg;
//        titleStr = @"反向地理编码";
//        showmeg = [NSString stringWithFormat:@"%@",item.title];
//        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
//        [myAlertView show];
        
        
        /**取出地理位置的poi信息并更新到TableView*/
//        NSArray *array =  result.poiList;
//       
//          [array enumerateObjectsUsingBlock:^(BMKPoiInfo* obj, NSUInteger idx, BOOL * __nonnull stop) {
//              NSLog(@"%@%@,%@",obj.city,obj.address,obj.name);
//          }];
        
        self.poiList = result.poiList;
        [self.tableView reloadData];
    }
}

#pragma mark - TableViewDelegate
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        //
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    //    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    BMKPoiInfo *info = [self.poiList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = info.name;
    cell.detailTextLabel.text = info.address;
    //    cell.textLabel.numberOfLines=2;
    //    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    return  cell;

}
- (int)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return self.poiList.count;
    }else
        return 1;
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
        return 40;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSLog(@"选择了%d个Section的第%d行！",indexPath.section,indexPath.row);
}


#pragma mark - getters and setters


- (BMKLocationService *)locationService{
    if(_locationService ==nil){
        _locationService = [[BMKLocationService alloc]init];
    }
    return _locationService;
}

- (BMKGeoCodeSearch *)codeSearch {
    if (_codeSearch==nil) {
        _codeSearch = [[BMKGeoCodeSearch alloc]init];
        _codeSearch.delegate = self;
    }
    return _codeSearch;
}
@end
