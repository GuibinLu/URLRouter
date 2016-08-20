//
//  NSString+URLMap.h
//  UIAppearanceDemo
//
//  Created by luguibin on 8/19/16.
//  Copyright © 2016 luguibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLMap)

- (void)registerWithTarget:(id)target selector:(SEL)selector;

- (id)openURLString;

@end
