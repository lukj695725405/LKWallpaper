//
//  LKAboutViewController.m
//  LKWallpaper
//
//  Created by Lukj on 2017/5/21.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import "LKAboutViewController.h"
#import "LKAboutViewLabCell.h"
#import "LKAboutHeadView.h"
#import "LKAboutViewBtnCell.h"
#import "WXApi.h"
@interface LKAboutViewController ()<UITableViewDataSource>
@property (nonatomic, strong) NSArray *labelArray;
@property (nonatomic, strong) NSArray *btnArray;

@end

const CGFloat standard = 50;

//static NSString *kLinkURL = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
static NSString *kLinkTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
static NSString *kLinkTitle = @"360Wp：图片之家";
static NSString *kLinkDescription = @"360WP 是一款简单的壁纸App，由人工无版权图片网站 Unsplash 精挑细选。好看的图片太多，但好看不代表合适用作壁纸，360WP 只挑选择真正适合设为壁纸的图片。";

@implementation LKAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}


- (void)setupUI {
    
    
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor blackColor];
    
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 50;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [tableView registerClass:[LKAboutViewLabCell class] forCellReuseIdentifier:@"aboutCell"];
    [tableView registerClass:[LKAboutViewBtnCell class] forCellReuseIdentifier:@"aboutBtnCell"];
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    UIView *headView = [[UIView alloc] init];
    
    LKAboutHeadView *aboutHeadView = [[LKAboutHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 250)];
    headView.frame = CGRectMake(0, 0, 0, CGRectGetMaxY(aboutHeadView.frame));
    [headView addSubview:aboutHeadView];
    
    tableView.tableHeaderView = headView;
    
    NSString *firstStr = @"360WP 是一款简单的壁纸App，由人工无版权图片网站 Unsplash 精挑细选。好看的图片太多，但好看不代表合适用作壁纸，360WP 只挑选择真正适合设为壁纸的图片。";
    NSString *secondStr = @"360WP 无需更新App本身，当你偶尔想换壁纸的时，360WP 能帮你更快找到最好看且适合的一张。";
    NSString *thirdStr = @"你不用担心 360WP 占用过多的存储空间，我们设置了定期删除缓存，在超过一个星期会自动清理缓存。";
    
    self.labelArray = @[firstStr, secondStr, thirdStr];
    
    NSString *firstBtnStr = @"分享给朋友";
    self.btnArray = @[firstBtnStr];
   
    
    
    
//    [sharedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(thirdLable.mas_bottom).offset(100);
//        make.left.offset(standard);
//        make.right.offset(-standard);
//    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return self.labelArray.count;
    }else {
        
        return self.btnArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        LKAboutViewLabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor blackColor];
        cell.label.text = self.labelArray[indexPath.row];
        
        return cell;
    }else {
        
        LKAboutViewBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutBtnCell" forIndexPath:indexPath];
        UIButton *shareBtn = [cell viewWithTag:20];
        [shareBtn addTarget:self action:@selector(sharedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.backgroundColor = [UIColor blackColor];
        [cell.button setTitle:self.btnArray[indexPath.row] forState:UIControlStateNormal];
//
        return cell;
    }
}

//  分享下载地址
- (void)sharedBtnAction:(UIButton *)sender {
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = kLinkTitle;
    message.description = kLinkDescription;
    [message setThumbImage:[UIImage imageNamed:@"Icon"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/360高清壁纸/id1244378418?l=zh&ls=1&mt=8"];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
