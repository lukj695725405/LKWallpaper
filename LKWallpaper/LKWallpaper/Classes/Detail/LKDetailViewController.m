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
#import "LKInfoWebViewViewController.h"
#import <AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "WXApi.h"

typedef enum : NSUInteger {
    LKCoverLeftBtn = 10,
    LKCoverRightBtn
} LKCoverBtn;

@interface LKDetailViewController ()

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIImage *imageViewImage;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, assign) CGSize screenSize;
@property(nonatomic, assign) float screenRatio;
@property(nonatomic, assign) float imageViewOffset;
@property(nonatomic, strong) LKDetailSlider *blurredSlider;
//  预览视图
@property(nonatomic, strong) UIImageView *inspectImageView;
//  点击情侣按钮后出现的右边的预览视图
@property(nonatomic, strong) UIImageView *rightInspectImageView;
//@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) UIImage *homeImage;
@property(nonatomic, strong) UIImage *lockScreenImage;
@property(nonatomic, strong) LKInfoWebViewViewController *infoWebViewController;
@property(nonatomic, strong) LKDetailView *tabBarView;
@property (nonatomic, strong)MBProgressHUD * hud;
@property (nonatomic, strong)MBProgressHUD * savePhotoHud;
//  timer
@property(nonatomic, strong)NSTimer *timer;
//  左边的view
@property(nonatomic, strong)UIView *leftPaddingView;
//  右边的view
@property(nonatomic, strong)UIView *rightPaddingView;
//  情侣按钮的标记
@property(nonatomic, assign)BOOL isSweetheartsBtnSelect;
//  点击返回的按钮
@property(nonatomic, strong)UIButton *popBtn;
//  点击下载的按钮
@property(nonatomic, strong)UIButton *downLoadBtn;
//  点击模糊的按钮
@property(nonatomic, strong)UIButton *blurredBtn;
//  点击情侣的按钮
@property(nonatomic, strong)UIButton *sweetheartsBtn;
//  点击预览的按钮
@property(nonatomic, strong)UIButton *inspectBtn;
//  点击分享的按钮
@property(nonatomic, strong)UIButton *sharedBtn;
//  点击info
@property(nonatomic, strong)UIButton *infoBtn;
//  中间的黑线
@property(nonatomic, strong)UIView *middleLine;

//  左边的点击下载
@property(nonatomic, strong)UIButton *leftCoverBtn;
//  右边的点击下载
@property(nonatomic, strong)UIButton *rightCoverBtn;
//  点击下载按钮的标记
@property(nonatomic, assign)BOOL isDownLoadBtnSelect;
@end

const int TabbarHeight = 40;

@implementation LKDetailViewController

//  MARK:view将要显示的时候
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.imageView.image = nil;
    
    
    if (self.imageView.image == nil) {
        self.tabBarView.hidden = YES;
    }
    
    
    [self loadImage:self.wallpaper.fullUrl completion:^(UIImage *image) {
        self.image = image;
        
        CGSize newSize = [self fitSize:self.image.size toSize:self.scrollView.bounds.size];
        self.imageViewImage = [self resizeImage:self.image toSize:newSize];
        self.imageView.image = self.imageViewImage;
        
        self.imageView.frame = CGRectMake(0, 0, newSize.width, newSize.height);
        self.scrollView.contentSize = newSize;
        self.scrollView.contentOffset = CGPointZero;
        self.blurredSlider.value = 0;
        self.tabBarView.hidden = NO;
    }];
}

//  MARK:view将要消失的时候
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //  显示电池栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    self.inspectImageView.image = nil;
    [self hideBlurredSliderWithAnimation:NO];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self setupUI];
}

