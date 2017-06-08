//
//  UILabel+LKMomentLabel.m
//  01_生活圈
//
//  Created by Lukj on 2017/1/4.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import "UILabel+LKMomentLabel.h"

@implementation UILabel (LKMomentLabel)


+ (instancetype) labelWithColor:(UIColor *)color andFont:(CGFloat)font andText:(NSString *)text{
    
    UILabel *headLabel = [[UILabel alloc]init];
    headLabel.text = text;
    headLabel.textColor = color;
    headLabel.font = [UIFont systemFontOfSize:font];
    headLabel.numberOfLines = 0;
    return headLabel;
}
+ (instancetype) labelWithText:(NSString *)text{
    
    UILabel *headLabel = [[UILabel alloc]init];
    headLabel.text = text;
    return headLabel;
}
@end
