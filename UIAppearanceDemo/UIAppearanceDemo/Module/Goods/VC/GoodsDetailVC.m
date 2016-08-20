//
//  GoodsDetailVC.m
//  UIAppearanceDemo
//
//  Created by luguibin on 8/19/16.
//  Copyright © 2016 luguibin. All rights reserved.
//

#import "GoodsDetailVC.h"

@interface GoodsDetailVC ()

@property (nonatomic, strong) NSString  *goodsId;

@end

@implementation GoodsDetailVC

- (instancetype)initWithGoodsId:(NSString *)goodsId
{
    self = [super init];
    if (self) {
        self.goodsId = goodsId;
        if (!self.title) self.title = @"商品详情";
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"\n=====================goodsId:%@====================",self.goodsId);
}

@end
