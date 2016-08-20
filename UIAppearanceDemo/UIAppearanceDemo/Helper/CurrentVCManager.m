//
//  CurrentVC.m
//  UIAppearanceDemo
//
//  Created by luguibin on 8/19/16.
//  Copyright © 2016 luguibin. All rights reserved.
//

#import "CurrentVCManager.h"

@implementation CurrentVCManager

+ (instancetype)shareInstance
{
    static CurrentVCManager *currentVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentVC = [[CurrentVCManager alloc] init];
    });
    return currentVC;
}


@end
