//
//  ChildViewController.m
//  SummerCamp
//
//  Created by zc on 14-10-30.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "ChildViewController.h"
#import "ZCUtil.h"
#import "CNLocationHandler.h"
#import "AppDelegate.h"
#define kInterval 5
#define kApp [AppDelegate getApplicationDelegate]

@interface ChildViewController ()

@end

@implementation ChildViewController
@synthesize timer;
@synthesize row;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self uploadOnePoint];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kInterval target:self selector:@selector(uploadOnePoint) userInfo:nil repeats:YES];
}
- (void)uploadOnePoint{
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 30*row, 280, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    label.text = [NSString  stringWithFormat:@"%@,%f,%f",[ZCUtil nowTimeString],kApp.locationHandler.lon,kApp.locationHandler.lat];
    [self.scrollview addSubview:label];
    [self.scrollview setContentSize:CGSizeMake(280, 30*self.row)];
    if((row+1)*30 > 280){
        [self.scrollview setContentOffset:CGPointMake(0, (row-8)*30) animated:YES];
    }
    self.row++;
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

- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