//  view已经消失
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    self.scrollView.transform = CGAffineTransformIdentity;
    self.popBtn.transform = CGAffineTransformIdentity;
    self.downLoadBtn.transform = CGAffineTransformIdentity;
    self.blurredBtn.transform = CGAffineTransformIdentity;
    self.sweetheartsBtn.transform = CGAffineTransformIdentity;
    self.inspectBtn.transform = CGAffineTransformIdentity;
    self.sharedBtn.transform = CGAffineTransformIdentity;
    self.infoBtn.transform = CGAffineTransformIdentity;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0, self.imageViewOffset, 0, self.imageViewOffset);
    
    self.scrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - TabbarHeight);
    CGSize newSize = [self fitSize:self.image.size toSize:self.scrollView.frame.size];
    
    self.imageViewImage = [self resizeImage:self.image toSize:newSize];
    self.imageView.image = self.imageViewImage;
    
    self.imageView.frame = CGRectMake(0, 0, newSize.width, newSize.height);
    self.scrollView.contentSize = newSize;
    self.scrollView.contentOffset = CGPointZero;
    self.leftPaddingView.hidden = NO;
    self.rightPaddingView.hidden = NO;
    self.isSweetheartsBtnSelect = NO;
    
    self.inspectImageView.transform = CGAffineTransformIdentity;
    //  scrollView上的imageView 预览视图
    self.inspectImageView.frame = CGRectMake(self.imageViewOffset, 0, self.view.bounds.size.width - 2 * self.imageViewOffset, self.view.bounds.size.height - TabbarHeight);
    
    self.rightInspectImageView.hidden = YES;
    self.rightInspectImageView.image = nil;
    
    self.middleLine.hidden = YES;
    self.rightCoverBtn.hidden = YES;
    self.leftCoverBtn.hidden = YES;
    
    
}


