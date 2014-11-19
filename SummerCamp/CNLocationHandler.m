//
//  CNLocationHandler.m
//  YaoPao
//
//  Created by zc on 14-7-30.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "CNLocationHandler.h"

@implementation CNLocationHandler
@synthesize lat;
@synthesize lon;


- (void)startGetLocation{
    if([CLLocationManager locationServicesEnabled]){
        self.locationManager = [[CLLocationManager alloc] init];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) { [self.locationManager requestWhenInUseAuthorization]; } 
        
        
        [self.locationManager setDelegate:self];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
    }
}
- (void)stopLocation{
    [self.locationManager stopUpdatingLocation];
}
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation* newLocation = [locations lastObject];
    self.lat = newLocation.coordinate.latitude;
    self.lon = newLocation.coordinate.longitude;
}

@end
