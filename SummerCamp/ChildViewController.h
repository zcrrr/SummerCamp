//
//  ChildViewController.h
//  SummerCamp
//
//  Created by zc on 14-10-30.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ChildViewController : BaseViewController
@property (strong, nonatomic) NSTimer* timer;
@property (assign, nonatomic) int row;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
- (IBAction)button_back_clicked:(id)sender;

@end
