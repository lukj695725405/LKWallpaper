//
//  LKRefreshGifFooter.m
//  LKWallpaper
//
//  Created by Lukj on 2017/5/26.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import "LKRefreshGifFooter.h"

@implementation LKRefreshGifFooter

#pragma mark - 重写父类的方法
- (void)prepare{
    [super prepare];
    
    
    
//    // 设置普通状态的动画图片
//    NSMutableArray *idleImages = [NSMutableArray array];
//    for (NSUInteger i = 1; i<=60; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Loader%d", i+1]];
//        [idleImages addObject:image];
//    }
//    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 0; i < 63; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"frame_%d_delay-0.04s", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    //隐藏时间
    //    self.lastUpdatedTimeLabel.hidden = NO;
    /*隐藏*/
    self.refreshingTitleHidden = YES;
    //隐藏状态
    self.stateLabel.hidden = YES;
}

@end
