//
//  LKHomeViewController.h
//  LKWallpaper
//
//  Created by Lukj on 2017/5/21.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKWallpaper.h"
@interface LKHomeViewController : UIViewController

@property(nonatomic, strong) NSArray <LKWallpaper *>*data;
@property(nonatomic, strong) NSMutableSet *idSet;

@end
