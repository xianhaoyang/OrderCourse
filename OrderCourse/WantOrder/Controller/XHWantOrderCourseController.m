//
//  XHWantOrderCourseController.m
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/2.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHWantOrderCourseController.h"
#import "MJExtension.h"
#import "XHCourse.h"

@interface XHWantOrderCourseController () <UIWebViewDelegate>

//@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation XHWantOrderCourseController

#pragma mark - lazy load
//- (NSMutableArray *)dataList
//{
//    if (!_dataList) {
//        _dataList = [NSMutableArray array];
//    }
//    return _dataList;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:webView];
    webView.delegate = self;
    NSURL *url = [NSURL URLWithString:@"http://ols.webi.com.cn/wap/course/index/wid=1!openid=oXoOjt9tI9bAOy0TVyt4CvZLDwDQ"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%s", __func__);
    NSString *lJs = @"document.documentElement.innerHTML";//获取当前网页的html
    NSString *jsCodeStr = [webView stringByEvaluatingJavaScriptFromString:lJs];
    [self handleDataWithTargetStr:jsCodeStr];
}

- (void)handleDataWithTargetStr:(NSString *)targetStr
{
    NSString *str1 = @"var centerCourseListJson = JSON.parse('";
    NSString *str2 = @"var othercenterCourseListJson = JSON.parse('[]');";
    NSRange range1 = [targetStr rangeOfString:str1];
    NSRange range2 = [targetStr rangeOfString:str2];
    NSString *jsonStr = [targetStr substringWithRange:NSMakeRange(range1.location + range1.length, range2.location - (range1.location + range1.length))];
    jsonStr = [jsonStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    jsonStr = [jsonStr substringToIndex:jsonStr.length - 3];
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *dictList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *courseList = [XHCourse mj_objectArrayWithKeyValuesArray:dictList];
    NSLog(@"======%@", courseList);
}

@end
