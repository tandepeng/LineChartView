//
//  UIView+extension.h
//  aaaa
//
//  Created by MrSDLSakura on 15/7/13.
//  Copyright (c) 2015年 MrSDLSakura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (extension)
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;
@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;


//上下左右
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;

//划线 用于drawRect 
-(void)linl:(CGPoint) star end:(CGPoint)end color:(UIColor*)color;
//虚线
-(void)dottedLinl:(CGPoint) star end:(CGPoint)end color:(UIColor*)color;


@end
