//
//  BaseViewController.m
//  UIAppearanceDemo
//
//  Created by luguibin on 8/19/16.
//  Copyright © 2016 luguibin. All rights reserved.
//

#import "BaseViewController.h"
#import "CurrentVCManager.h"

@implementation BaseViewController

//如果子类重写了viewWillAppear 一定要记得调用下 父类的实现
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CurrentVCManager shareInstance].currentVC = self;
}

@end
