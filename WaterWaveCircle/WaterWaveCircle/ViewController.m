//
//  ViewController.m
//  WaterWaveCircle
//
//  Created by doublek on 2017/7/14.
//  Copyright © 2017年 doublek. All rights reserved.
//

#import "ViewController.h"
#import "WaterWaveViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WaterWaveViewController *waterVC = [[WaterWaveViewController alloc]init];
    
    [self.view addSubview:waterVC.view];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