- (void)setupUI {
    
    self.infoWebViewController = [[LKInfoWebViewViewController alloc]init];
    self.tabBarView = [[LKDetailView alloc] init];
    self.tabBarView.backgroundColor = [UIColor blackColor];

    //  点击返回的按钮
    UIButton *popBtn = [self.tabBarView viewWithTag:LKHomeDetailBtnTypePop];
    [popBtn addTarget:self action:@selector(clickPopBtn) forControlEvents:UIControlEventTouchUpInside];
    //  点击下载的按钮
    UIButton *downLoadBtn = [self.tabBarView viewWithTag:LKHomeDetailBtnTypeDownLoad];
    [downLoadBtn addTarget:self action:@selector(clickDownLoadBtn) forControlEvents:UIControlEventTouchUpInside];
    //  点击模糊的按钮
    UIButton *blurredBtn = [self.tabBarView viewWithTag:LKHomeDetailBtnTypeBlurred];
    [blurredBtn addTarget:self action:@selector(toggleBlurredSlider) forControlEvents:UIControlEventTouchUpInside];
    //  点击情侣按钮
    UIButton *sweetheartsBtn = [self.tabBarView viewWithTag:LKHomeDetailsBtnTypeSweethearts];
    [sweetheartsBtn addTarget:self action:@selector(sweetheartsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //  创建slider滑块
    self.blurredSlider = [[LKDetailSlider alloc] init];
    [self.blurredSlider addTarget:self action:@selector(changeBlurredSlider:) forControlEvents:UIControlEventValueChanged];
    //  点击预览的按钮
    UIButton *inspectBtn = [self.tabBarView viewWithTag:LKHomeDetailBtnTypeInspect];
    [inspectBtn addTarget:self action:@selector(toggleInspect) forControlEvents:UIControlEventTouchUpInside];
    self.blurredSlider.alpha = 0;
    //  点击分享的按钮
    UIButton *sharedBtn = [self.tabBarView viewWithTag:LKHomeDetailBtnTypeShare];
    [sharedBtn addTarget:self action:@selector(clickShareBtn) forControlEvents:UIControlEventTouchUpInside];
    // info
    UIButton *infoBtn = [self.tabBarView viewWithTag:LKHomeDetailBtnTypeInfo];
    [infoBtn addTarget:self action:@selector(infoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;

    //  scrollView
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
    
    //  左边的小黑边
    UIView *leftPaddingView = [[UIView alloc] init];
    leftPaddingView.backgroundColor = [UIColor blackColor];
    leftPaddingView.alpha = 0.5;
//    leftPaddingView.frame = CGRectMake(0, 0, self.imageViewOffset, scrollView.bounds.size.height);
    
    //  右边的小黑边
    UIView *rightPaddingView = [[UIView alloc] init];
    rightPaddingView.backgroundColor = [UIColor blackColor];
    rightPaddingView.alpha = 0.5;

    //  scrollView上的ImageView预览视图
    UIImageView *inspectImageView = [[UIImageView alloc] init];
    
    inspectImageView.frame = CGRectMake(self.imageViewOffset, 0, self.view.bounds.size.width - 2 * self.imageViewOffset, self.view.bounds.size.height - TabbarHeight);
    self.inspectImageView = inspectImageView;
    self.homeImage = [UIImage imageNamed:@"Home"];
    self.lockScreenImage = [UIImage imageNamed:@"LockScreen"];

    //  点击情侣按钮之后显示右边的预览视图
    UIImageView *rightInspectImageView = [[UIImageView alloc] init];
    self.rightInspectImageView = rightInspectImageView;
    //  中间的黑线
    UIView *middleLine = [[UIView alloc] init];
    middleLine.backgroundColor = [UIColor redColor];
    self.middleLine = middleLine;
    
    //  左边的点击下载
    UIButton *leftCoverBtn = [[UIButton alloc]init];
    leftCoverBtn.backgroundColor = [UIColor blackColor];
    leftCoverBtn.tag = LKCoverLeftBtn;
    leftCoverBtn.alpha = 0;
    //  左边的点击下载
    UIButton *rightCoverBtn = [[UIButton alloc]init];
    rightCoverBtn.backgroundColor = [UIColor blackColor];
    rightCoverBtn.tag = LKCoverRightBtn;
    rightCoverBtn.alpha = 0;
    [rightCoverBtn addTarget:self action:@selector(clickCoverBtn:) forControlEvents:UIControlEventTouchUpInside];
    [leftCoverBtn addTarget:self action:@selector(clickCoverBtn:) forControlEvents:UIControlEventTouchUpInside];
    //  添加
    [self.view addSubview:self.tabBarView];
    [self.view addSubview:scrollView];
    [scrollView addSubview:imageView];
    [self.view addSubview:inspectImageView];
    [self.view addSubview:rightInspectImageView];
    [self.view addSubview:leftPaddingView];
    [self.view addSubview:rightPaddingView];
    [self.view addSubview:self.blurredSlider];
    [self.view addSubview:middleLine];
    [self.view addSubview:leftCoverBtn];
    [self.view addSubview:rightCoverBtn];
    //  布局
    [self.tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.mas_equalTo(TabbarHeight);
    }];

    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.equalTo(self.tabBarView.mas_top).offset(0);
    }];

    [self.blurredSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.tabBarView.mas_top).offset(-10);
        make.width.mas_equalTo(300);
    }];
    [leftPaddingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.mas_offset(self.imageViewOffset);
        make.height.mas_offset(scrollView.bounds.size.height);
    }];
    [rightPaddingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.width.mas_offset(self.imageViewOffset);
        make.height.mas_offset(scrollView.bounds.size.height);
    }];
    
    
    //  关联
    self.leftPaddingView = leftPaddingView;
    self.rightPaddingView = rightPaddingView;
    self.popBtn = popBtn;
    self.downLoadBtn = downLoadBtn;
    self.blurredBtn = blurredBtn;
    self.sweetheartsBtn = sweetheartsBtn;
    self.inspectBtn = inspectBtn;
    self.sharedBtn = sharedBtn;
    self.infoBtn = infoBtn;
    self.leftCoverBtn = leftCoverBtn;
    self.rightCoverBtn = rightCoverBtn;
}


