//
//  LFPlayViewController.h
//  movie
//
//  Created by li wei on 15/10/27.
//  Copyright (c) 2015年 li wei. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "MBProgressHUD.h"
#import "MoviePlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ASIHTTPRequestDelegate.h"

#import "ASINetworkQueue.h"
#import "WHC_Banner.h"
@class ASIHTTPRequest;
@interface LFPlayViewController : UIViewController<MoviePlayerViewControllerDataSource,MoviePlayerViewControllerDelegate,UIScrollViewDelegate,ASIHTTPRequestDelegate,ASIProgressDelegate,WHC_BannerDelegate>
{
    ASINetworkQueue *queue;
    ASIHTTPRequest *videoRequest;
    unsigned long long Recordull;//下载进度
    unsigned long long Toal;//文件总长度
    unsigned long long testOne;
    unsigned long long testTwo;
    float a;
    //BOOL isPlay;
    BOOL bz;
    BOOL isplay;
    NSString *filePath;//保存电影本地服务器下载地址
    NSFileHandle *outfile;
    
    MoviePlayerViewController *movieVC;//播放器对象
    UIScrollView *adscrollview;//显示广告滚动图片
    NSMutableString *URLType;//记录地址来源优酷和乐视
    NSTimer *time;
    NSString *passurl;//提交服务器播放网址
    NSString *message;//记录服务器返回状态信息
    NSString *state;//请求服务器状态
    NSTimer *timerTwo;//广告倒计时
    UILabel *timerLable;//显示广告倒计时
    UIButton *JumpBtn;//跳过广告按钮
     int number;//初始化倒计时间
    int changenumber;//跳过时间
     int times;//初始化倒计时次数
    int requestTimes;//记录请求次数
    NSTimer *timerThree;//检测是否下载暂停
    BOOL isfinish;//下载完成
    int okNumber;//记录第几个地址可以用
    float playTime;//记录播放时间
    NSMutableArray *adArray;
    WHC_Banner * banner;
}
@property (nonatomic,strong)MBProgressHUD *ProgressHUD;
@property (nonatomic,strong)NSString *movieID;//保存视频ID
@property (nonatomic,strong)NSString *movieName;//保存视频名称
@property (nonatomic,assign)int movieNumber;//保存播放的第几集
@property (nonatomic,assign)int allMovieNumber;//视频总集数
@property (nonatomic,strong)NSMutableArray *movieInfor;//保存本视频信息
@property (nonatomic,strong)NSMutableArray *movieUrls;//保存本视频所有下载地址

@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIButton *returnBtn;
@property (nonatomic,strong)UILabel *titleLable;
@end
