//
//  NSString+Add.m
//  UIAppearanceDemo
//
//  Created by luguibin on 8/18/16.
//  Copyright © 2016 luguibin. All rights reserved.
//

#import "NSString+Add.h"
#import "NSData+Add.h"

@implementation NSString (Add)

-(NSNumber *)numbers
{
    NSScanner *scanner = [[NSScanner alloc]initWithString:self];
    double num;
    [scanner scanDouble:&num];
    return @(num);
}

- (NSString*)md5Hash {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}

- (NSArray *)queryKeys
{
    if (self.length == 0) {
        return nil;
    }
    
    NSString *delimiters = @"&";
    
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSMutableArray * queryKeys = [NSMutableArray array];
    while (![scanner isAtEnd]) {
        NSString *pairString;
        [scanner scanUpToString:delimiters intoString:&pairString];
        [scanner scanString:delimiters intoString:NULL];
        
        NSArray * kvPairs = [pairString componentsSeparatedByString:@"="];
        
        if (kvPairs.count == 1) {
            [queryKeys addObject:[NSNull null]];
        }
        if (kvPairs.count == 2) {
            [queryKeys addObject:[kvPairs[0] stringByRemovingPercentEncoding]];
        }
    }
    
    return queryKeys;
}

- (NSDictionary *)queryKeyValueDic
{
    if (self.length == 0) {
        return nil;
    }
    
    NSString *delimiters = @"&";
    
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSMutableDictionary * kvDic = [NSMutableDictionary dictionary];
    while (![scanner isAtEnd]) {
        NSString *pairString;
        [scanner scanUpToString:delimiters intoString:&pairString];
        [scanner scanString:delimiters intoString:NULL];
        
        NSArray * kvPairs = [pairString componentsSeparatedByString:@"="];
        
        if (kvPairs.count == 2) {
            
            NSString *key_ = [kvPairs[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *value_ = [kvPairs[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [kvDic setObject:value_ forKey:key_];
        }
    }
    
    return kvDic.copy;
}

@end
