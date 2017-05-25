//
//  LKDetailViewController.m
//  LKWallpaper
//
//  Created by Lukj on 2017/5/24.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import "LKDetailViewController.h"
#import "LKDetailView.h"
#import <MBProgressHUD.h>
#import "LKDetailSlider.h"
#import "UIImage+ImageEffects.h"

@interface LKDetailViewController ()

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIImage *imageViewImage;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, assign) CGSize screenSize;
@property(nonatomic, assign) float screenRatio;
@property(nonatomic, assign) float imageViewOffset;
@property(nonatomic, strong) LKDetailSlider *blurredSlider;
@property(nonatomic, strong) UIImageView *inspectImageView;

@property(nonatomic, strong) UIImage *homeImage;
@property(nonatomic, strong) UIImage *lockScreenImage;

@end

const int TabbarHeight = 40;

@implementation LKDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor blackColor];
    [self setupUI];
}

- (void)setupUI {

    LKDetailView *tabBarView = [[LKDetailView alloc] init];
    tabBarView.backgroundColor = [UIColor blackColor];

    //  点击返回的按钮
    UIButton *popBtn = [tabBarView viewWithTag:LKHomeDetailsBtnTypePop];
    [popBtn addTarget:self action:@selector(clickPopBtn) forControlEvents:UIControlEventTouchUpInside];
    //  点击下载的按钮
    UIButton *downLoadBtn = [tabBarView viewWithTag:LKHomeDetailsBtnTypeDownLoad];
    [downLoadBtn addTarget:self action:@selector(clickDownLoadBtn) forControlEvents:UIControlEventTouchUpInside];
    //  点击模糊的按钮
    UIButton *blurredBtn = [tabBarView viewWithTag:LKHomeDetailsBtnTypeBlurred];
    [blurredBtn addTarget:self action:@selector(toggleBlurredSlider) forControlEvents:UIControlEventTouchUpInside];
    //  创建slider滑块
    self.blurredSlider = [[LKDetailSlider alloc] init];
    [self.blurredSlider addTarget:self action:@selector(changeBlurredSlider:) forControlEvents:UIControlEventValueChanged];
    //  点击模糊的按钮
    UIButton *inspectBtn = [tabBarView viewWithTag:LKHomeDetailsBtnTypeInspect];
    [inspectBtn addTarget:self action:@selector(toggleInspect) forControlEvents:UIControlEventTouchUpInside];

    self.blurredSlider.alpha = 0;
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - TabbarHeight);
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView = scrollView;

    self.screenSize = UIScreen.mainScreen.bounds.size;
    self.screenRatio = self.screenSize.height / self.screenSize.width;
    self.imageViewOffset = (self.screenSize.width - (self.view.bounds.size.height - TabbarHeight) / self.screenRatio) / 2;
    scrollView.contentInset = UIEdgeInsetsMake(0, self.imageViewOffset, 0, self.imageViewOffset);

    UIView *leftPaddingView = [[UIView alloc] init];
    leftPaddingView.backgroundColor = [UIColor blackColor];
    leftPaddingView.alpha = 0.5;
    leftPaddingView.frame = CGRectMake(0, 0, self.imageViewOffset, scrollView.bounds.size.height);


    UIView *rightPaddingView = [[UIView alloc] init];
    rightPaddingView.backgroundColor = [UIColor blackColor];
    rightPaddingView.alpha = 0.5;
    rightPaddingView.frame = CGRectMake(self.screenSize.width - self.imageViewOffset, 0, self.imageViewOffset, scrollView.bounds.size.height);


    UIImageView *inspectImageView = [[UIImageView alloc] init];
    inspectImageView.frame = CGRectMake(self.imageViewOffset, 0, self.view.bounds.size.width - 2 * self.imageViewOffset, self.view.bounds.size.height - TabbarHeight);
    self.inspectImageView = inspectImageView;
    self.homeImage = [UIImage imageNamed:@"Home"];
    self.lockScreenImage = [UIImage imageNamed:@"LockScreen"];

    //  添加
    [self.view addSubview:tabBarView];
    [self.view addSubview:scrollView];
    [scrollView addSubview:imageView];
    [self.view addSubview:leftPaddingView];
    [self.view addSubview:rightPaddingView];
    [self.view addSubview:inspectImageView];
    [self.view addSubview:self.blurredSlider];

    //  布局
    [tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.mas_equalTo(TabbarHeight);
    }];

    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.equalTo(tabBarView.mas_top).offset(0);
    }];

    [self.blurredSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(tabBarView.mas_top).offset(-10);
        make.width.mas_equalTo(300);
    }];

//    [inspectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(scrollView);
//        make.left.equalTo(scrollView.mas_left).offset(self.imageViewOffset);
//        make.right.equalTo(scrollView.mas_right).offset(self.imageViewOffset);
//    }];


}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

//  MARK:view将要显示的时候
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //  隐藏电池栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    CGSize newSize = [self fitSize:self.image.size toSize:self.scrollView.bounds.size];

    self.imageViewImage = [self resizeImage:self.image toSize:newSize];
    self.imageView.image = self.imageViewImage;

    self.imageView.frame = CGRectMake(0, 0, newSize.width, newSize.height);
    self.scrollView.contentSize = newSize;
    self.scrollView.contentOffset = CGPointZero;
}

