//
//  ParentViewController.m
//  SummerCamp
//
//  Created by zc on 14-10-30.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "ParentViewController.h"
#import "CNMatchAvatarAnnotationView.h"
#import "CNEncryption.h"
#import "GCDAsyncUdpSocket.h"
#import "AppDelegate.h"
#import "CNLocationHandler.h"
#import "ZCUtil.h"

#define kIntervalDownload 10
#define kIntervalUpload 2
#define kApp [AppDelegate getApplicationDelegate]
#define kHost @"182.92.97.144"
#define kPort 7011


@interface ParentViewController ()

@end

@implementation ParentViewController
@synthesize mapView;
@synthesize timer_download;
@synthesize timer_upload;
@synthesize annoArray;
@synthesize udpSocket;
@synthesize lastReceiveServerTime;
@synthesize count;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mapView=[[MAMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    self.mapView.delegate = self;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    self.mapView.rotateEnabled = NO;
    self.mapView.rotateCameraEnabled = NO;
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
    
    //udp
    if (self.udpSocket == nil)
    {
        [self setupSocket];
    }
    
    self.annoArray = [[NSMutableArray alloc]init];
//    [self download];
//    self.timer_download = [NSTimer scheduledTimerWithTimeInterval:kIntervalDownload target:self selector:@selector(download) userInfo:nil repeats:YES];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupSocket
{
    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    
    if (![self.udpSocket bindToPort:0 error:&error])
    {
        NSLog(@"Error binding: %@", error);
        return;
    }
    if (![self.udpSocket beginReceiving:&error])
    {
        NSLog(@"Error receiving: %@", error);
        return;
    }
    
    NSLog(@"Ready");
    [self upload];
    self.timer_upload = [NSTimer scheduledTimerWithTimeInterval:kIntervalUpload target:self selector:@selector(upload) userInfo:nil repeats:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)upload{
    double lat = kApp.locationHandler.lat;
    double lon = kApp.locationHandler.lon;
    
    //测试代码
//    int random_x = arc4random() % 5;
//    int random_y = arc4random() % 5;
//    lat = lat + random_y*0.002;
//    lon = lon + random_x*0.002;
    
    NSString* dataString = [NSString stringWithFormat:@"UPDATE:%i:%i:%llu:%f:%f",100,kApp.uid,[ZCUtil nowTimeStamp_millisecond],lon,lat];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [self.udpSocket sendData:data toHost:kHost port:kPort withTimeout:-1 tag:0];
    NSLog(@"send :%@",dataString);
    self.label_log.text = [NSString stringWithFormat:@"发送请求:%i",count++];
}
- (void)download{
    [self.mapView removeAnnotations:self.annoArray];
    [self.annoArray removeAllObjects];
    double min_lon = 116.383753;
    double min_lat = 39.966817;
    double max_lon = 116.383753;
    double max_lat = 39.966817;
    for(int i = 0 ; i<4;i++){
        MAPointAnnotation* annotation = [[MAPointAnnotation alloc] init];
        CLLocationCoordinate2D wgs84Point = CLLocationCoordinate2DMake(39.966817, 116.383753+0.002*i);
        CLLocationCoordinate2D encryptionPoint = [CNEncryption encrypt:wgs84Point];
        annotation.coordinate = CLLocationCoordinate2DMake(encryptionPoint.latitude, encryptionPoint.longitude);
        annotation.title = [NSString stringWithFormat:@"%i",i];
        [self.mapView addAnnotation:annotation];
        [self.annoArray addObject:annotation];
        
        if(annotation.coordinate.longitude < min_lon){
            min_lon = annotation.coordinate.longitude;
        }
        if(annotation.coordinate.latitude < min_lat){
            min_lat = annotation.coordinate.latitude;
        }
        if(annotation.coordinate.longitude > max_lon){
            max_lon = annotation.coordinate.longitude;
        }
        if(annotation.coordinate.latitude > max_lat){
            max_lat = annotation.coordinate.latitude;
        }
    }
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((min_lat+max_lat)/2, (min_lon+max_lon)/2);
    MACoordinateSpan span = MACoordinateSpanMake(max_lat-min_lat+0.005, max_lon-min_lon+0.005);
    MACoordinateRegion region = MACoordinateRegionMake(center, span);
    [self.mapView setRegion:region animated:NO];
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        CNMatchAvatarAnnotationView *annotationView = (CNMatchAvatarAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CNMatchAvatarAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view.
            annotationView.centerOffset = CGPointMake(0, -15);
        }
        NSString* tag = ((MAPointAnnotation*)annotation).title;
        if([tag isEqualToString:@"0"]){//教师
            annotationView.imageview.image = [UIImage imageNamed:@"teacher.jpg"];
        }else{//教师
            NSString* imageName = [NSString stringWithFormat:@"stu%@.png",tag];
            annotationView.imageview.image = [UIImage imageNamed:imageName];
        }
        
        return annotationView;
    }
    return nil;
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    // You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    // You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg)
    {
        NSLog(@"接收服务器响应:%@",msg);
        self.label_log.text = [NSString stringWithFormat:@"服务器有相应:%i",count];
//        QUERY:1414978941822:100:1,1414978941783,119.1,39.1:2,1414978941821,119.2,39.2
        NSArray* dataArray = [msg componentsSeparatedByString:@":"];
        long long timeStamp = [[dataArray objectAtIndex:1]longLongValue];
        if(timeStamp < self.lastReceiveServerTime){//比较旧
            return;
        }
        self.lastReceiveServerTime = timeStamp;
        if([dataArray count] >= 4){//有数据
            //先清除地图数据
            [self.mapView removeAnnotations:self.annoArray];
            [self.annoArray removeAllObjects];
            for(int i = 3;i<[dataArray count];i++){
                NSString* userInfo = [dataArray objectAtIndex:i];
                NSArray* userArray = [userInfo componentsSeparatedByString:@","];
                NSString* uid = [userArray objectAtIndex:0];
                double lon = [[userArray objectAtIndex:2]doubleValue];
                double lat = [[userArray objectAtIndex:3]doubleValue];
                NSLog(@"uid:%@,lon:%f,lat:%f",uid,lon,lat);
                MAPointAnnotation* annotation = [[MAPointAnnotation alloc] init];
                CLLocationCoordinate2D wgs84Point = CLLocationCoordinate2DMake(lat, lon);
                CLLocationCoordinate2D encryptionPoint = [CNEncryption encrypt:wgs84Point];
                annotation.coordinate = CLLocationCoordinate2DMake(encryptionPoint.latitude, encryptionPoint.longitude);
                annotation.title = uid;
                [self.mapView addAnnotation:annotation];
                [self.annoArray addObject:annotation];
            }
        }
    }
    else
    {
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
        NSLog(@"未接收到服务器响应");
        self.label_log.text = [NSString stringWithFormat:@"未接收到服务器响应"];
    }
}
@end
