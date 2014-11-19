//
//  CNLocationHandler.h
//  YaoPao
//
//  Created by zc on 14-7-30.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface CNLocationHandler : NSObject<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (assign, nonatomic) double lon;
@property (assign, nonatomic) double lat;

- (void)startGetLocation;
- (void)stopLocation;

@end
