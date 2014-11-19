//
//  MainViewController.m
//  SummerCamp
//
//  Created by zc on 14-10-30.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "MainViewController.h"
#import "ChildViewController.h"
#import "ParentViewController.h"
#import "AppDelegate.h"
#define kApp [AppDelegate getApplicationDelegate]

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
- (IBAction)button_clicked:(id)sender {
    kApp.uid = [sender tag];
    NSLog(@"uid is %i",kApp.uid);
    ParentViewController* mapVC = [[ParentViewController alloc]init];
    [self.navigationController pushViewController:mapVC animated:YES];
}
@end
