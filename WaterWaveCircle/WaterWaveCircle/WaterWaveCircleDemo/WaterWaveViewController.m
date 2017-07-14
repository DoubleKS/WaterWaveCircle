//
//  WaterWaveViewController.m
//  WaterWaveCircle
//
//  Created by doublek on 2017/7/14.
//  Copyright © 2017年 doublek. All rights reserved.
//

#import "WaterWaveViewController.h"
#import "UIView+Shape.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WaterMaxHeight WIDTH-140

@interface WaterWaveViewController (){
    
    float _horizontal;
    float _horizontal2;
    float waterHeight;
}

@property (nonatomic,strong)UIView *circleView;
@property (nonatomic,strong)UIView *dianliangView;
@property (nonatomic,strong)UIView *dianliangView2;

//圆 CAShapeLayer
@property (nonatomic,strong)CAShapeLayer *ovalShapeLayer;
@property (nonatomic,strong)UISlider *slider;
@property (nonatomic,strong)NSTimer *waterTimer;
@property (nonatomic,strong)NSTimer *waterTimer2;
@property (nonatomic,strong)UILabel *dianliangLbel;



@end

@implementation WaterWaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)setupUI{
    
    self.view.backgroundColor = [UIColor colorWithRed:0.25 green:0.39 blue:0.68 alpha:1.00];
    waterHeight = (WIDTH-140);
    /// 电量滑动虚线圆View=============
    self.circleView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2-(WIDTH-100)/2, 100, WIDTH-100, WIDTH-100)];
    [self.view addSubview:self.circleView];
    self.circleView.layer.cornerRadius = (WIDTH-100)/2;
    self.circleView.layer.masksToBounds = YES;
    self.circleView.backgroundColor = [UIColor clearColor];
    self.circleView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    //  第一层浅白色的虚线圆
    CAShapeLayer *ovalLayer = [CAShapeLayer layer];
    ovalLayer.strokeColor = [UIColor colorWithRed:0.64 green:0.71 blue:0.87 alpha:1.00].CGColor;
    ovalLayer.fillColor = [UIColor clearColor].CGColor;
    ovalLayer.lineWidth = 10;
    ovalLayer.lineDashPattern  = @[@2,@6];
    ovalLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(5,5,2 * (WIDTH-100)/2-10,2 * (WIDTH-100)/2-10)].CGPath;
    [self.circleView.layer addSublayer:ovalLayer];
    // 第二层黄色的虚线圆 电量多少的
    self.ovalShapeLayer = [CAShapeLayer layer];
    self.ovalShapeLayer.strokeColor = [UIColor yellowColor].CGColor;
    self.ovalShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.ovalShapeLayer.lineWidth = 10;
    self.ovalShapeLayer.lineDashPattern  = @[@2,@6];
    CGFloat refreshRadius = (WIDTH-100)/2;
    self.ovalShapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(5,5,2 * refreshRadius-10,2 * refreshRadius-10)].CGPath;
    self.ovalShapeLayer.strokeEnd = 0;
    [self.circleView.layer addSublayer:self.ovalShapeLayer];
    // 白色实线的小圆圈
    CAShapeLayer *ocircleLayer = [CAShapeLayer layer];
    ocircleLayer.strokeColor = [UIColor colorWithRed:0.64 green:0.71 blue:0.87 alpha:1.00].CGColor;
    ocircleLayer.fillColor = [UIColor clearColor].CGColor;
    ocircleLayer.lineWidth = 1;
    ocircleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(15,15,2 * (WIDTH-100)/2-30,2 * (WIDTH-100)/2-30)].CGPath;
    [self.circleView.layer addSublayer:ocircleLayer];
    
    ///  滑动slider ==========================
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(100, HEIGHT-100, WIDTH-200, 20)];
    [self.view addSubview:self.slider];
    [self.slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    ///
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2-(WIDTH-100)/2 + 20, 100 + 20, WIDTH-140, WIDTH-140)];
    [self.view addSubview:backView];
    backView.layer.cornerRadius = (WIDTH-140)/2;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = [UIColor colorWithRed:0.26 green:0.34 blue:0.50 alpha:1.00];
    /// 第一层水波纹view ===========================
    self.dianliangView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2-(WIDTH-100)/2 + 20, 100 + 20, WIDTH-140, WIDTH-140)];
    [self.view addSubview:self.dianliangView];
    self.dianliangView.layer.cornerRadius = (WIDTH-140)/2;
    self.dianliangView.layer.masksToBounds = YES;
    self.dianliangView.backgroundColor = [UIColor colorWithRed:0.34 green:0.40 blue:0.71 alpha:0.80];
    /// 第二层水波纹 view =======================
    self.dianliangView2 = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2-(WIDTH-100)/2 + 20, 100 + 20, WIDTH-140, WIDTH-140)];
    [self.view addSubview:self.dianliangView2];
    self.dianliangView2.layer.cornerRadius = (WIDTH-140)/2;
    self.dianliangView2.layer.masksToBounds = YES;
    self.dianliangView2.backgroundColor = [UIColor colorWithRed:0.32 green:0.52 blue:0.82 alpha:0.60];
    ///
    self.dianliangLbel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2-(WIDTH-100)/2 + 20, 100 + 20 + (WIDTH-140)/2-30, WIDTH-140, 60)];
    [self.view addSubview:self.dianliangLbel];
    self.dianliangLbel.font = [UIFont systemFontOfSize:50];
    self.dianliangLbel.textAlignment = NSTextAlignmentCenter;
    self.dianliangLbel.textColor = [UIColor whiteColor];
    
    self.waterTimer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(waterAction) userInfo:nil repeats:YES];
    self.waterTimer2 = [NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(waterAction2) userInfo:nil repeats:YES];

}

