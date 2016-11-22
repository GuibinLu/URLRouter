//
//  ViewController.m
//  UIAppearanceDemo
//
//  Created by luguibin on 8/16/16.
//  Copyright © 2016 luguibin. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Add.h"
#import "NSString+URLMap.h"
#import "AppJumpFunction.h"
#import <JavaScriptCore/JavaScriptCore.h>



/**
 *  测试 js 对象方法 唤起 本地方法 属于内部类
 */

@protocol TestJSObjectToNativeDelegate <JSExport>

JSExportAs(share,
           
           - (void)shareWithTitle:(NSString *)title
           Content:(NSString *)content
           PlatformType:(NSString *)type);

;

- (void)add;

JSExportAs(sub, - (void)sub:(NSString *)num Name:(NSString *)name);

@end

@interface JSObject : NSObject<TestJSObjectToNativeDelegate>

@end


@implementation JSObject

#pragma mark - TestJSObjectToNativeDelegate

- (void)sub:(NSString *)num Name:(NSString *)name
{
    NSLog(@"%@--%@",num,name);
}

- (void)add
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)shareWithTitle:(NSString *)title
               Content:(NSString *)content
          PlatformType:(NSString *)type
{
    NSLog(@"%@---%@---%zd",title,content,type);
}

@end


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *myWebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIEventSubtypeNone;
    [self testJSC];
}

- (void)testJSC
{
    self.myWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height)];
    self.myWebView.delegate=self;
    //添加webview到当前viewcontroller的view上
    [self.view addSubview:self.myWebView];
    
    //网址
    NSString *httpStr=@"https://www.baidu.com";
    NSURL *httpUrl=[NSURL URLWithString:httpStr];
    NSURLRequest *httpRequest=[NSURLRequest requestWithURL:httpUrl];
    [self.myWebView loadRequest:httpRequest];
}

- (IBAction)goodsButtonClicked:(UIButton *)sender {
    [AppJumpFunction pushToViewControllerWithURLString:@"AppearanceDemo://page/goods/detail?goodsId=宝宝这次是真的委屈了，但宝宝没有憋住，发了个离婚声明" title:@"三亚珊瑚酒店3688"];
}

#pragma mark --webViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //网页加载之前会调用此方法
    
    //retrun YES 表示正常加载网页 返回NO 将停止网页加载
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //开始加载网页调用此方法
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    /**
     * 1
     * 简单调用   iOS -> js
     * NSString * alertJS = @"alert(' test alert jsc ')";
     * JSValue * jsValue = [context evaluateScript:alertJS];
     */
    
    /**
     *  2
     *  js -> iOS 全局方法 window
     *  假设web 端有一个分享按钮，点击后触发share事件 并调起native方法，可以通过block将实现赋值给share 这个function。没有的话会在js创建一个share function.
     *  在这个share function 触发时，你可以拿到跟当前触发方法相关的各种参数信息
     *
     *
     */

    context[@"share"] = ^(){
        NSArray * args = [JSContext currentArguments];
        for (id obj in args) {
            NSLog(@"%@",obj);
        }
    };
    
    //通过 iOS -> js 模拟一下 web调用了share 事件
    //[context evaluateScript:@"share('obj1','obj2','obj3')"];
    
    
    /**
     *  3 js ->iOS 对象方法调用
     *  仍然是通过context本地给js 关联一个jsObject ，然后模拟jsObject 调用
     */
    
    /**
     *  - (BOOL)shareWithTitle:(NSString *)title
     content:(NSString *)content
     platformType:(NSInteger)type
     */
    JSObject *jsObject = [JSObject new];
    context[@"jsObject"] = jsObject;
    
    NSString * addFunction = @"jsObject.add()";
    
    NSString * shareFunction = @"jsObject.share('KingZone','比较好的一个健身房','1')";
    [context evaluateScript:@"jsObject.sub('1','2')"];
    [context evaluateScript:addFunction];
    [context evaluateScript:shareFunction];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //网页加载失败 调用此方法
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


