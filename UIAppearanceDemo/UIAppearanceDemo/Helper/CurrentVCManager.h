//
//  CurrentVC.h
//  UIAppearanceDemo
//
//  Created by luguibin on 8/19/16.
//  Copyright © 2016 luguibin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseViewController.h"

@interface CurrentVCManager : NSObject

@property (nonatomic,strong) BaseViewController *currentVC;

+ (instancetype)shareInstance;

@end
