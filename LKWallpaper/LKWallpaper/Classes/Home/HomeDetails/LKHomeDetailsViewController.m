//
//  LKHomeDetailsViewController.m
//  LKWallpaper
//
//  Created by Lukj on 2017/5/24.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import "LKHomeDetailsViewController.h"
#import "LKHomeDetailsView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD.h>
@interface LKHomeDetailsViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation LKHomeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI {
    
    LKHomeDetailsView *tabBarView = [[LKHomeDetailsView alloc] init];
    tabBarView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:tabBarView];
   
    
    //  返回按钮
    UIButton *popBtn = [tabBarView viewWithTag:LKHomeDetailsBtnTypePop];
    [popBtn addTarget:self action:@selector(clickPopBtn) forControlEvents:UIControlEventTouchUpInside];
    //  点击下载的按钮
    UIButton *downLoadBtn = [tabBarView viewWithTag:LKHomeDetailsBtnTypeDownLoad];
    [downLoadBtn addTarget:self action:@selector(clickDownLoadBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView = scrollView;
    
    [self.view addSubview:scrollView];
    [scrollView addSubview:imageView];
    
    
    //  布局
    [tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.mas_equalTo(40);
    }];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.equalTo(tabBarView.mas_top).offset(0);
    }];
    
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.imageView.image = self.image;
    
    CGFloat imageHeight = self.imageView.image.size.height;
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageRatio = imageHeight / imageWidth;
    
    CGFloat scrollViewHeight = self.scrollView.bounds.size.height;
    CGFloat scrollViewWidth = self.scrollView.bounds.size.width;
    CGFloat scrollViewRatio = scrollViewHeight / scrollViewWidth;

    CGFloat resizeRatio;
    if (imageRatio < scrollViewRatio) {
        resizeRatio = imageHeight / scrollViewHeight;
    } else {
        resizeRatio = imageWidth / scrollViewWidth;
    }

    CGSize newSize = CGSizeMake(imageWidth /resizeRatio, imageHeight / resizeRatio);
    CGFloat scale = [[UIScreen mainScreen] scale];
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [self.image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.imageView.frame = CGRectMake(0, 0, newSize.width, newSize.height);
    self.scrollView.contentSize = newSize;
    [self.imageView setImage:newImage];

//    CGFloat imageW = W / H * (self.view.bounds.size.height - 40);
//    self.imageW = imageW;
//    NSLog(@"%f", imageW);
    

}

//  点击下载按钮的Btn
- (void)clickDownLoadBtn {
    
    //调用方法
    [self saveImageToPhotos:self.imageView.image];
}

//  保存图片的操作
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    //因为需要知道该操作的完成情况，即保存成功与否，所以此处需要一个回调方法image:didFinishSavingWithError:contextInfo:
}

//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    BOOL succeed = false;
    if(error != NULL){
        msg = @"保存图片失败" ;
        succeed = false;
    }else{
        msg = @"保存图片成功" ;
        succeed = true;
    }
    
    
    if (succeed) {
        [self showMsg:@"保存成功" duration:1 imgName:@"Bookmark-S"];
        
        
    }else {
        [self showMsg:@"保存失败" duration:1 imgName:@"Bookmark"];
        
    }
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
//    [self showViewController:alert sender:nil];
}


//提示窗
- (void)showMsg:(NSString *)msg duration:(CGFloat)time imgName:(NSString *)imgName {
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
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


//  点击返回按钮的btn
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
