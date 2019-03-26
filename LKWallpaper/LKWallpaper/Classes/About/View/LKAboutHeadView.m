//
//  LKAboutHeadView.m
//  LKWallpaper
//
//  Created by Lukj on 2017/6/7.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import "LKAboutHeadView.h"

@implementation LKAboutHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"Icon"];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setClipsToBounds:YES];
    
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.left.offset(150);
        make.right.offset(-150);
        make.height.mas_equalTo(200);
    }];

}

@end
