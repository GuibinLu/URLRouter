//
//  NSString+URLMap.m
//  UIAppearanceDemo
//
//  Created by luguibin on 8/19/16.
//  Copyright © 2016 luguibin. All rights reserved.
//

#import "NSString+URLMap.h"
#import "URLMap.h"

@implementation NSString (URLMap)


- (void)registerWithTarget:(id)target selector:(SEL)selector
{
    URLMap *shareURLMap = [URLMap shareInstance];
    [shareURLMap registerWithURLString:self target:target selector:selector];
}

- (id)openURLString
{
    URLMap *shareURLMap = [URLMap shareInstance];
    return [shareURLMap performWithURLString:self];
}

@end
