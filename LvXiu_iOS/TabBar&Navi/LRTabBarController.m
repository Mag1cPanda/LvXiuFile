//
//  LRTabBarController.m
//  CarRecordCarOwner
//
//  Created by Mag1cPanda on 2017/3/14.
//  Copyright © 2017年 Mag1cPanda. All rights reserved.
//

#import "LRTabBarController.h"
#import "LRNavigationController.h"

@interface LRTabBarController ()


@end

@implementation LRTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : DSBlue} forState:UIControlStateSelected];
    
//    NSArray *names = @[@"审图", @"定损", @"理赔", @"查询", @"我的"];
//    NSArray *imgAry = @[@"st", @"ds", @"lp", @"cx", @"wd"];
//    NSArray *selectedImgAry = @[@"st_select", @"ds_select", @"lp_select", @"cx_select", @"wd_select"];
//    
//    for (int i=0; i<5; i++) {
//        LRNavigationController *nav = self.viewControllers[i];
//        UIViewController *vc = nav.viewControllers[0];
//        UIImage *image = [UIImage imageNamed:imgAry[i]];
//        UIImage *selectedImage = [[UIImage imageNamed:selectedImgAry[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:names[i] image:image selectedImage:selectedImage];
//    }
    
}


@end
