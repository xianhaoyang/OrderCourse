//
//  UIView+YXH.h
//  新浪微博-01
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 yangxianhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YXH)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

/**
 *  返回一个带有属性的字符串
 */
//+ (instancetype)attributedWithString:(NSString *)str font:(CGFloat)fontSize;

@end
