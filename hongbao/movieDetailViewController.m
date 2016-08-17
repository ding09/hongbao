//
//  movieDetailViewController.m
//  moneybaby
//
//  Created by 张久霞 on 15/7/15.
//  Copyright (c) 2015年 li wei. All rights reserved.
//

#import "movieDetailViewController.h"

#import "DzcDES.h"

#import <MediaPlayer/MediaPlayer.h>

#import "WHC_DownloadFileCenter.h"
#import "WHC_OffLineVideoVC.h"
#import "UIView+WHC_Toast.h"
#import "UIView+WHC_Loading.h"

#import "UIImageView+WebCache.h"
#import "DZCvideoList.h"
#import "AFHTTPSessionManager.h"
#import "LFPlayViewController.h"
@interface movieDetailViewController ()
{
    
    
}
@end

@implementation movieDetailViewController
@synthesize videoList;
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"影片详情";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    CGSize size=CGSizeMake(SCREENWIDTH, 480*2+64-SCREENHEIGHT);
    
    self.mainscrol.contentSize=size;
    self.listArray=[[NSMutableArray alloc]initWithCapacity:5];
    
    _progressHUD=[[MBProgressHUD alloc]init];
    [self.view addSubview:_progressHUD];
    [_progressHUD setLabelText:@"详情加载中"];
    [self.view addSubview:_progressHUD];
    [_progressHUD show:YES];
    self.movieName.text=videoList.AppName;
    self.navigationItem.title=videoList.AppName;
    self.movieLocation.text=[NSString stringWithFormat:@"地区：%@",videoList.AppArea];
    self.moviepeople.text=[NSString stringWithFormat:@"主演:%@",videoList.Author];
    self.movieStyle.text=[NSString stringWithFormat:@"时长（分钟）：%@",videoList.AppTime];
    self.movieScore.text=[NSString stringWithFormat:@"评分：%@",videoList.Star];
    self.movieYear.text=[NSString stringWithFormat:@"年份：%@",videoList.AppYear];
    self.movieContent.text=videoList.Content;
    [self.movieimage sd_setImageWithURL:[NSURL URLWithString:[DzcDES testUrl:videoList.ImageUrl]]];
    
    [_progressHUD hide:YES];
    // Do any additional setup after loading the view from its nib.
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




- (IBAction)moviePlayTap:(UIButton *)sender
{
    
    DLog(@"播放视频");
    LFPlayViewController *movieplayer=[[LFPlayViewController alloc]init];
    //UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:movieplayer];
    
    movieplayer.movieID=videoList.ID;
    movieplayer.movieNumber=0;
    movieplayer.movieName=videoList.AppName;
    [self presentViewController:movieplayer animated:YES completion:nil];
    
    
    
}
#pragma mark- 系统设置
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(BOOL)shouldAutorotate
{
    return NO;
}
////横屏
//- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    return (toInterfaceOrientation == UIInterfaceOrientationMaskPortrait);
//
//}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
-(void)play
{
    
        /*
    
        LFPlayViewController *movieplayer=[[LFPlayViewController alloc]init];
        //UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:movieplayer];
        
        movieplayer.movieID=self.movieID;
        movieplayer.movieNumber=0;
        movieplayer.movieName=self.movieName.text;
      */
        
    
}


- (IBAction)CacheMovie:(UIButton *)sender
{
    /*
    DZCUiapplication *dzc=[DZCUiapplication shareApplication];
    if (![dzc.linkeState isEqualToString:@"WIFI"])
    {
        DXAlertView *alert=[[DXAlertView alloc]initWithTitle:@"友情提醒" contentText:@"请在WIFI网络下进行缓存！！" leftButtonTitle:@"返回" rightButtonTitle:@"继续下载"];
        [alert show];
        alert.leftBlock=^(){
            return ;
        };
        alert.rightBlock=^(){
            [self carchMovieLoad];
        };
    }
    if ([dzc.linkeState isEqualToString:@"WIFI"])
    {
        [self carchMovieLoad];
    }
    */
   
}

