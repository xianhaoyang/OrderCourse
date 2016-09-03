//
//  UIView+YXH.m
//  新浪微博-01
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 yangxianhao. All rights reserved.
//

#import "UIView+YXH.h"

@implementation UIView (YXH)
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

//+ (instancetype)attributedWithString:(NSString *)str font:(CGFloat)fontSize
//{
//    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:str];
//    [attributedTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, str.length)];
//    [attributedTitle addAttribute:NSForegroundColorAttributeName value:XHColor(70, 143, 239) range:NSMakeRange(0, str.length)];
//    UILabel *attributedView = [[UILabel alloc] init];
//    attributedView.textAlignment = NSTextAlignmentCenter;
//    attributedView.width = 200;
//    attributedView.height = 44;
//    attributedView.attributedText = attributedTitle;
//    return attributedView;
//}
@end
