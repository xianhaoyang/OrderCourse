//
//  XHOrderRecordController.m
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/2.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHOrderRecordController.h"
#import "XHConstant.h"
#import "HTMLParser.h"

@interface XHOrderRecordController ()

@end

@implementation XHOrderRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestMyOrderedCourse];
}

- (void)requestMyOrderedCourse
{
    // HTMLParser
    NSString *urlStr = [NSString stringWithFormat:@"%@/wap/course/my_order/wid=1!openid=oXoOjt9tI9bAOy0TVyt4CvZLDwDQ", baseURL];
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr] error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    HTMLNode *bodyNode = [parser body];
    
//    NSArray *inputNodes = [bodyNode findChildrenOfClass:@"class"];
//    for (HTMLNode *inputNode in inputNodes) {
//        if ([[inputNode getAttributeNamed:@"name"] isEqualToString:@"input2"]) {
//            NSLog(@"%@", [inputNode getAttributeNamed:@"value"]); //Answer to first question
//        }
//    }
//
    
    NSArray *spanNodes = [bodyNode findChildTags:@"div"];
    for (HTMLNode *spanNode in spanNodes) {
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"courseIcon"]) {
            NSLog(@"%@", [spanNode allContents]);
        }
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"coureseRecordTitle"]) {
            NSLog(@"%@", [[spanNode allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
        }
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"courseRecordTime"]) {
            NSLog(@"%@", [[spanNode allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
        }
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"courseRecordState"]) {
            NSLog(@"%@", [[spanNode allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
        }
    }
    
//    NSArray *spanNodes = [bodyNode findChildTags:@"a"];
//    for (HTMLNode *spanNode in spanNodes) {
//        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"courseRecordTime"]) {
//            NSLog(@"%@", [spanNode getAttributeNamed:@"href"]); //Answer to second question
//        }
//    }
}

@end