//  MARK:view将要消失的时候
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //  显示电池栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

    [self hideBlurredSliderWithAnimation:NO];

}

- (UIImage *)captureScrollView:(UIScrollView *)scrollView {
    CGFloat screenHeight = self.screenSize.height;

    CGPoint scrollViewOffsetPoint = scrollView.contentOffset;
    CGFloat ratio = screenHeight / (screenHeight - TabbarHeight);

    //prepare image with screen height
    CGSize newSize = [self fitSize:self.image.size toSize:self.screenSize];
    UIImage *tempImage = [self resizeImage:self.image toSize:newSize];

    //crop image
    UIGraphicsBeginImageContextWithOptions(self.screenSize, NO, [[UIScreen mainScreen] scale]);
    [tempImage drawAtPoint:CGPointMake((-scrollViewOffsetPoint.x - self.imageViewOffset) * ratio, -scrollViewOffsetPoint.y * ratio)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return [newImage applyBlurWithRadius:self.blurredSlider.value tintColor:nil saturationDeltaFactor:1 maskImage:nil];
}

- (CGSize)fitSize:(CGSize)originSize toSize:(CGSize)targetSize {

    CGFloat originHeight = originSize.height;
    CGFloat originWidth = originSize.width;
    CGFloat originRatio = originHeight / originWidth;

    CGFloat targetHeight = targetSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetRatio = targetHeight / targetWidth;

    CGFloat resizeRatio;
    if (originRatio < targetRatio) {
        resizeRatio = originHeight / targetHeight;
    } else {
        resizeRatio = originWidth / targetWidth;
    }

    return CGSizeMake(originWidth / resizeRatio, originHeight / resizeRatio);
}

- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


//  MARK:保存图片的操作
- (void)saveImageToPhotos:(UIImage *)savedImage {
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    //因为需要知道该操作的完成情况，即保存成功与否，所以此处需要一个回调方法image:didFinishSavingWithError:contextInfo:
}

//回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil;
    BOOL succeed = false;
    if (error != NULL) {
        msg = @"保存图片失败";
        succeed = false;
    } else {
        msg = @"保存图片成功";
        succeed = true;
    }


    if (succeed) {
        [self showMsg:@"保存成功" duration:1 imgName:@"Bookmark-S"];


    } else {
        [self showMsg:@"保存失败" duration:1 imgName:@"Bookmark"];

    }
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





//  MARK:点击模糊按钮的btn

- (void)showBlurredSliderWithAnimation:(BOOL)animate {
    float animationDuration = 0.5;
    if (!animate) {
        animationDuration = 0;
    }
    if (self.blurredSlider.alpha == 0) {
        [self transformFrame:self.blurredSlider.frame offset:CGPointMake(0, 10)];
        [UIView animateWithDuration:animationDuration animations:^(void) {
            self.blurredSlider.alpha = 1;
            self.blurredSlider.frame = [self transformFrame:self.blurredSlider.frame offset:CGPointMake(0, -10)];
        }];
        self.inspectImageView.image = nil;
    }
}

- (void)hideBlurredSliderWithAnimation:(BOOL)animate {
    float animationDuration = 0.5;
    if (!animate) {
        animationDuration = 0;
    }
    if (self.blurredSlider.alpha == 1) {
        [UIView animateWithDuration:animationDuration animations:^(void) {
            self.blurredSlider.alpha = 0;
            self.blurredSlider.frame = [self transformFrame:self.blurredSlider.frame offset:CGPointMake(0, 10)];
        }];
    }
}

- (void)toggleBlurredSlider {
    if (self.blurredSlider.alpha == 0) {
        [self showBlurredSliderWithAnimation:YES];
    } else {
        [self hideBlurredSliderWithAnimation:YES];
    }
}


- (CGRect)transformFrame:(CGRect)frame offset:(CGPoint)offset {
    frame.origin = CGPointApplyAffineTransform(self.blurredSlider.frame.origin, CGAffineTransformMakeTranslation(offset.x, offset.y));
    return frame;
}


- (void)changeBlurredSlider:(LKDetailSlider *)sender {

    self.imageView.image = [self.imageViewImage applyBlurWithRadius:sender.value tintColor:nil saturationDeltaFactor:1 maskImage:nil];

}


- (void)toggleInspect {

    if (self.inspectImageView.image == nil) {
        self.inspectImageView.image = self.homeImage;
        [self hideBlurredSliderWithAnimation:NO];
    } else if (self.inspectImageView.image == self.homeImage) {
        self.inspectImageView.image = self.lockScreenImage;
        [self hideBlurredSliderWithAnimation:NO];
    } else {
        self.inspectImageView.image = nil;
    }

}

//  MARK:点击下载按钮的btn
- (void)clickDownLoadBtn {
    UIImage *image = [self captureScrollView:self.scrollView];
    //调用方法
    [self saveImageToPhotos:image];
}

//  MARK:点击返回按钮的btn
- (void)clickPopBtn {

    [self.navigationController popViewControllerAnimated:YES];
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
