//
//  URLMap.m
//  UIAppearanceDemo
//
//  Created by luguibin on 8/19/16.
//  Copyright © 2016 luguibin. All rights reserved.
//

#import "URLMap.h"
#import "URLPattern.h"

@interface URLMap ()

@property (nonatomic, strong)NSMutableDictionary   *patternDic;

@end

@implementation URLMap

- (NSDictionary *)patternDic
{
    if (_patternDic == nil) {
        _patternDic = [NSMutableDictionary dictionary];
    }
    return _patternDic;
}

+ (instancetype)shareInstance
{
    static URLMap *_urlMap;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _urlMap = [[URLMap alloc]init];
    });
    return _urlMap;
}

- (void)registerWithURLString:(NSString *)URLString
                       target:(id)target
                     selector:(SEL)selector
{
    NSAssert(URLString.length, @"URLString 必须存在");
    
    if (URLString.length == 0) {
        return ;
    }
    NSURL *URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    URLPattern *pattern = [[URLPattern alloc]initWithURL:URL target:target selector:selector];
    [self.patternDic setObject:pattern forKey:pattern.identityString];
    
}

- (id)performWithURLString:(NSString *)URLString
{
    NSAssert(URLString.length, @"URLString 必须存在");
    if (URLString.length == 0) return nil;
    
    /** 
     * stringByAddingPercentEncodingWithAllowedCharacters: ios9 推荐使用
     * 对应的有 stringByRemovingPercentEncoding
     *
     */
    
    NSURL *URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString * identityString = [URLPattern identityStringForURL:URL];
    URLPattern *pattern = [self.patternDic objectForKey:identityString];
    
    if (!pattern) return nil;
    
    return [pattern performWithURL:URL];
}




@end
