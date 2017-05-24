//
//  LKHomeDetailsView.h
//  LKWallpaper
//
//  Created by Lukj on 2017/5/24.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    LKHomeDetailsBtnTypePop = 10,    //  返回
    LKHomeDetailsBtnTypeDownLoad,// 下载
    LKHomeDetailsBtnTypeShare,//    分享
    LKHomeDetailsBtnTypeEdit,//     修改
    LKHomeDetailsBtnTypeInspect//   预览
    
} LKHomeDetailsBtnType;

@interface LKHomeDetailsView : UIView

@end
