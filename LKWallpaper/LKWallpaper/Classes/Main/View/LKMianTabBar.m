//
//  LKMianTabBar.m
//  LKWallpaper
//
//  Created by Lukj on 2017/5/21.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import "LKMianTabBar.h"

@implementation LKMianTabBar


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    
}

//  设置tabBar的高度
-(CGSize)sizeThatFits:(CGSize)size
{
    CGSize sizeThatFits = [super sizeThatFits:size];
    sizeThatFits.height = 40;
    
    return sizeThatFits;
}

@end