- (void)waterAction{
    CGMutablePathRef wavePath = CGPathCreateMutable();
    CGPathMoveToPoint(wavePath, nil, 0,-WaterMaxHeight*0.5);
    float y = 0;
    _horizontal += 0.15;
    for (float x = 0; x <= self.dianliangView.frame.size.width; x++) {
        //峰高* sin(x * M_PI / self.frame.size.width * 峰的数量 + 移动速度)
        y = 7* sin(x * M_PI / self.dianliangView.frame.size.width * 2 - _horizontal) ;
        CGPathAddLineToPoint(wavePath, nil, x, y+waterHeight);
    }
    CGPathAddLineToPoint(wavePath, nil, self.dianliangView.frame.size.width , WaterMaxHeight*0.5);
    CGPathAddLineToPoint(wavePath, nil, self.dianliangView.frame.size.width, WaterMaxHeight);
    CGPathAddLineToPoint(wavePath, nil, 0, WaterMaxHeight);
    [self.dianliangView setShape:wavePath];
}

- (void)waterAction2{
    CGMutablePathRef wavePath2 = CGPathCreateMutable();
    CGPathMoveToPoint(wavePath2, nil, 0,-WaterMaxHeight*0.5);
    float y2 = 0;
    _horizontal2 += 0.1;
    for (float x2 = 0; x2 <= self.dianliangView2.frame.size.width; x2++) {
        //峰高* sin(x * M_PI / self.frame.size.width * 峰的数量 + 移动速度)
        y2 = -5* cos(x2 * M_PI / self.dianliangView2.frame.size.width * 2 + _horizontal2) ;
        CGPathAddLineToPoint(wavePath2, nil, x2, y2+waterHeight);
    }
    CGPathAddLineToPoint(wavePath2, nil, self.dianliangView2.frame.size.width , WaterMaxHeight*0.5);
    CGPathAddLineToPoint(wavePath2, nil, self.dianliangView2.frame.size.width, WaterMaxHeight);
    CGPathAddLineToPoint(wavePath2, nil, 0, WaterMaxHeight);
    [self.dianliangView2 setShape:wavePath2];
}

#pragma mark - 滑动条
- (void)sliderAction:(UISlider *)slider{
    
    self.ovalShapeLayer.strokeEnd = slider.value;
    if (slider.value >= 0 || slider.value <= 1){
        waterHeight = (1-slider.value)*(WIDTH-140);
        self.dianliangLbel.text = [NSString stringWithFormat:@"%.0f%@",slider.value*100,@"%"];
    }else{
        NSLog(@"progress value is error");
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
