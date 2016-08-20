//
//  GoodsAPI.m
//  UIAppearanceDemo
//
//  Created by luguibin on 8/19/16.
//  Copyright © 2016 luguibin. All rights reserved.
//

#import "GoodsAPI.h"
#import "GoodsDetailVC.h"

@implementation GoodsAPI

+ (void)registerViewController
{
    //商品详情页
    [@"AppearanceDemo://page/goods/detail?goodsId=goodsId" registerWithTarget:[GoodsDetailVC class] selector:@selector(initWithGoodsId:)];
    
    //商品列表页 ...
    
    
}

@end
