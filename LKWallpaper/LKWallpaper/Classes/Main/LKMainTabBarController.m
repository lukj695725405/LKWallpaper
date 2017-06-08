//
//  LKMainTabBarController.m
//  LKWallpaper
//
//  Created by Lukj on 2017/5/21.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import "LKMainTabBarController.h"
#import "LKMianTabBar.h"

@interface LKMainTabBarController ()

@end

@implementation LKMainTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];

    // init data
    [self loadData];
    [self setupTabBarUI];

}

- (void)loadData {

    //  沙盒路径
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"collect.plist"];

    NSLog(@"%@", filePath);
    //  判断沙盒中是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        //  如果存在加载本地图片
        self.collectWallpaperArray = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:filePath]];
    } else {
        //  否则网络加载
        self.collectWallpaperArray = [[NSMutableArray alloc] init];
    }


}

- (void)setupTabBarUI {

    //  设置UITabBar的背景颜色
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    //  取消模糊的效果
    [UITabBar appearance].translucent = NO;

    LKMianTabBar *tabBar = [[LKMianTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];

    //  首页
    UIViewController *homeViewController = [self loadTabBarWithClassName:@"LKHomeViewController" andImageName:@"Grid" andTitle:@"首页"];
    //  给首页嵌入navbar
    UINavigationController *homeViewNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    //  注释运行你就知道
    homeViewController.edgesForExtendedLayout = UIRectEdgeNone;
    //  隐藏navbar
    [homeViewNavigationController setNavigationBarHidden:YES];


    //  收藏
    UIViewController *bookmarkViewController = [self loadTabBarWithClassName:@"LKBookmarkViewController" andImageName:@"Bookmark" andTitle:@"收藏"];
    //  给首页嵌入navbar
    UINavigationController *bookmarkViewNavigationController = [[UINavigationController alloc] initWithRootViewController:bookmarkViewController];
    //
    bookmarkViewController.edgesForExtendedLayout = UIRectEdgeNone;
    [bookmarkViewNavigationController setNavigationBarHidden:YES];


    //  详情
    UIViewController *detailsViewController = [self loadTabBarWithClassName:@"LKAboutViewController" andImageName:@"More" andTitle:@"详情"];

    self.viewControllers = @[homeViewNavigationController, bookmarkViewNavigationController, detailsViewController];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacheData) name:@"ApplicationWillTerminate" object:nil];
}

- (void)cacheData {

    //  沙盒路径
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"collect.plist"];
    [NSKeyedArchiver archiveRootObject:self.collectWallpaperArray toFile:filePath];
    NSLog(@"%@", filePath);

}


- (UIViewController *)loadTabBarWithClassName:(NSString *)className andImageName:(NSString *)imageName andTitle:(NSString *)title {

    Class clazz = NSClassFromString(className);
    UIViewController *vc = (UIViewController *) [[clazz alloc] init];
    //  设置UITabBar的内间距
    vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    //  设置图片以及使用原始图片颜色
    vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //  设置选中图片及使用原始图片颜色
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@-S", imageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    return vc;

}

- (void)collectWallpaper:(LKWallpaper *)newWallpaper {
    [self.collectWallpaperArray insertObject:newWallpaper atIndex:0];
}

- (void)uncollectWallpaper:(LKWallpaper *)existWallpaper {
    [self.collectWallpaperArray removeObject:existWallpaper];
}

- (LKWallpaper *)collectedWallpaper:(LKWallpaper *)checkedWallpaper {

    if ([self.collectWallpaperArray containsObject:checkedWallpaper]) {
        return checkedWallpaper;

    } else {
        for (LKWallpaper *wallpaper in self.collectWallpaperArray) {
            if ([wallpaper.wallpaperId isEqualToString:checkedWallpaper.wallpaperId]) {
                return wallpaper;
            }
        }
    }

    return checkedWallpaper;

}


//- (void)viewWillLayoutSubviews {
//    
//    [super viewWillLayoutSubviews];
//
//    
////      设置tabbat的高度
////    CGRect frame = self.tabBar.frame;
////    
////    frame.size.height = 35;
////    
////    frame.origin.y = self.view.frame.size.height - frame.size.height;
////    
////    self.tabBar.frame = frame;
////    
////    [self.tabBar sizeToFit];
//    
////    self.tabBar.backgroundColor = mRGBToColor(0xeaeaea);
//    
////    self.tabBar.barStyle = UIBarStyleBlack;
//    
////    此处需要设置barStyle，否则颜色会分成上下两层
//    
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
