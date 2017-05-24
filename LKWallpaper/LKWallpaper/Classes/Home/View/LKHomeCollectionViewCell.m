//
//  LKHomeCollectionViewCell.m
//  LKWallpaper
//
//  Created by Lukj on 2017/5/22.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import "LKHomeCollectionViewCell.h"

@implementation LKHomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI {

    self.collectBtn = [[UIButton alloc] init];
    [self.collectBtn setTag:10];
    
    [self.collectBtn setImage:[UIImage imageNamed:@"Bookmark"] forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage imageNamed:@"Bookmark-S"] forState:UIControlStateSelected];
   
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setTag:20];
    //  设置填充模式
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    //  超出部分裁切
    [imageView setClipsToBounds:YES];
    
    [self.contentView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView addSubview:self.collectBtn];
    
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(-10);
    }];
    
}

@end
