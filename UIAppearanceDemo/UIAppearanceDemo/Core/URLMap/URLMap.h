//
//  URLMap.h
//  UIAppearanceDemo
//
//  Created by luguibin on 8/19/16.
//  Copyright © 2016 luguibin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  单例 维护 urlID - pattern 表
 */
@interface URLMap : NSObject

+ (instancetype)shareInstance;


- (void)registerWithURLString:(NSString *)URLString
                       target:(id)target
                     selector:(SEL)selector;

- (id)performWithURLString:(NSString *)URLString;

@end
