//
//  AppJumpFunction.m
//  UIAppearanceDemo
//
//  Created by luguibin on 8/19/16.
//  Copyright © 2016 luguibin. All rights reserved.
//

#import "AppJumpFunction.h"
#import "NSString+URLMap.h"
#import <WebKit/WebKit.h>
#import "CurrentVCManager.h"

@implementation AppJumpFunction

+ (void)pushToViewControllerWithURLString:(NSString *)URLString title:(NSString *)title
{
    NSRange range = [URLString rangeOfString:@"AppearanceDemo"];
    if (range.location == NSNotFound) {
        //WKWeb 进入web页面
        
    }else{
        UIViewController *controller = [URLString openURLString];
        if (!controller) return;
        
        if (title) {
            controller.title = title;
        }
        
        //使用工程对应的currentVC 或者 topVC 跳转controller
        BaseViewController *currentVC = [CurrentVCManager shareInstance].currentVC;
        if (currentVC.navigationController) {
            [currentVC.navigationController pushViewController:controller animated:YES];
        }else{
            //这一点不该这么实现 看自己情况决定
            [currentVC presentViewController:currentVC animated:YES completion:nil];
        }
        
    }
}

@end
