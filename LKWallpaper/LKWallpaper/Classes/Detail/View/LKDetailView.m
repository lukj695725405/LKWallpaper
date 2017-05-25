//
//  LKDetailView.m
//  LKWallpaper
//
//  Created by Lukj on 2017/5/24.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import "LKDetailView.h"


@implementation LKDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {


    //  返回
    [self loadBtnWithImageName:@"Grid" andLKHomeDetailsBtnType:LKHomeDetailsBtnTypePop];
    //  预览
    [self loadBtnWithImageName:@"Grid" andLKHomeDetailsBtnType:LKHomeDetailsBtnTypeInspect];
    //  模糊修改
    [self loadBtnWithImageName:@"Grid-S" andLKHomeDetailsBtnType:LKHomeDetailsBtnTypeBlurred];
    //  下载保存相册
    [self loadBtnWithImageName:@"More" andLKHomeDetailsBtnType:LKHomeDetailsBtnTypeDownLoad];
    //  分享
    [self loadBtnWithImageName:@"Grid" andLKHomeDetailsBtnType:LKHomeDetailsBtnTypeShare];


}

- (void)loadBtnWithImageName:(NSString *)imageName andLKHomeDetailsBtnType:(LKHomeDetailsBtnType)type {

    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.tag = type;
    [self addSubview:btn];

}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat btnW = self.frame.size.width / 5;

    for (int i = 0; i < self.subviews.count; i++) {

        UIButton *btn = self.subviews[i];


        CGFloat x = btnW * i;

        btn.frame = CGRectMake(x, 0, btnW, 40);

    }


}


@end
