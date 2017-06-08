//
//  LKDetailSlider.m
//  LKWallpaper
//
//  Created by Lukj on 2017/5/25.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import "LKDetailSlider.h"

@implementation LKDetailSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSlider];
    }
    return self;
}

- (void)setupSlider {

    //  设置小球的颜色
    self.thumbTintColor = [UIColor whiteColor];
    //  给滑块，最小值一边，最大值一边配置颜色
    self.minimumTrackTintColor = [UIColor lightGrayColor];
    self.maximumTrackTintColor = [UIColor whiteColor];
    //  给滑块最大值、最小值一边设置图片
    UIImage *image1 = [UIImage imageNamed:@"Minus"];
    UIImage *image2 = [UIImage imageNamed:@"Add"];
    self.minimumValueImage = image1;
    self.maximumValueImage = image2;
    self.maximumValue = 10;
    self.minimumValue = 0;
    //  拖动滑块的过程中持续获取其值变更事件，如果是NO，则只有在滑动停止时才会获取变更事件
    self.continuous = NO;
    UIImage *image = [UIImage imageNamed:@"Roller"];
    [self setThumbImage:image forState:UIControlStateNormal];
    [self setThumbImage:image forState:UIControlStateHighlighted];

}


- (UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸

    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];

    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return scaledImage;

}
@end