#pragma mark- 电影资源缓存处理事件
-(void)carchMovieLoad
{
    /*
    //点击开始缓存
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    
    manger.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/plain"];
    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *urlstr=[NSString stringWithFormat:@"%@/API/v.asmx/getVideo",HOST];
    //=%@&=0&=url&=0&=%@
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setValue:[DzcDES jiamiString:self.movieID] forKey:@"ID"];
    [parameters setValue:@"0" forKey:@"index"];
    [parameters setValue:@"url" forKey:@"uType"];
    [parameters setValue:@"0" forKey:@"vType"];
    [parameters setValue:[DzcDES DZCTimer] forKey:@"TimeStamp"];
    [manger POST:urlstr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSStringEncoding en=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *recive=[[NSString alloc]initWithData:responseObject encoding:en];
        NSRange range=[recive rangeOfString:@"success"];
        if (range.location!=NSNotFound)//获取成功
        {
            NSDictionary *reciveDict=[DzcDES dictionaryWithJsonString:recive];
            recive=[reciveDict valueForKey:@"data"];
            recive=[DzcDES jiemiString:recive];
            reciveDict=[DzcDES dictionaryWithJsonString:recive];
            DLog(@"解密后的字典%@",reciveDict);
            NSArray *arr=[reciveDict objectForKey:@"data"];
            reciveDict=[arr firstObject];
            NSString *name=[reciveDict valueForKey:@"name"];
            arr=[reciveDict objectForKey:@"list"];
            NSString *url=[arr firstObject];//得到下载地址
            
            NSString * fileName = [NSString stringWithFormat:@"%@.mp4",name];
            
            if([WHCDownloadCenter downloadList].count < [WHCDownloadCenter maxDownloadCount]){
                [self.view startLoading];
                self.navigationController.navigationBar.userInteractionEnabled = NO;
            }else{
                [self.view toast:@"已经添加到了下载缓存"];
            }
            NSString * saveFilePath = Account.videoFolder;
            [WHCDownloadCenter startDownloadWithURL:[NSURL URLWithString:url] savePath:saveFilePath savefileName:fileName delegate:self];
            
        }
        else//获取失败
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提醒" message:@"请求缓存失败，请稍候在试" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"失败原因%@",error);
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提醒" message:@"请求缓存失败，请稍候在试" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
        return ;
        
    }];
     */
}
#pragma mark - WHCDownloadDelegate
//得到第一相应并判断要下载的文件是否已经完整下载了
- (void)WHCDownload:(WHC_Download *)download filePath:(NSString *)filePath hasACompleteDownload:(BOOL)has{
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    [self.view stopLoading];
    if(has){
        [self.view toast:@"该文件已下载请前往个人离线视频中心"];
    }else{
        [self.view toast:@"已经添加到了下载缓存"];
        NSMutableDictionary * downloadRecordDict = [NSMutableDictionary dictionaryWithContentsOfFile:Account.videoFileRecordPath];
        NSMutableDictionary * dict = downloadRecordDict[download.saveFileName];
        CGFloat  percent = (CGFloat)(download.downloadLen) / download.totalLen * 100.0;
        if(dict == nil){
            [downloadRecordDict setObject:@{@"fileName":download.saveFileName,
                                            @"currentDownloadLen":[NSString stringWithFormat:@"%.1fMB",((CGFloat)(download.downloadLen) / kWHC_1MB)],
                                            @"totalLen":[NSString stringWithFormat:@"%.1fMB",((CGFloat)(download.totalLen) / kWHC_1MB)],
                                            @"speed":@"0KB/S",
                                            @"processValue":@(percent / 100.0),
                                            @"downPath":download.downPath,
                                            @"state":@(Downloading)}.mutableCopy forKey:download.saveFileName];
            [downloadRecordDict writeToFile:Account.videoFileRecordPath atomically:YES];
        }else{
            [dict setObject:([NSString stringWithFormat:@"%.1fMB",((CGFloat)(download.downloadLen) / kWHC_1MB)]).copy forKey:@"currentDownloadLen"];
            [dict setObject:[NSString stringWithFormat:@"%.1fMB",((CGFloat)(download.totalLen) / kWHC_1MB)] forKey:@"totalLen"];
            [dict setObject:@(percent / 100.0) forKey:@"processValue"];
            [dict setObject:@(Downloading) forKey:@"state"];
            if([dict[@"downPath"] isEqualToString:@""]){
                [dict setObject:download.downPath forKey:@"downPath"];
            }
            [downloadRecordDict setObject:dict forKey:download.saveFileName];
            [downloadRecordDict writeToFile:Account.videoFileRecordPath atomically:YES];
        }
    }
}

//下载出错
- (void)WHCDownload:(WHC_Download *)download error:(NSError *)error{
    [self.view toast:[NSString stringWithFormat:@"文件:%@下载错误%@",download.saveFileName , error]];
    [self.view stopLoading];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
}

//跟新下载进度
- (void)WHCDownload:(WHC_Download *)download
     didReceivedLen:(uint64_t)receivedLen
           totalLen:(uint64_t)totalLen
       networkSpeed:(NSString *)networkSpeed{
    
}

//下载结束
- (void)WHCDownload:(WHC_Download *)download filePath:(NSString *)filePath isSuccess:(BOOL)success{
    if(success){
        [self.view toast:[NSString stringWithFormat:@"文件:%@下载成功",download.saveFileName]];
    }
    [self.view stopLoading];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
}


#pragma mark-最新电影分享后观看
#pragma mark-分享成功或失败回调事件
/*
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        DLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:self.movieID];//分享成功后加一个标志
        
    }
}
//分享事件
-(void)share:(NSDictionary *)_dict
{
    [[NSThread currentThread]main];
    
    NSString *MovieContent=[DzcDES DecodeBase64:[_dict valueForKey:@"MovieContent"]];
    NSDictionary *dict=[DzcDES dictionaryWithJsonString:MovieContent];
    NSString *title=[dict valueForKey:@"title"];
    NSString *content=[dict valueForKey:@"content"];
    NSString *shareUrl=[dict valueForKey:@"shareUrl"];
    
    title=[title stringByReplacingOccurrencesOfString:@"[NAME]" withString:[NSString stringWithFormat:@"<<%@>>",listmovie.Name]];
    
    
    NSString *autoID=[DZCUiapplication shareApplication].autoID;
    NSString *strurl;
    if (![[DZCUiapplication shareApplication].loginState isEqualToString:@"Y"]) {
        strurl=@"http://v.eeliu.cn/s/0";
    }
    else
    {
        strurl= [NSString stringWithFormat:@"http://v.eeliu.com/s/%@",autoID];
    }
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:UMWXAPPID appSecret:UMWXSECRET url:strurl];
    //#pragma mark 配置QQappkey
    [UMSocialQQHandler setQQWithAppId:UMQQAPPID appKey:UMQQAPPKEY url:strurl];
    
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
     [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialData defaultData].extConfig.qzoneData.title = title;
    [UMSocialData defaultData].extConfig.qqData.title=title;
   
    [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
    [UMSocialData defaultData].extConfig.qzoneData.url =shareUrl;
    
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMAPPKEY shareText:content shareImage:self.movieimage.image shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone,UMShareToQQ, nil] delegate:self];
    
}
 */
#pragma mark-详情评论 猜你喜欢



@end
