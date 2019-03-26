//
//  LKDetailView.h
//  LKWallpaper
//
//  Created by Lukj on 2017/5/24.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LKHomeDetailBtnTypePop = 10,    //  返回
    LKHomeDetailBtnTypeDownLoad,// 下载
    LKHomeDetailBtnTypeShare,//    分享
    LKHomeDetailBtnTypeBlurred,//  模糊
    LKHomeDetailBtnTypeInspect,//   预览
    LKHomeDetailsBtnTypeSweethearts,//  情侣按钮
    LKHomeDetailBtnTypeInfo//   info

} LKHomeDetailsBtnType;

@interface LKDetailView : UIView

@end