//  隐藏电池
- (BOOL)prefersStatusBarHidden {
    return YES;
}

//  加载图片
- (void)loadImage:(NSString *)imageUrl completion:(void(^)(UIImage *image))completion{
    
    //  延时加载 延迟0.5s后创建MBProgressHUD
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(countDown) userInfo:nil repeats:NO];
    NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
    [currentRunLoop addTimer:_timer forMode:NSRunLoopCommonModes];
    
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    //  这里每次都调用
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //  计算图片下载的进度
                        self.hud.progress = (float)receivedSize / expectedSize;
                    });
                    
                } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    
                    if (error) {
                        [[SDImageCache sharedImageCache] removeImageForKey:imageUrl withCompletion:^{
                            [self showMsg:@"网络不稳定" duration:1 imgName:nil];
                            [self.hud hideAnimated:YES];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.navigationController popViewControllerAnimated:YES];
                            });
                        }];
                        
                        return;
                    }
                    
                    [self.hud hideAnimated:YES];
                    completion(image);
                    [_timer invalidate];
                    _timer = nil;
                }];
                break;
            }
                
            case AFNetworkReachabilityStatusNotReachable:
            default: {
                [self showMsg:@"加载失败" duration:1 imgName:nil];
                [self.hud hideAnimated:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
                break;
            }
        }
        [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    }];

}
- (void)countDown {

    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hud.mode = MBProgressHUDModeDeterminate;
    self.hud.label.text = NSLocalizedString(@"正在加载...", @"HUD loading title");
    
    // Configure the button.
    [self.hud.button setTitle:NSLocalizedString(@"取消", @"HUD cancel button title") forState:UIControlStateNormal];
    [self.hud.button addTarget:self action:@selector(cancelWork:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cancelWork:(id)sender {
    
    [self.hud hideAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


//  MARK:图片裁切
- (UIImage *)captureScrollView:(UIScrollView *)scrollView andCoverBtnTag:(NSInteger)tag {
    
    CGFloat screenHeight = self.screenSize.height;
    
    if (!self.isSweetheartsBtnSelect) {
        
        
        CGPoint scrollViewOffsetPoint = scrollView.contentOffset;
        CGFloat ratio = screenHeight / (screenHeight - TabbarHeight);
        
        //prepare image with screen height
        CGSize newSize = [self fitSize:self.image.size toSize:self.screenSize];
        UIImage *tempImage = [self resizeImage:self.image toSize:newSize];
        //crop image
        UIGraphicsBeginImageContextWithOptions(self.screenSize, NO, [[UIScreen mainScreen] scale]);
        [tempImage drawAtPoint:CGPointMake((-scrollViewOffsetPoint.x - self.imageViewOffset) * ratio, -scrollViewOffsetPoint.y * ratio)];
        
    }else {
        
        CGFloat ratio = screenHeight / self.scrollView.bounds.size.height;
        NSLog(@"%f-%f-%f-%f", self.view.bounds.size.height,self.view.bounds.size.width, self.scrollView.bounds.size.height, self.scrollView.bounds.size.width / 2);
        CGPoint scrollViewOffsetPoint = scrollView.contentOffset;
        CGSize newSize = [self fitSize:self.image.size toSize:self.screenSize];
        UIImage *tempImage = [self resizeImage:self.image toSize:newSize];
        UIGraphicsBeginImageContextWithOptions(self.screenSize, NO, [[UIScreen mainScreen] scale]);
        
        if (tag == LKCoverLeftBtn) {
            
            //  截取左边的
            [tempImage drawAtPoint:CGPointMake(-scrollViewOffsetPoint.x * ratio, -scrollViewOffsetPoint.y * ratio)];
            
        }else if(tag == LKCoverRightBtn) {
            //  截取右边的
            [tempImage drawAtPoint:CGPointMake((-scrollViewOffsetPoint.x - self.inspectImageView.bounds.size.width) * ratio, -scrollViewOffsetPoint.y * ratio)];
            
        }

    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return [newImage applyBlurWithRadius:self.blurredSlider.value tintColor:nil saturationDeltaFactor:1 maskImage:nil];
}


/**
 
 设置图片的大小
 @param originSize 图片的size
 @param targetSize scrollView的size
 @return 计算后的图片的大小
 */
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

//  回调方法
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

    self.savePhotoHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    //  改变提示窗的颜色
    self.savePhotoHud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.savePhotoHud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.5];
    //  提示窗弹出的时候, 修改不能点击屏幕的问题
    self.savePhotoHud.userInteractionEnabled = NO;

    // 显示模式,改成customView,即显示自定义图片(mode设置,必须写在customView赋值之前)
    self.savePhotoHud.mode = MBProgressHUDModeCustomView;

    // 设置要显示 的自定义的图片
    self.savePhotoHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    // 显示的文字,比如:加载失败...加载中...
    self.savePhotoHud.label.text = msg;
    self.savePhotoHud.label.textColor = [UIColor whiteColor];
    // 标志:必须为YES,才可以隐藏,  隐藏的时候从父控件中移除
    self.savePhotoHud.removeFromSuperViewOnHide = YES;
    [self.savePhotoHud hideAnimated:YES afterDelay:time];
}





//  MARK:点击模糊按钮的btn
- (void)showBlurredSliderWithAnimation:(BOOL)animate {
    float animationDuration = 0.3;
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
        self.rightInspectImageView.image = nil;
    }
}


- (void)hideBlurredSliderWithAnimation:(BOOL)animate {
    float animationDuration = 0.3;
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


//  滑块的监听事件
- (void)changeBlurredSlider:(LKDetailSlider *)sender {

    self.imageView.image = [self.imageViewImage applyBlurWithRadius:sender.value tintColor:nil saturationDeltaFactor:1 maskImage:nil];

}


- (void)toggleInspect {

    if (self.inspectImageView.image == nil) {
        self.inspectImageView.image = self.homeImage;
        self.rightInspectImageView.image = self.homeImage;
        [self hideBlurredSliderWithAnimation:NO];
    } else if (self.inspectImageView.image == self.homeImage) {
        self.inspectImageView.image = self.lockScreenImage;
        self.rightInspectImageView.image = self.lockScreenImage;
        [self hideBlurredSliderWithAnimation:NO];
    } else {
        self.inspectImageView.image = nil;
        self.rightInspectImageView.image = nil;
    }

}



//  MARK:点击分享的按钮
- (void)clickShareBtn {
    
    UIImage* image = [self captureScrollView:self.scrollView andCoverBtnTag:0];
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[self imageWithImageSimple:image scaledToSize:image.size]];
    
    WXImageObject *ext = [WXImageObject object];
    
    ext.imageData = UIImagePNGRepresentation(image);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    
    [WXApi sendReq:req];
}




//  图片必须按照微信SDK说明压缩到15K以内大小。压缩函数如下：
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}


- (void)sweetheartsBtnClicked:(UIButton *)sender {
    
    
    if (!sender.selected && !self.isSweetheartsBtnSelect) {
        
        self.leftPaddingView.hidden = YES;
        self.rightPaddingView.hidden = YES;
        
        [UIView animateWithDuration:0.5 animations:^{
            
            //  transform旋转 bounds大小输出不改变, frame大小位置发生改变
            self.scrollView.transform = CGAffineTransformRotate(self.scrollView.transform, M_PI_2);
            self.scrollView.frame = CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.width / (self.screenSize.height / self.screenSize.width) * 2);
        
            CGSize newSize = [self fitSize:self.image.size toSize:self.scrollView.bounds.size];

            self.imageViewImage = [self resizeImage:self.image toSize:newSize];
            self.imageView.image = self.imageViewImage;
            
            self.imageView.frame = CGRectMake(0, 0, newSize.width, newSize.height);
            self.scrollView.contentSize = newSize;
            self.scrollView.contentOffset = CGPointZero;
            
            self.inspectImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
            
            //  scrollView上的imageView 预览视图
            self.inspectImageView.frame = CGRectMake(0, self.scrollView.frame.origin.y, self.view.bounds.size.width, self.scrollView.bounds.size.width / 2);
            //  设置scrollView的内间距
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            //  标记
            self.isSweetheartsBtnSelect = YES;
            
            self.popBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.downLoadBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.blurredBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.sweetheartsBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.inspectBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.sharedBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.infoBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
            
//            [UIView animateWithDuration:1.5 animations:^{
//                self.sharedBtn.alpha = 0;
//                
//            } completion:^(BOOL finished) {
//                
//                [self.sharedBtn removeFromSuperview];
//            }];
            
            
        } completion:^(BOOL finished) {
            self.middleLine.hidden = NO;
            self.rightInspectImageView.hidden = NO;
            //  点击情侣按钮右边的预览视图
            self.rightInspectImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.rightInspectImageView.frame = CGRectMake(0, self.scrollView.frame.origin.y + self.inspectImageView.bounds.size.width, self.view.bounds.size.width, self.scrollView.bounds.size.width / 2);
            //  中间的黑线
            self.middleLine.frame = CGRectMake(0, self.scrollView.frame.origin.y + self.inspectImageView.bounds.size.width, self.view.bounds.size.width, 1);
            //  左边的下载Btn罩层
            self.leftCoverBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.leftCoverBtn.frame = self.inspectImageView.frame;
            [self.leftCoverBtn setTitle:@"点击左边下载   右边分享" forState:UIControlStateNormal];
            self.leftCoverBtn.titleLabel.numberOfLines = 0;
            //  右边的下载Btn罩层
            self.rightCoverBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.rightCoverBtn.frame = self.rightInspectImageView.frame;
            [self.rightCoverBtn setTitle:@"点击右边下载  左边分享" forState:UIControlStateNormal];
            self.rightCoverBtn.titleLabel.numberOfLines = 0;
            self.rightCoverBtn.hidden = YES;
            self.leftCoverBtn.hidden = YES;
        }];
        
       
        
    }else {
        
        self.isSweetheartsBtnSelect = NO;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.contentInset = UIEdgeInsetsMake(0, self.imageViewOffset, 0, self.imageViewOffset);
            self.scrollView.transform = CGAffineTransformIdentity;
            self.popBtn.transform = CGAffineTransformIdentity;
            self.downLoadBtn.transform = CGAffineTransformIdentity;
            self.blurredBtn.transform = CGAffineTransformIdentity;
            self.sweetheartsBtn.transform = CGAffineTransformIdentity;
            self.inspectBtn.transform = CGAffineTransformIdentity;
            self.sharedBtn.transform = CGAffineTransformIdentity;
            self.infoBtn.transform = CGAffineTransformIdentity;
            
            self.scrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - TabbarHeight);
            CGSize newSize = [self fitSize:self.image.size toSize:self.scrollView.frame.size];
            
            self.imageViewImage = [self resizeImage:self.image toSize:newSize];
            self.imageView.image = self.imageViewImage;
            
            self.imageView.frame = CGRectMake(0, 0, newSize.width, newSize.height);
            self.scrollView.contentSize = newSize;
            self.scrollView.contentOffset = CGPointZero;
            self.leftPaddingView.hidden = NO;
            self.rightPaddingView.hidden = NO;
            
            
            self.inspectImageView.transform = CGAffineTransformIdentity;
//            //  scrollView上的imageView 预览视图
            self.inspectImageView.frame = CGRectMake(self.imageViewOffset, 0, self.view.bounds.size.width - 2 * self.imageViewOffset, self.view.bounds.size.height - TabbarHeight);
            self.rightCoverBtn.hidden = YES;
            self.leftCoverBtn.hidden = YES;
            self.middleLine.hidden = YES;
            self.rightInspectImageView.hidden = YES;
            
        }];
    }
    
}


