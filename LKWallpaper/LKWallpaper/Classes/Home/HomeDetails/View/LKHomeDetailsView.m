//
//  LKHomeDetailsView.m
//  LKWallpaper
//
//  Created by Lukj on 2017/5/24.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import "LKHomeDetailsView.h"


@implementation LKHomeDetailsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    

    
    [self loadBtnWithImageName:@"Grid" andLKHomeDetailsBtnType:LKHomeDetailsBtnTypePop];
    [self loadBtnWithImageName:@"Grid" andLKHomeDetailsBtnType:LKHomeDetailsBtnTypeEdit];
    [self loadBtnWithImageName:@"Grid" andLKHomeDetailsBtnType:LKHomeDetailsBtnTypeInspect];
    [self loadBtnWithImageName:@"More" andLKHomeDetailsBtnType:LKHomeDetailsBtnTypeDownLoad];
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
