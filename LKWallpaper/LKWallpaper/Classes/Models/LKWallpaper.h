//
//  LKWallpaper.h
//  LKWallpaper
//
//  Created by Lukj on 2017/5/22.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>


@interface LKWallpaper : NSObject <NSCoding>

@property(nonatomic, strong) NSString *wallpaperId;

@property(nonatomic, strong) UIColor *backgroundColor;

@property(nonatomic, assign) BOOL collected;

@property(nonatomic, strong) NSString *rawUrl;
@property(nonatomic, strong) NSString *fullUrl;
@property(nonatomic, strong) NSString *regularUrl;
@property(nonatomic, strong) NSString *smallUrl;
@property(nonatomic, strong) NSString *thumbUrl;
@property(nonatomic, strong) NSString *userProfileUrl;
@property(nonatomic, assign) NSInteger height;
@property(nonatomic, assign) NSInteger width;

@property(nonatomic, assign) BOOL isCache;
@end
