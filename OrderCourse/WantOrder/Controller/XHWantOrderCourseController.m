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
#import "XHConstant.h"
#import "XHOrderCourseCell.h"

#define kBtnW 80
#define kBtnH 50
#define kIncrease 10
#define kTopMargin 74

@interface XHWantOrderCourseController () <UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *privateClassBtn;
@property (weak, nonatomic) IBOutlet UIButton *solonClassBtn;
@property (weak, nonatomic) IBOutlet UIButton *applicationClassBtn;
@property (weak, nonatomic) IBOutlet UIImageView *checkImage1;
@property (weak, nonatomic) IBOutlet UIImageView *checkImage2;
@property (weak, nonatomic) IBOutlet UIImageView *checkImage3;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *privateBtnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *privateBtnH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *solonBtnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *solonBtnH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applicationBtnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applicationBtnH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTop;


@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) NSMutableArray *privateList;
@property (nonatomic, strong) NSMutableArray *solonList;
@property (nonatomic, strong) NSMutableArray *appList;

@property (nonatomic, strong) NSArray *dataList;

@end

@implementation XHWantOrderCourseController

#pragma mark - lazy load
- (NSMutableArray *)privateList
{
    if (!_privateList) {
        _privateList = [NSMutableArray array];
    }
    return _privateList;
}

- (NSMutableArray *)solonList
{
    if (!_solonList) {
        _solonList = [NSMutableArray array];
    }
    return _solonList;
}

- (NSMutableArray *)appList
{
    if (!_appList) {
        _appList = [NSMutableArray array];
    }
    return _appList;
}

- (NSArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSArray array];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [self setupUI];
}

- (void)loadData
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:webView];
    webView.delegate = self;
    NSString *urlStr = [NSString stringWithFormat:@"http://ols.webi.com.cn/wap/course/index/wid=1!openid=%@",openid];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //NSLog(@"%s", __func__);
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
    for (XHCourse *course in courseList) {
        if ([course.CourseType isEqualToString:@"小班课"]) {
            [self.privateList addObject:course];
        } else if ([course.CourseType isEqualToString:@"沙龙课"]) {
            [self.solonList addObject:course];
        } else {
            [self.appList addObject:course];
        }
    }
    [self clickPrivateClassBtn];
//    //NSLog(@"======%@", courseList);
}

#pragma mark - 初始化UI
- (void)setupUI
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    // 按钮设置圆角
    [self cornerRadiusWithBtn:self.privateClassBtn];
    [self cornerRadiusWithBtn:self.solonClassBtn];
    [self cornerRadiusWithBtn:self.applicationClassBtn];
    // 隐藏勾选
    self.checkImage1.hidden = YES;
    self.checkImage2.hidden = YES;
    self.checkImage3.hidden = YES;
}

- (void)cornerRadiusWithBtn:(UIButton *)btn
{
    btn.layer.cornerRadius = 5.0f;
    btn.clipsToBounds = YES;
}

- (IBAction)clickPrivateClassBtn {
    //NSLog(@"%s", __func__);
    self.checkImage1.hidden = NO;
    self.checkImage2.hidden = YES;
    self.checkImage3.hidden = YES;
    self.privateBtnW.constant += kIncrease;
    self.privateBtnH.constant += kIncrease;
    self.solonBtnW.constant = kBtnW;
    self.solonBtnH.constant = kBtnH;
    self.applicationBtnW.constant = kBtnW;
    self.applicationBtnH.constant = kBtnH;
    self.btnTop.constant = kTopMargin;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    self.dataList = self.privateList;
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)clickSolonClassBtn {
    self.checkImage1.hidden = YES;
    self.checkImage2.hidden = NO;
    self.checkImage3.hidden = YES;
    self.privateBtnW.constant = kBtnW;
    self.privateBtnH.constant = kBtnH;
    self.solonBtnW.constant += kIncrease;
    self.solonBtnH.constant += kIncrease;
    self.applicationBtnW.constant = kBtnW;
    self.applicationBtnH.constant = kBtnH;
    self.btnTop.constant = kTopMargin - kIncrease * 0.5;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    self.dataList = self.solonList;
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)clickAppClassBtn {
    self.checkImage1.hidden = YES;
    self.checkImage2.hidden = YES;
    self.checkImage3.hidden = NO;
    self.privateBtnW.constant = kBtnW;
    self.privateBtnH.constant = kBtnH;
    self.solonBtnW.constant = kBtnW;
    self.solonBtnH.constant = kBtnH;
    self.applicationBtnW.constant += kIncrease;
    self.applicationBtnH.constant += kIncrease;
    self.btnTop.constant = kTopMargin;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    self.dataList = self.appList;
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%s", __func__);
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"%s", __func__);
    XHOrderCourseCell *cell = [XHOrderCourseCell cellWithTableView:tableView];
    cell.course = self.dataList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%s", __func__);
    return self.checkImage1.isHidden == NO ? 105 : 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%s", __func__);
}


@end
