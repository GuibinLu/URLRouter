//
//  URLPattern.m
//  UIAppearanceDemo
//
//  Created by luguibin on 8/19/16.
//  Copyright © 2016 luguibin. All rights reserved.
//

#import "URLPattern.h"
#import <objc/runtime.h>
#import "NSString+Add.h"

@interface URLPattern ()

@property (nonatomic,strong) NSURL          *URL;

//shareURLMap单例维护着每一个URLPattern实例，为避免内存泄漏应将其设为weak, target只是调用invocation时候使用，并没有暴露给外部使用

@property (nonatomic,weak) Class            targetClass;

@property (nonatomic,weak) NSObject         *targetObjcet;

@property (nonatomic,assign) SEL            selector;

//注册时候 顺序将参数加入该数组中，需要注意的是url中的query的参数顺序必须和selector的参数顺序一样，命名可以不一样。后面只是通过key拿到value ，并根据key在queryKeys中的index,往invocation 的对应参数塞值
@property (nonatomic,strong) NSArray        *queryKeys;

@end

/**
 * 基本类型和对象pointer类型
 */
typedef NS_ENUM(NSInteger,URLPatternArgumentType) {
    URLPatternArgumentType_None,
    URLPatternArgumentType_Pointer,
    URLPatternArgumentType_Bool,
    URLPatternArgumentType_Integer,
    URLPatternArgumentType_LongLong,
    URLPatternArgumentType_Float,
    URLPatternArgumentType_Double
};

URLPatternArgumentType URLPatternArgumentTypeForTypeChar(char argType);

@implementation URLPattern

#pragma mark - Public

+ (NSString *)identityStringForURL:(NSURL *)URL
{
    //要保证url 唯一 避免重复
    
    NSAssert(URL.host, @" host 必须存在");
    NSAssert(URL.scheme, @" seheme 必须存在");
    
    NSMutableString * mutableString = [NSMutableString string];
    [mutableString appendString:[URL host]];
    [mutableString appendString:[URL scheme]];
    [mutableString appendString:[URL path]];
    
    return  [mutableString md5Hash];
}


- (instancetype)initWithURL:(NSURL *)URL
                     target:(id)target
                   selector:(SEL)selector
{
    self = [super init];
    if (self) {
        self.URL = URL;
        if ([target class] == target) {
            self.targetClass = target;
        }else{
            self.targetObjcet = target;
        }
        
        if (selector) {
            self.selector = selector;
            
        }else if ([target class] ==self.targetClass) { // 如果是类，默认传入初始化方法
            
            self.selector = NSSelectorFromString(@"init");
        }
        
        [self compileURL];
        
        return self;
        
    }
    return self;
}

- (id)performWithURL:(NSURL *)URL
{
    NSDictionary *parametersDic = [URL.query queryKeyValueDic];
    return [self performWithParameterObject:parametersDic];
}


#pragma mark - Property


#pragma mark - Pravite

- (id)performWithParameterObject:(NSObject *)parameterObject
{
    /**
     1.拿到实例 或者 类 method 得到方法签名
     2.实例invoke
     3.拿到参数类型 ，进行参数赋值
     4.调用invoke 执行方法
     5.拿到返回值 并返回
     */
    
    
    id target = nil;
    Method method;
    
    if (self.targetObjcet) {
        target = self.targetObjcet;
        if (self.selector) {
            method = class_getInstanceMethod([self.targetObjcet class], self.selector);
        }else{
            return self.targetObjcet;
        }
        
    }else{// 如果是class  在init patter 的时候保证了默认会将selector 置为init

        method = class_getInstanceMethod(self.targetClass, self.selector);
        if (method) {//先看是否是对象方法
            target = [self.targetClass alloc];
            
        }else{//类方法
            method = class_getClassMethod(self.targetClass, self.selector);
            target = self.targetClass;
        }
    }
    
    
    NSMethodSignature * methodSignature = [target methodSignatureForSelector:self.selector];
    
    if (!methodSignature) return nil;
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:target];
    [invocation setSelector:self.selector];
    
    __weak typeof(self) _self = self;
    [self.queryKeys enumerateObjectsUsingBlock:^(NSString *  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(self) self = _self;
        
        //得到idx 对应位置的参数类型 前两个是 receiver 和 cmd
        NSInteger index = idx + 2;
        const char *typeChar =  [methodSignature getArgumentTypeAtIndex:index];
        URLPatternArgumentType type = URLPatternArgumentTypeForTypeChar(typeChar[0]);
        //parameterObject可能是对象或者字典 通过kvc 得到object 对应的 value
        id value = [parameterObject valueForKey:key];
        
        if (value == [NSNull null]) {
            value = nil;
        }
        if (value == nil && type != URLPatternArgumentType_Pointer) {
            value = @"0";
        }
        
        [self setArgument:value withType:type atIndex:index forInvocation:invocation];
        
    }];
    
    [invocation invoke];
    
    __unsafe_unretained id returnVal;
    if (methodSignature.methodReturnLength) {
        [invocation getReturnValue:&returnVal];
    }
    
    return returnVal;
}

- (void)setArgument:(id)argument
           withType:(URLPatternArgumentType)type
            atIndex:(NSInteger)index
      forInvocation:(NSInvocation *)invocation
{
    switch (type) {
            
        case URLPatternArgumentType_None:
            break;
            
        case URLPatternArgumentType_Integer:
        {
            int val = [argument intValue];
            [invocation setArgument:&val atIndex:index];
            break;
        }
            case URLPatternArgumentType_LongLong:
        {
            long long val = [argument longLongValue];
            [invocation setArgument:&val atIndex:index];
            break;
        }
            case URLPatternArgumentType_Bool:
        {
            BOOL val = [argument boolValue];
            [invocation setArgument:&val atIndex:index];
            break;
        }
            case URLPatternArgumentType_Float:
        {
            float val = [argument floatValue];
            [invocation setArgument:&val atIndex:index];
            break;
        }
            case URLPatternArgumentType_Double:
        {
            double val = [argument doubleValue];
            [invocation setArgument:&val atIndex:index];
            break;
        }
            
            case URLPatternArgumentType_Pointer:
        {
            [invocation setArgument:&argument atIndex:index];
            break;
        }

    }
}


URLPatternArgumentType URLPatternArgumentTypeForTypeChar(char argType)
{
    switch (argType) {
        case 'i':
        case 's':
        case 'l':
        case 'c':
        case 'I':
        case 'S':
        case 'L':
        case 'C':
        {
            return URLPatternArgumentType_Integer;
        }
            
        case 'q':
        case 'Q':
        {
            return URLPatternArgumentType_LongLong;
        }
        case 'f':
        {
            return URLPatternArgumentType_Float;
        }
        case 'd':
        {
            return URLPatternArgumentType_Double;
            
        }
        case 'B':
        {
            return URLPatternArgumentType_Bool;
        }
            
        default:
        {
            return URLPatternArgumentType_Pointer;
        }
    }
    
}

- (void)compileURL
{
    
    self.queryKeys = [self.URL.query queryKeys];
    self.identityString = [[self class] identityStringForURL:self.URL];
}

@end