//  点击info按钮
- (void)infoBtnClicked {
    
    [self.navigationController pushViewController:self.infoWebViewController animated:YES];
    self.infoWebViewController.urlStr = [NSString stringWithFormat:@"%@?utm_source=Lukj+Wallpaper+App&utm_medium=referral&utm_campaign=api-credit", self.wallpaper.userProfileUrl];
}


//  MARK:点击下载按钮的btn
- (void)clickDownLoadBtn {
    if (self.isSweetheartsBtnSelect == YES) {
        if (self.downLoadBtn.selected == NO && self.isDownLoadBtnSelect == NO) {
            
            self.isDownLoadBtnSelect = YES;
            self.rightCoverBtn.hidden = NO;
            self.leftCoverBtn.hidden = NO;
            [UIView animateWithDuration:0.5 animations:^{
                
                self.rightCoverBtn.alpha = 0.5;
                self.leftCoverBtn.alpha = 0.5;
                self.infoBtn.alpha = 0;
                self.infoBtn.alpha = 0;
                self.sharedBtn.alpha = 0;
                self.inspectBtn.alpha = 0;
                self.popBtn.alpha = 0;
                self.blurredBtn.alpha = 0;
                self.sweetheartsBtn.alpha = 0;
                self.blurredSlider.alpha = 0;
                self.inspectImageView.image = nil;
                self.rightInspectImageView.image = nil;
            }];
            
        }else {
            
            self.isDownLoadBtnSelect = NO;
            self.rightCoverBtn.hidden = YES;
            self.leftCoverBtn.hidden = YES;
            [UIView animateWithDuration:0.5 animations:^{
                self.rightCoverBtn.alpha = 0;
                self.leftCoverBtn.alpha = 0;
                self.infoBtn.alpha = 1;
                self.infoBtn.alpha = 1;
                self.sharedBtn.alpha = 1;
                self.inspectBtn.alpha = 1;
                self.popBtn.alpha = 1;
                self.blurredBtn.alpha = 1;
                self.sweetheartsBtn.alpha = 1;
            }];
            
            
        }
        
    }else {
        
        UIImage *image = [self captureScrollView:self.scrollView andCoverBtnTag:0];
        //调用方法
        [self saveImageToPhotos:image];
    }
}

