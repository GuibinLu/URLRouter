//
//  URLPattern.h
//  UIAppearanceDemo
//
//  Created by luguibin on 8/19/16.
//  Copyright © 2016 luguibin. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  实现router的类
 */
@interface URLPattern : NSObject

@property (nonatomic,strong) NSString       *identityString;

- (instancetype)initWithURL:(NSURL *)URL
                     target:(id)target
                   selector:(SEL)selector;


- (id)performWithURL:(NSURL *)URL;

+ (NSString *)identityStringForURL:(NSURL *)URL;

@end
