//
//  LKAboutViewCell.m
//  LKWallpaper
//
//  Created by Lukj on 2017/6/7.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import "LKAboutViewLabCell.h"
#import "UILabel+LKMomentLabel.h"
#import "UIButton+LKMomentButton.h"
#import <Masonry.h>
@implementation LKAboutViewLabCell

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


- (void)setLabel:(UILabel *)label {
    _label = label;
    
    label.text = label.text;
}

- (void)setupUI {
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = @"111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
    textLabel.numberOfLines = 0;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(50);
        make.right.offset(-50);
        make.bottom.offset(-10);
    }];
    
    self.label = textLabel;
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
