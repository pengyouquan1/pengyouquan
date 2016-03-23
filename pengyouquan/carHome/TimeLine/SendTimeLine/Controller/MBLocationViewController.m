//
//  LocationViewController.m
//  MyFamily
//
//  Created by 陆洋 on 15/7/14.
//  Copyright (c) 2015年 maili. All rights reserved.
//只需要传经纬度给服务器，服务器传附近的地点

#import "MBLocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CLLocation+Sino.h"
#import "MBSendTimeLineViewController.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width


@interface MBLocationViewController ()<CLLocationManagerDelegate>
{
    NSArray * locationsArray;
}
@property (strong,nonatomic)CLLocationManager *locationManager;
@property (strong,nonatomic)CLLocation *checkInLocation;
@property (strong,nonatomic)NSMutableString *currentLatitude; //纬度
@property (strong,nonatomic)NSMutableString *currentLongitude; //经度
@property (strong,nonatomic)CLGeocoder *geocoder;
@property (strong,nonatomic) NSMutableDictionary * dataDictionary;

@end

@implementation MBLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所在位置";
    
    //nav右边发布按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButton.frame = CGRectMake(0, 0, 30, 20);
    [leftButton setTitle:@"取消" forState:normal];
    [leftButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    
    //定位管理器
    _locationManager=[[CLLocationManager alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >=8.0 ) {
            [_locationManager requestAlwaysAuthorization];
        }
        [_locationManager startUpdatingLocation];
    

}
-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSMutableDictionary *)dataDictionary
{
    if (!_dataDictionary) {
        _dataDictionary = [[NSMutableDictionary alloc] init];
    }
    return _dataDictionary;
}

-(CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

#pragma mark 根据坐标(经纬度)取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    NSLog(@"%f-----------%f",latitude,longitude);
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {

        CLPlacemark *placemark=[placemarks firstObject];
        NSDictionary * locattionDic = placemark.addressDictionary;
        NSString * city = [locattionDic objectForKey:@"City"];
        NSString * Name = [locattionDic objectForKey:@"Name"];
        NSString * Street = [locattionDic objectForKey:@"Street"];
        NSString * SubLocality = [locattionDic objectForKey:@"SubLocality"];
        NSString * Detail = [[locattionDic objectForKey:@"FormattedAddressLines"] lastObject];
        locationsArray = [NSArray arrayWithObjects:@"不显示位置",city,Name,Detail,Street,SubLocality, nil];
        NSDictionary * locationDic = [NSDictionary dictionaryWithObjectsAndKeys:@"不显示位置",@"None",city,@"City",Name,@"Name",Detail,@"detail",SubLocality,@"SubLocality",Street,@"street",nil];
        
        [self.dataDictionary setValuesForKeysWithDictionary:locationDic];
        
        [self.tableView reloadData];

        
        NSLog(@"%@",[placemark.addressDictionary objectForKey:@"Name"]);
        
//        [self.dataSource addObject:[placemark.addressDictionary objectForKey:@"Name"]];
        
//        address = [placemark.addressDictionary objectForKey:@"Name"];
//        address = (NSString *)[placemark.addressDictionary objectForKey:@"Name"];
//        ] {
//            City = "天津市";
//            Country = "中国";
//            CountryCode = CN;
//            FormattedAddressLines =     (
//                                         "中国天津市河西区大营门街道马场道"
//                                         );
//            Name = "中国天津市河西区大营门街道马场道";
//            State = "天津市";
//            Street = "马场道";
//            SubLocality = "河西区";
//            Thoroughfare = "马场道";
        
        

//        }
        NSLog(@"%@",[NSString stringWithFormat:@"%@",[NSString stringWithCString:[[placemark.addressDictionary description] cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding]]);
    }];
     
    
    
//    return [placemark.addressDictionary objectforKey:@"Name"];
}

#pragma mark - locationManager Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    
    CLLocation *currentLocation1 = [locations lastObject];
    CLLocation * currentLocation=[currentLocation1 locationMarsFromEarth];
    //    CLLocation * currentLocation=[currentLocation2 locationBearPawFromMars];
    CLLocationCoordinate2D coor = currentLocation.coordinate;
    self.currentLatitude =  [NSMutableString stringWithFormat:@"%f",coor.latitude];
    self.currentLongitude = [NSMutableString stringWithFormat:@"%f",coor.longitude];
    
//    locationsArray = [NSArray arrayWithArray:locations];
//    for (CLLocation * location in locations) {
//        self.checkInLocation = location;
//        CLLocationCoordinate2D cool = self.checkInLocation.coordinate;
//        self.currentLatitude  = [NSMutableString stringWithFormat:@"%f",cool.latitude];
//        self.currentLongitude = [NSMutableString stringWithFormat:@"%f",cool.longitude];
//        
////    [self getAddressByLatitude:[self.currentLatitude doubleValue] longitude:[self.currentLatitude doubleValue]];
////       [self.dataSource addObject: addre];
//
//    }
    NSLog(@"%@,%@",self.currentLatitude,self.currentLongitude);
    

    [self getAddressByLatitude:[self.currentLatitude doubleValue] longitude:[self.currentLongitude doubleValue]];
    
        //如果不需要实时定位，使用完即使关闭定位服务
    [self.locationManager stopUpdatingLocation];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.dataDictionary allValues].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   static NSString * iden = @"iden";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    NSString * title = locationsArray[indexPath.section];
    NSString * detail = [_dataDictionary objectForKey:@"detail"];
    if ([title isEqualToString:[self.dataDictionary objectForKey:@"Name"]]) {
        cell.detailTextLabel.text = detail;
    }

    cell.textLabel.text = title;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * addressText;
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString * city = [self.dataDictionary objectForKey:@"City"];
    if ([cell.textLabel.text isEqualToString:@"不显示位置"]) {
        addressText = cell.textLabel.text;
    }
    else
    {
        if ([city isEqualToString:cell.textLabel.text]) {
            addressText = city;
        }
        else
        {
            addressText = [NSString stringWithFormat:@"%@·%@",city,cell.textLabel.text];
        }
    }
    
    [self.delegate setLocationTextWithText:addressText];
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
