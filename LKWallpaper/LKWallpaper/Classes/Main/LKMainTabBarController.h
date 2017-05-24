//
//  LKMainTabBarController.h
//  LKWallpaper
//
//  Created by Lukj on 2017/5/21.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKWallpaper.h"
@interface LKMainTabBarController : UITabBarController

@property (nonatomic, strong) NSMutableArray *collectWallpaperArray;


- (void) collectWallpaper:(LKWallpaper *)newWallpaper;
- (void) uncollectWallpaper:(LKWallpaper *)existWallpaper;
- (LKWallpaper *) collectedWallpaper: (LKWallpaper *)checkedWallpaper;

@end
