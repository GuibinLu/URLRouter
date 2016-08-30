//
//  AppDelegate.m
//  UIAppearanceDemo
//
//  Created by luguibin on 8/16/16.
//  Copyright © 2016 luguibin. All rights reserved.
//

#import "AppDelegate.h"

//URLMap
#import "NSString+ActionURLMap.h"
#import "NSString+ViewControllerURLMap.h"   

//VC

//Tool

//Lib

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self registerURLMap];
    
    
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
    
    [self detectionShare];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Private

/**
 *  注册界面 和各种通用方法   
 *  可以自己创建一个 类 XXXURLMap   在创建对应的 类别XXXURLMap+Action  XXXURLMap+ViewController 这样调用方法的时候 会更清晰一些
 */
- (void)registerURLMap
{
    [NSString registerViewControllers];
    [NSString registerActions];
}
/**
 *  检测是否有类似于淘宝的复制分享
 */
- (void)detectionShare
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if ([pasteboard.string rangeOfString:@"cyyuer://"].length > 0 && [pasteboard.string rangeOfString:@"SEND"].length >0) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"高级小轿车！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定查看", nil];
        [alert show];
    }
}

@end
