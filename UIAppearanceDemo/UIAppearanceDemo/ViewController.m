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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)goodsButtonClicked:(UIButton *)sender {
    [AppJumpFunction pushToViewControllerWithURLString:@"AppearanceDemo://page/goods/detail?goodsId=宝宝这次是真的委屈了，但宝宝没有憋住，发了个离婚声明" title:@"三亚珊瑚酒店3688"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
