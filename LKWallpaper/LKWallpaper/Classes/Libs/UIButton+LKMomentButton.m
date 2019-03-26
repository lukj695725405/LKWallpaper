//
//  UIButton+LKMomentButton.m
//  LKWallpaper
//
//  Created by Lukj on 2017/5/26.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import "UIButton+LKMomentButton.h"

@implementation UIButton (LKMomentButton)

+ (instancetype) buttonWithBackgroundColor:(UIColor *)backgroundColor andFont:(CGFloat)font andImageName:(NSString *)imageName andTextColor:(UIColor *)textColor andText:(NSString *)text{
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.backgroundColor = backgroundColor;
    [button setTitle:text forState:UIControlStateNormal];
    button.titleLabel.textColor = textColor;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    return button;
}

@end
