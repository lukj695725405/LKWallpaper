//
//  LKCollectViewController.m
//  LKWallpaper
//
//  Created by Lukj on 2017/5/21.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import "LKCollectViewController.h"
#import "LKHomeCollectionViewFlowLayout.h"
#import "LKHomeCollectionViewCell.h"
#import "LKWallpaper.h"
#import "LKMainTabBarController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LKCollectViewController () <UICollectionViewDelegate, UICollectionViewDataSource>


@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) LKMainTabBarController *tabbarController;

@end

static NSString *cellID = @"cellID";

@implementation LKCollectViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
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

    self.tabbarController = (LKMainTabBarController *)self.tabBarController;
}




#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.tabbarController.collectWallpaperArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    LKWallpaper *wallpaper = self.tabbarController.collectWallpaperArray[(NSUInteger) indexPath.item];
    
    LKHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    UIButton *collectButton = [cell viewWithTag:10];
    //  当加载过的cell不会在走这里, 先默认设为false cell复用的解决问题
    collectButton.selected = wallpaper.collected;
    [collectButton addTarget:self action:@selector(clickCollectBtn:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *imageView = [cell viewWithTag:20];
    [imageView sd_setImageWithURL:[NSURL URLWithString:wallpaper.regularUrl]];
    cell.backgroundColor = wallpaper.backgroundColor;
    return cell;
}

- (void)clickCollectBtn:(UIButton *)sender {

    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(LKHomeCollectionViewCell *) sender.superview.superview];

    NSLog(@"did select button %zd", indexPath.item);

    LKWallpaper *wallpaper = self.tabbarController.collectWallpaperArray[(NSUInteger) indexPath.item];

    wallpaper.collected = !wallpaper.collected;
    sender.selected = wallpaper.collected;

    [self.tabbarController uncollectWallpaper:wallpaper];

    [self.collectionView reloadData];
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
