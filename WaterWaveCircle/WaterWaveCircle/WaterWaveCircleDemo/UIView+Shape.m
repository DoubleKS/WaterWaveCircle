//
//  UIView+Shape.m
//  WaterWaveCircle
//
//  Created by doublek on 2017/7/14.
//  Copyright © 2017年 doublek. All rights reserved.
//

#import "UIView+Shape.h"

@implementation UIView (Shape)

-(void)setShape:(CGPathRef)shape{
    
    if (shape == nil) {
        self.layer.mask = nil;
    }
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = shape;
    self.layer.mask = maskLayer;
    
}


@end
