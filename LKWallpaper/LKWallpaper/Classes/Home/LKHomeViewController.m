//
//  LKHomeViewController.m
//  LKWallpaper
//
//  Created by Lukj on 2017/5/21.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import "LKHomeViewController.h"
#import "LKHomeCollectionViewFlowLayout.h"
#import "LKHomeCollectionViewCell.h"
#import "LKMainTabBarController.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking.h>
#import "LKDetailViewController.h"
#import "LKRefreshGifFooter.h"
#import "LKRefreshGifHeader.h"


@interface LKHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, assign) int currentPage;
@property(nonatomic, strong) LKMainTabBarController *mainTabBarController;
@property(nonatomic, strong) AFHTTPSessionManager *networkManager;
@property(nonatomic, strong) LKDetailViewController *detailsViewController;
@property(nonatomic, strong) UIImage *placeHolderImage;
@end

static NSString *cellID = @"cellID";

const int PageSize = 10;

@implementation LKHomeViewController


- (void)addData:(NSArray *)newData toHeader:(BOOL)addToHeader {

    NSMutableArray *distinctData = [[NSMutableArray alloc] init];

    for (LKWallpaper *wallpaper in newData) {

        LKWallpaper *tempWallpaper = [self.mainTabBarController collectedWallpaper:wallpaper];

        if ([self.idSet containsObject:tempWallpaper.wallpaperId]) {//   如果图片id存在就不做任何操作
            //ignore
        } else {//  否则就添加
            [self.idSet addObject:tempWallpaper.wallpaperId];
            [distinctData addObject:tempWallpaper];
        }
    }

    if (addToHeader) {// 如果为真 将数据添加到原来数据的前面
        self.data = [distinctData arrayByAddingObjectsFromArray:self.data];
        [self.collectionView.mj_header endRefreshing];
    } else {//  否则就添加到后面
        self.data = [self.data arrayByAddingObjectsFromArray:distinctData];
        [self.collectionView.mj_footer endRefreshing];
    }

    distinctData = nil;

}

- (void)loadDataFromNetwork:(BOOL)addToHeader {

    int page;
    if (addToHeader) { //    如果为真 则page始终为1
        page = 1;
    } else {//  否则++
        page = ++self.currentPage;
    }

    if (self.networkManager == nil) {
        self.networkManager = [AFHTTPSessionManager manager];
    }

    NSString *getUrl = [NSString stringWithFormat:@"https://api.unsplash.com/photos?client_id=c5f4e014076331726eb0c3379db2cfef0d9ac3a259d27b6fa9f6fe1171bf7c29&page=%d&per_page=%d", page, PageSize];
//c5f4e014076331726eb0c3379db2cfef0d9ac3a259d27b6fa9f6fe1171bf7c29
//395005f5b2b2da243b35408e946ff70212a51767673edefc795c95e540231a3f
    [self.networkManager GET:getUrl parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {

        NSArray *newData = [NSArray yy_modelArrayWithClass:[LKWallpaper class] json:responseObject];
        [self addData:newData toHeader:addToHeader];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        [self showMsg:@"加载失败" duration:1 imgName:nil];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.data = [[NSArray alloc] init];
    self.idSet = [[NSMutableSet alloc] init];
    self.mainTabBarController = (LKMainTabBarController *) self.tabBarController;

    self.currentPage = 1;

    //  沙盒路径
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"cache.plist"];
    NSLog(@"%@", filePath);
    //  判断沙盒中是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        //  如果存在加载本地图片
        [self addData:[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:filePath]] toHeader:false];
    } else {
        //  否则网络加载
        [self loadDataFromNetwork:false];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacheData) name:@"ApplicationWillTerminate" object:nil];


    self.detailsViewController = [[LKDetailViewController alloc] init];

    self.placeHolderImage = [UIImage imageNamed:@"Placeholder"];

    [self setupUI];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)cacheData {
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"cache.plist"];
    [NSKeyedArchiver archiveRootObject:[self.data subarrayWithRange:NSMakeRange(0, PageSize)] toFile:filePath];
}

- (void)setupUI {

    LKHomeCollectionViewFlowLayout *flowLayout = [[LKHomeCollectionViewFlowLayout alloc] init];

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [collectionView registerClass:[LKHomeCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.right.left.bottom.offset(0);
    }];

    self.collectionView = collectionView;

    //  关闭预加载模式, 防止出现突然出现然后又缩小的效果
    collectionView.prefetchingEnabled = NO;

//    // The pull to refresh
    collectionView.mj_header = [LKRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadDataFromNetwork:true];
    }];

    collectionView.mj_footer = [LKRefreshGifFooter footerWithRefreshingBlock:^{
        [self loadDataFromNetwork:false];
    }];

}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LKWallpaper *wallpaper = self.data[(NSUInteger) indexPath.item];

    LKHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    UIButton *bookmarkButton = [cell viewWithTag:10];
    //  当加载过的cell不会在走这里, 先默认设为false cell复用的解决问题
    bookmarkButton.selected = wallpaper.collected;
    [bookmarkButton addTarget:self action:@selector(clickCollectBtn:) forControlEvents:UIControlEventTouchUpInside];
    bookmarkButton.alpha = 0;

    UIImageView *imageView = [cell viewWithTag:20];

    [imageView sd_setImageWithURL:[NSURL URLWithString:wallpaper.regularUrl] placeholderImage:self.placeHolderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(!error) {
            bookmarkButton.alpha = 1;
        }
    }];


    cell.backgroundColor = wallpaper.backgroundColor;
    return cell;
}


//  点击按钮
- (void)clickCollectBtn:(UIButton *)sender {

    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(LKHomeCollectionViewCell *) sender.superview.superview];

    NSLog(@"did select button %zd", indexPath.item);

    LKWallpaper *wallpaper = self.data[(NSUInteger) indexPath.item];

//
    wallpaper.collected = !wallpaper.collected;
    sender.selected = wallpaper.collected;

    if (sender.selected) {
        [self showMsg:@"成功收藏" duration:1 imgName:@"Bookmark-S"];
        [self.mainTabBarController collectWallpaper:wallpaper];

    } else {
        [self showMsg:@"取消收藏" duration:1 imgName:@"Bookmark"];
        [self.mainTabBarController uncollectWallpaper:wallpaper];
    }

}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select %zd", indexPath.item);

    self.detailsViewController.hidesBottomBarWhenPushed = YES;
    self.detailsViewController.wallpaper = self.data[indexPath.row];
    [self.navigationController pushViewController:self.detailsViewController animated:YES];
//    [self.navigationController presentViewController:self.detailsViewController animated:YES completion:nil];
    
    
}

//  MARK:提示窗
- (void)showMsg:(NSString *)msg duration:(CGFloat)time imgName:(NSString *)imgName {

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    //  改变提示窗的颜色
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.5];
    //  提示窗弹出的时候, 修改不能点击屏幕的问题
    hud.userInteractionEnabled = NO;

    // 显示模式,改成customView,即显示自定义图片(mode设置,必须写在customView赋值之前)
    hud.mode = MBProgressHUDModeCustomView;

    // 设置要显示 的自定义的图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    // 显示的文字,比如:加载失败...加载中...
    hud.label.text = msg;
    hud.label.textColor = [UIColor whiteColor];
    // 标志:必须为YES,才可以隐藏,  隐藏的时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:time];
}

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
