//
//  ZCUtil.m
//  SummerCamp
//
//  Created by zc on 14-10-30.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "ZCUtil.h"

@implementation ZCUtil

+ (NSString*)nowTimeString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    return strDate;
}
+ (long long)nowTimeStamp_millisecond{
    NSDate *datenow = [NSDate date];
    NSTimeInterval timeinterval = [datenow timeIntervalSince1970];
    return timeinterval*1000;
}

@end
