//
//  ParentViewController.h
//  SummerCamp
//
//  Created by zc on 14-10-30.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <MAMapKit/MAMapKit.h>
@class GCDAsyncUdpSocket;

@interface ParentViewController : BaseViewController<MAMapViewDelegate>
- (IBAction)button_back_clicked:(id)sender;
@property (nonatomic, assign) int count;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) NSTimer* timer_upload;
@property (nonatomic, strong) NSTimer* timer_download;
@property (nonatomic, strong) NSMutableArray* annoArray;
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic, assign) long long lastReceiveServerTime;
@property (strong, nonatomic) IBOutlet UILabel *label_log;

@end
