//
//  AppDelegate.m
//  pengyouquan
//
//  Created by 张昊辰 on 16/3/17.
//  Copyright © 2016年 com.mingxing. All rights reserved.
//

#import "AppDelegate.h"
#import "SDTimeLineTableViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

#define WXAppId @"wx8addd6e93c41749f"
#define WXAppSecret @"1f2ca74f132c152029af8effa4b0d46d"

#define QQAppId @"100424468"
#define QQappSecret @"c7394704798a158208a74ab60104f0ba"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UMSocialData setAppKey:@"56ea0aede0f55ae83e0004cb"];
    [UMSocialWechatHandler setWXAppId:WXAppId appSecret:WXAppSecret url:@"http://www.baidu.com"];
    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQappSecret url:@"http://www.umeng.com/social"];
  [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];

    UINavigationBar *bar = [UINavigationBar appearance];
    //设置显示的颜色
    bar.barTintColor = [UIColor colorWithRed:198/255.0 green:39/255.0 blue:23/255.0 alpha:1.0];
    
//    self.window.rootViewController=nvc;
    
    SDTimeLineTableViewController * time=[[SDTimeLineTableViewController alloc] init];
    UINavigationController * vc=[[UINavigationController alloc] initWithRootViewController:time];
    self.window.rootViewController=vc;
    
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
