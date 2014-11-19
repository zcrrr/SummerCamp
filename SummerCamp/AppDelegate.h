//
//  AppDelegate.h
//  SummerCamp
//
//  Created by zc on 14-10-30.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CNLocationHandler;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController* mainNavi;

@property (strong, nonatomic) CNLocationHandler* locationHandler;

+ (AppDelegate*)getApplicationDelegate;

@property (assign ,nonatomic) int uid;


@end

