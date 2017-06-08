//
//  UIButton+LKMomentButton.h
//  LKWallpaper
//
//  Created by Lukj on 2017/5/26.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LKMomentButton)
+ (instancetype) buttonWithBackgroundColor:(UIColor *)backgroundColor andFont:(CGFloat)font andImageName:(NSString *)imageName andTextColor:(UIColor *)textColor andText:(NSString *)text;
@end
