//
//  NSString+ViewControllerURLMap.m
//  UIAppearanceDemo
//
//  Created by luguibin on 8/19/16.
//  Copyright © 2016 luguibin. All rights reserved.
//

#import "NSString+ViewControllerURLMap.h"
#import "GoodsAPI.h"

@implementation NSString (ViewControllerURLMap)

+ (void)registerViewControllers
{
    //一些不属于某个模块内的界面的注册...
    
    //[@"AppearanceDemo://page/xxxx/xxxx"registerWithTarget:xxx selector:xxx];
    
    
    //模块的注册
    
    /**
     *  商品模块的注册
     */
    [GoodsAPI registerViewController];
}

@end
