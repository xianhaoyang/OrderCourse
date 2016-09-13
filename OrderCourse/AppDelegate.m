//
//  AppDelegate.m
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/2.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "AppDelegate.h"
#import "XHNavigationController.h"
#import "XHWantOrderCourseController.h"
#import "XHOrderRecordController.h"
#import "NSDate+Calculations.h"
#import "NSDate+Escort.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    // 程序已启动就在已订课数组中找出距离现在在3个小时之内的对象，并删除它
    NSArray *orderedCourseList = [NSKeyedUnarchiver unarchiveObjectWithFile:kOrderedCourseSavePath];
    if (orderedCourseList.count) {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:orderedCourseList];
        for (XHOrderedCourse *orderedcourse in orderedCourseList) {
            NSDate *beginDate = [NSDate dateFromString:orderedcourse.BeginTime format:@"yyyy-MM-dd HH:mm:ss"];
            // 删除已完成的课程
            if ([beginDate isInPast]) {
                [temp removeObject:orderedcourse];
            }
//            注释一下代码的原因是：如果已预订某课程的开始时间是19点，而当我在距离上课3个小时之内启动APP，那么已预订数组就会将此课程删除，而当我在首页对比时间冲突的时候就会忽略此课程的时间，从而用户将可以再次预订与此课程时间冲突的课程
//            NSInteger timeDiff = [[NSDate date] minutesBeforeDate:beginDate];
//             删除开课时间在3个小时之内的课程
//            if (timeDiff < 60 * 3) {
//                [temp removeObject:orderedcourse];
//            }
        }
        [NSKeyedArchiver archiveRootObject:temp toFile:kOrderedCourseSavePath];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    // 创建UITabBarController
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    // 创建我要订课控制器
    XHWantOrderCourseController *orderController = [[XHWantOrderCourseController alloc] init];
    XHNavigationController *orderNavController = [[XHNavigationController alloc] initWithRootViewController:orderController];
//    orderController.view.backgroundColor = [UIColor yellowColor];
    orderController.title = @"我要订课";
    // 创建订课记录控制器
    XHOrderRecordController *recordController = [[XHOrderRecordController alloc] init];
    XHNavigationController *recordNavController = [[XHNavigationController alloc] initWithRootViewController:recordController];
//    recordController.view.backgroundColor = [UIColor greenColor];
    recordController.title = @"订课记录";
    // 将两个主控制器添加到tabBarController中
    tabBarController.viewControllers = @[orderNavController, recordNavController];
    // 显示tabBarController为根控制器
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