- (void)clickCoverBtn:(UIButton *)sender {
    
    if (sender.tag == LKCoverLeftBtn) {
        NSLog(@"left");
        UIImage *image = [self captureScrollView:self.scrollView andCoverBtnTag:LKCoverLeftBtn];
        //调用方法
        [self saveImageToPhotos:image];
        
        
        UIImage* sharedImage = [self captureScrollView:self.scrollView andCoverBtnTag:LKCoverRightBtn];
        
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:[self imageWithImageSimple:sharedImage scaledToSize:sharedImage.size]];
        
        WXImageObject *ext = [WXImageObject object];
        
        ext.imageData = UIImagePNGRepresentation(sharedImage);
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        
        [WXApi sendReq:req];

        
        
    }else {
        
        NSLog(@"right");
        UIImage *image = [self captureScrollView:self.scrollView andCoverBtnTag:LKCoverRightBtn];
        //调用方法
        [self saveImageToPhotos:image];
        
        UIImage* sharedImage = [self captureScrollView:self.scrollView andCoverBtnTag:LKCoverLeftBtn];
        
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:[self imageWithImageSimple:sharedImage scaledToSize:sharedImage.size]];
        
        WXImageObject *ext = [WXImageObject object];
        
        ext.imageData = UIImagePNGRepresentation(sharedImage);
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        
        [WXApi sendReq:req];

        
    }
    
}


//  MARK:点击返回按钮的btn
- (void)clickPopBtn {
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
