//
//  LKAboutViewBtnCell.m
//  LKWallpaper
//
//  Created by Lukj on 2017/6/7.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import "LKAboutViewBtnCell.h"

@implementation LKAboutViewBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }

    return self;
}

- (void)setupUI {
    
    UIButton *button = [[UIButton alloc] init];
    button.tag = 20;
    [button setTintColor:[UIColor whiteColor]];
    button.backgroundColor = [UIColor grayColor];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(50);
        make.left.offset(50);
        make.right.offset(-50);
        make.bottom.offset(-10);
    }];
    
    self.button = button;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
