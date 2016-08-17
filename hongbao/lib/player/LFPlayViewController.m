//
//  LFPlayViewController.m
//  movie
//
//  Created by li wei on 15/10/27.
//  Copyright (c) 2015年 li wei. All rights reserved.
//

#import "LFPlayViewController.h"
#import "DzcDES.h"


#import "MoviePlayerViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"




#import "ASIHTTPRequest.h"
#import "DZCHandleUrl.h"

#import "DXAlertView.h"
#import "ASIDownloadCache.h"

#import "UIImageView+WebCache.h"
#import "WHC_Banner.h"
#import "WHC_DataModel.h"

#define TopViewHeight 44
@interface LFPlayViewController ()

@end

@implementation LFPlayViewController
static int loadNumber;//记录下载的是第几段
static int playNumber;//记录播放的第几段
static int urlNumber;//记录播放地址个数
-(instancetype)init
{
    self=[super init];
    if (self)
    {
        
        
       
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=YES;
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=NO;
    [time invalidate];//视图消失的时候销毁定时器
    [timerTwo invalidate];//销毁倒计时定时器
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
   
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)creatJumpBtn
{
    JumpBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-25, 0, 50, TopViewHeight)];
    
    [JumpBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [JumpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [JumpBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchDown];
    CGAffineTransform transform=CGAffineTransformMakeRotation(M_PI/2);
    [JumpBtn setTransform:transform];
    [self.view addSubview:JumpBtn];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    adArray=[[NSMutableArray alloc]initWithCapacity:1];
    okNumber=100;
    bz=NO;
    isfinish=NO;
    queue=[[ASINetworkQueue alloc]init];
    //[queue setShowAccurateProgress:YES];
    [queue go];
    URLType=[[NSMutableString alloc]initWithCapacity:10];
    self.navigationItem.title=self.movieName;
    self.view.backgroundColor=[UIColor blackColor];
    //播放倒计时
    
    number=60;
    
    times=1;
    requestTimes=0;
    [self createTopView];
   
    _ProgressHUD=[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:_ProgressHUD];
    [self.view bringSubviewToFront:_topView];
    [_ProgressHUD setLabelText:@"加载中"];
    CGAffineTransform transform=CGAffineTransformMakeRotation(M_PI/2);
    [_ProgressHUD setTransform:transform];
    [_ProgressHUD show:YES];
    /*
    NSString *adPath=[NSTemporaryDirectory() stringByAppendingPathComponent:@"ad/adrecord.data"];
    NSMutableArray *adArr=[NSMutableArray arrayWithContentsOfFile:adPath];
    if (adArr!=nil)//记录是否展示视频前广告
    {
        //
    }
     */
    
   // [self creatADimage];
    
    self.movieInfor=[[NSMutableArray alloc]initWithCapacity:10];
    self.movieUrls=[[NSMutableArray alloc]initWithCapacity:10];
    loadNumber=self.movieNumber;//初始化为下载第一段
    playNumber=0;//初始化播放第一段
    DZCUiapplication *dzc=[DZCUiapplication shareApplication];
    [[NSUserDefaults standardUserDefaults]setValue:dzc.linkeState forKey:@"Netstate"];
    //先检测手机剩余空间大小
    NSString *fileSize=[DzcDES freeDiskSpaceInBytes];
    
    if ([fileSize doubleValue]<2048.0)
    {
        [self requestMovieWithNumber:0];
        DLog(@"手机剩余%@MB,内存不足播放流畅视频",fileSize);
    }
    else
    {
        [self requestMovieWithNumber:0];
        DLog(@"内存充足，播放高清视频");
    }
    //监控 app 活动状态，打电话/锁屏 时暂停播放
    
    if (![dzc.linkeState isEqualToString:@"WIFI"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(becomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:dzc];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:dzc];
    }
    
   
}

/*
 程序活动的时候
 */

-(void)becomeActive:(DZCUiapplication *)_dzc
{
    if (isplay)//正在播放
    {
        
       
        if (!isfinish&&![_dzc.linkeState isEqualToString:@"WIFI"])//说明还没有缓存完毕
        {
             DLog(@"视屏恢复播放，程序活动了，再次启动下载");
            if (self.movieUrls.count!=0)
            {
                [self ASIQueueDownMovie];
            }
            else
            {
                DLog(@"地址丢失");
            }
            
        }
    }
}
 
/*
 程序不活动的时候
 */

-(void)resignActive:(DZCUiapplication *)_dzc
{
    if (videoRequest&&![_dzc.linkeState isEqualToString:@"WIFI"])
    {
        DLog(@"程序不活动了，暂停下载");
        
        [videoRequest clearDelegatesAndCancel];
        [queue cancelAllOperations];
        videoRequest=nil;
    }
}

-(void)requestMovieWithNumber:(int)_number
{
    
    NSString *urlstr=[NSString stringWithFormat:@"http://cache5.video.v.zhuovi.cn/API/v.asmx/getVideos?ID=%@&index=%d&uType=url&vType=%d&TimeStamp=%@", [DzcDES jiamiString:self.movieID],self.movieNumber,_number,[DzcDES DZCTimer]];
    //NSString *urlstr=[NSString stringWithFormat:@"http://192.168.0.114/API/v.asmx/getVideos?ID=%@&index=%d&uType=url&vType=%d&TimeStamp=%@", [DzcDES jiamiString:self.movieID],self.movieNumber,_number,[DzcDES DZCTimer]];
    DLog(@"---%@--%@",urlstr,self.movieID);
   __block ASIHTTPRequest *request=[DZCHandleUrl DZCHandleMovieUrl:urlstr];
    [request setTimeOutSeconds:10.0];
    [request setNumberOfTimesToRetryOnTimeout:5];
    request.tag=100;
    request.delegate=self;
    //DLog(@"%@",request.requestHeaders);
    [request setCompletionBlock:^{
        if (request.responseStatusCode==200)
        {
            [self handleMsgWithRequest:request];
            [[NSUserDefaults standardUserDefaults]setInteger:self.movieNumber-1 forKey:self.movieID];
        }
        else
        {
            requestTimes ++;
            if (requestTimes <4)
            {
                [self requestMovieWithNumber:0];
                
            }
            
        }
        
    }];
    
    [request startAsynchronous];
    videoRequest=request;
    
}
-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    DLog(@"%@",responseHeaders);
    
    NSString *LocationUrl=[responseHeaders valueForKey:@"Location"];
    
    if (LocationUrl)
    {
        [request clearDelegatesAndCancel];
        [queue cancelAllOperations];
        videoRequest=nil;
        request=nil;
        [self.movieUrls removeAllObjects];
        [self.movieUrls addObject:LocationUrl];
        return [self ASIQueueDownMovie];
    }
     
    //DLog(@"输出content－Range%@",[responseHeaders valueForKey:@"Content-Range"]);
    //DLog(@"%lld---",request.contentLength);
    /*
    NSString *contentRange=[responseHeaders valueForKey:@"Content-Range"];
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];//本地服务器地址
    webPath=[webPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber]];
    */
    //DLog(@"下载文件长度%lld",[DzcDES fileSizeAtPath:webPath]);
    if (request.tag==101)//下载视频响应头
    {
        if (request.responseStatusCode==200)
        {
            DLog(@"101下载视频响应头%@",responseHeaders);
            bz=YES;
//            NSString *str=[self.movieUrls lastObject];
//            [self.movieUrls removeAllObjects];
//            [self.movieUrls addObject:str];
            
            okNumber=urlNumber-1;//保存第几个地址可以用
            NSString *contentRange=[responseHeaders valueForKey:@"Content-Range"];
            if (contentRange==nil)//说明第一次下载，还没有断点下载
            {
                NSUserDefaults * userdefaults=[NSUserDefaults standardUserDefaults];
                //设定请求电影数据的总大小
                [userdefaults setDouble:request.contentLength  forKey:@"file_length"];
            }
            else//不是第一次下载，断点下载
            {
                NSRange range=[contentRange rangeOfString:@"/"];
                contentRange=[contentRange substringFromIndex:range.location+1];
                DLog(@"提取后的文件大小%@",contentRange);
                NSUserDefaults * userdefaults=[NSUserDefaults standardUserDefaults];
                //设定请求电影数据的总大小
                [userdefaults setDouble:[contentRange doubleValue]  forKey:@"file_length"];
            }
        }
        
        
       
        
        
        
    }
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
   
    
    if (request.tag==100)//请求视频播放地址
    {
        //[self handleMsgWithRequest:request];
    }
    if (request.tag==101)//&&request.responseStatusCode==200)
    {
        DLog(@"视频下载完成");
        isfinish=YES;
        //[NSThread sleepForTimeInterval:60.0];//休眠60秒等待拷贝完成
        NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];//视频保存地址
        NSString *TemplePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];//视频缓存地址
        NSString *cacheName=[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber]];
        NSString *templeName=[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber]];
        while (1)
        {
            if (![[NSFileManager defaultManager]fileExistsAtPath:[TemplePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber]]]&&[[NSFileManager defaultManager]fileExistsAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber]]]&&[DzcDES fileSizeAtPath:cacheName]<6000000)
            {
                [self ASIQueueDownMovie];
                break;
            }
            if (![[NSFileManager defaultManager]fileExistsAtPath:[TemplePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber]]]&&[[NSFileManager defaultManager]fileExistsAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber]]])
            {
                [movieVC returnRecord];//保存播放记录
                movieVC.isFirstOpenPlayer=NO;
                [movieVC.player.currentItem removeObserver:movieVC forKeyPath:@"status"];
                [movieVC.player.currentItem removeObserver:movieVC forKeyPath:@"playbackBufferEmpty"];
                [movieVC.player.currentItem removeObserver:movieVC forKeyPath:@"playbackLikelyToKeepUp"];
                
                [movieVC.player.currentItem removeObserver:movieVC forKeyPath:@"loadedTimeRanges"];
                
                AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber]]]];
                
                [movieVC.player replaceCurrentItemWithPlayerItem:playerItem];
                
                [movieVC.player.currentItem addObserver:movieVC forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];//重新添加观察者
                
                [movieVC.player.currentItem addObserver:movieVC forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
                [movieVC.player.currentItem addObserver:movieVC forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
                [movieVC.player.currentItem addObserver:movieVC forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
                DLog(@"替换当前播放资源");
                break;
            }
        }
        
        
        
        
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    DLog(@"请求失败%@",[request error]);
    if ([request error]&&request.tag==100)
    {
        DZCUiapplication *dzc=[DZCUiapplication shareApplication];
        NSString *strurl=[NSString stringWithFormat:@"http://%@/API/v.asmx/sendEmail?url=%@&Message=%@&ReceiveEmail=%@&TimeStamp=%@",dzc.Requesthost,[DzcDES jiamiString:[NSString stringWithFormat:@"%@",request.url]],[DzcDES jiamiString:[request.error description]],[DzcDES jiamiString:@"651735823@qq.com"],[DzcDES DZCTimer]];
        ASIHTTPRequest *req=[DZCHandleUrl DZChandleUrl:strurl];
        [req setTimeOutSeconds:10.0];
        [req setNumberOfTimesToRetryOnTimeout:5];
        [req startAsynchronous];
       // UIView *view=[UIView alloc]initWithFrame:CGRectMake(SCREENHEIGHT-, <#CGFloat y#>, 100, 200);
    }
    if([request error]&&request.tag==101)//下载视频出错
    {
        [request clearDelegatesAndCancel];
        [queue cancelAllOperations];
        //[videoRequest clearDelegatesAndCancel];
        videoRequest=nil;
        request=nil;
        DZCUiapplication *dzc=[DZCUiapplication shareApplication];
        NSString *strurl=[NSString stringWithFormat:@"http://%@/API/v.asmx/sendEmail?url=%@&Message=%@&ReceiveEmail=%@&TimeStamp=%@",dzc.Requesthost,[DzcDES jiamiString:[NSString stringWithFormat:@"%@",request.url]],[DzcDES jiamiString:[NSString stringWithFormat:@"下载视频出错%@%@",[request.error description],[self.movieUrls lastObject]]],[DzcDES jiamiString:@"651735823@qq.com"],[DzcDES DZCTimer]];
        ASIHTTPRequest *req=[DZCHandleUrl DZChandleUrl:strurl];
        [req setTimeOutSeconds:10.0];
        [req setNumberOfTimesToRetryOnTimeout:5];
        [req startAsynchronous];
        if (self.movieUrls.count>1&&bz==NO)
        {
            DLog(@"移除最后一个地址");
            [self.movieUrls removeLastObject];
            DLog(@"播放地址%@",[self.movieUrls lastObject]);
        }
        [self ASIQueueDownMovie];
    }
}

//使用队列下载电影资源
-(void)ASIQueueDownMovie
{
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];//本地服务器地址
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];//视频缓存地址
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:cachePath])
    {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if ([DzcDES fileSizeAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber]]]<1000000)
    {
        [fileManager removeItemAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber]] error:nil];
    }
    if ([fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber]]]) {
        movieVC=[[MoviePlayerViewController alloc]initLocalMoviePlayerViewControllerWithURL:[NSURL fileURLWithPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber]]] movieTitle:self.movieName];
        movieVC.delegate=self;
        movieVC.datasource=self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:movieVC animated:YES completion:nil];
        });
        videoRequest = nil;
    }
    else
    {
        NSString *movieurl;
        
        
        /*
        if (urlNumber < self.movieUrls.count)
        {
            if(okNumber==100)
            {
                movieurl=[self.movieUrls objectAtIndex:urlNumber];
                urlNumber++;
            }
            else
            {
                movieurl=[self.movieUrls objectAtIndex:okNumber];
            }
            
        }
        
        else
        {
            movieurl=[self.movieUrls lastObject];
            urlNumber=0;
        }
         */
        movieurl = [self.movieUrls lastObject];
        //[DZCUiapplication shareApplication].host=@"124.160.194.72";
        //[DZCUiapplication shareApplication].port=@"80";
        ASIHTTPRequest *request=[DZCHandleUrl DZChandleUrl:movieurl];
        DLog(@"请求header－－－%@修改后地址----%@",request.requestHeaders,request.url);
        request.tag=101;
        request.delegate=self;
        request.downloadProgressDelegate = self;
        //下载完存储目录
        [request setDownloadDestinationPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber]]];
        //临时存储目录
       
        [request setTemporaryFileDownloadPath:[webPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber]]];
        //[request setSecondsToCache:60*60*24];
        //[request setSecondsToCache:60];
        [request setAllowResumeForFileDownloads:YES];
        [request setTimeOutSeconds:10.0];
        
        [queue addOperation:request];
        videoRequest=request;
       
        //}
    }
}

-(void)setProgress:(float)newProgress
{
    //a+=newProgress;
    //DLog(@"下载进度%f",newProgress);
    
}

- (void)playVideo{
    
    [time invalidate];//视图消失的时候销毁定时器
    [timerTwo invalidate];//销毁倒计时定时器
     NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];//本地服务器地址
     webPath=[webPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber]];
     NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];//视频缓存地址
     cachePath=[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber]];
    NSString *name;
    if (self.movieNumber==0)
    {
        name=[NSString stringWithFormat:@"%@",self.movieName];
    }
    else
    {
        name=[NSString stringWithFormat:@"%@第%d集",self.movieName,self.movieNumber];
    }
    
    
      if ([[NSFileManager defaultManager]fileExistsAtPath:webPath])
     {
         isplay=YES;
    
    
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1:12224/%@%d.mp4",self.movieID,self.movieNumber ]];
        DLog(@"播放地址%@",url);
         dispatch_async(dispatch_get_main_queue(), ^{
             movieVC =[[MoviePlayerViewController alloc]initLocalMoviePlayerViewControllerWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1:12224/%@%d.mp4",self.movieID,self.movieNumber ]] movieTitle:name];
             movieVC.delegate=self;
             movieVC.datasource=self;
         
    [self presentViewController:movieVC animated:YES completion:nil];
         });
     }
    else
    {
        DXAlertView *alert=[[DXAlertView alloc]initWithTitle:@"友情提示" contentText:@"加载失败，请返回重新播放" leftButtonTitle:@"好的" rightButtonTitle:@"返回"];
        alert.leftBlock=^
        {
            [self popView];
        };
        alert.rightBlock=^{
            [self popView];
        };
        [alert show];
    }
    /*
     if ([[NSFileManager defaultManager]fileExistsAtPath:cachePath]&&![[NSFileManager defaultManager]fileExistsAtPath:webPath])
     {
     
     dispatch_async(dispatch_get_main_queue(), ^{
     movieVC=[[MoviePlayerViewController alloc]initLocalMoviePlayerViewControllerWithURL:[NSURL fileURLWithPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber]]] movieTitle:name];
     movieVC.delegate=self;
     movieVC.datasource=self;
     [self presentViewController:movieVC animated:NO completion:nil];
     });
     
     }
     */
    
}

- (void)videoFinished{
    if (videoRequest) {
        isplay = !isplay;
        [videoRequest clearDelegatesAndCancel];
        videoRequest = nil;
    }
}
-(void)popView
{
    //[DZCUiapplication shareApplication].host=@"124.160.194.71";
    //[DZCUiapplication shareApplication].port=@"80";
    if ([state isEqualToString:@"success"])
    {
        NSString *str=[NSString stringWithFormat:@"%f",playTime];
        NSMutableArray *arr=[NSMutableArray array];
        [arr addObject:str ];
        [arr addObject:@"1"];
        [self performSelectorInBackground:@selector(AddPlayLogandstate:) withObject:arr];
        
        
    }
    else
    {
        NSString *str=[NSString stringWithFormat:@"%f",playTime];
        NSMutableArray *arr=[NSMutableArray array];
        [arr addObject:str ];
        [arr addObject:@"0"];
        [self performSelectorInBackground:@selector(AddPlayLogandstate:) withObject:arr];
        
    }
    [self videoFinished];
    [movieVC.player pause];
    movieVC=nil;
    [time invalidate];//视图消失的时候销毁定时器
    [timerTwo invalidate];//销毁倒计时定时器
    [self dismissViewControllerAnimated:YES completion:nil];
}
//WIFI情况下使用播放方式
-(void)playMovie
{
    NSString *str=[self.movieUrls lastObject];
    //str= [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[[NSURL alloc]initWithString:str];//修改一下
    NSString *name;
    if (self.movieNumber==0)
    {
        name=[NSString stringWithFormat:@"%@",self.movieName];
    }
    else
    {
        name=[NSString stringWithFormat:@"%@第%d集",self.movieName,self.movieNumber];
    }
   
    dispatch_async(dispatch_get_main_queue(), ^{
        [time invalidate];//视图消失的时候销毁定时器
        [timerTwo invalidate];//销毁倒计时定时器
        movieVC = [[MoviePlayerViewController alloc]initLocalMoviePlayerViewControllerWithURL:url movieTitle:name];
        movieVC.urlList=self.movieUrls;
        movieVC.datasource = self;
        movieVC.delegate=self;
    [self presentViewController:movieVC animated:NO completion:nil];

    });
}
//视频返回回调事件
-(void)movieFinished:(CGFloat)progress
{
    DLog(@"返回事件");
    [self videoFinished];
    playTime=progress;
    //[playreturnBtn removeFromSuperview];
    
    if (progress <0.9)
    {
        [self popView];
    }
    else if (progress-0.9>0&&progress-1<0)//如果播放超过百分之90就把这个文件删除
    {
        NSString *filename=[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber];
        [self CleanMovieFile:filename];
         [self popView];
    }
   else if (progress == 1.0)
    {
        NSString *filename=[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber];
        [self CleanMovieFile:filename];
        loadNumber ++;
        self.movieNumber=loadNumber;
        //先检测手机剩余空间大小
        NSString *fileSize=[DzcDES freeDiskSpaceInBytes];
        
        if ([fileSize doubleValue]<2048.0)
        {
            if (self.allMovieNumber >= self.movieNumber)
            {
                 [self requestMovieWithNumber:0];
            }
           else
           {
               [self popView];
           }
            DLog(@"手机剩余%@MB,内存不足播放流畅视频",fileSize);
        }
        else
        {
            if (self.allMovieNumber >= self.movieNumber)
            {
                [self requestMovieWithNumber:2];
            }
            else
            {
                [self popView];
            }
            DLog(@"内存充足，播放高清视频");
        }
        
    }
    //[self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)CleanMovieFile:(NSString *)_fileName//清理电影缓存
{
    NSString * MOVIEPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
    MOVIEPath=[MOVIEPath stringByAppendingPathComponent:_fileName];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    //判断一下当前电影是否下载完毕
//    if (![CurrentProgress isEqualToString:toalProgress])//没有下载完毕
//    {
        NSError *error;
        [fileManager removeItemAtPath:MOVIEPath error:&error];
        DLog(@"观看超过0.9删除这部电影%@",error);
//    }
//    else//下载完毕
//    {
//        DLog(@"下载完毕电影暂时不删除");
//        [self SaveMovieFile:_fileName];//下载完毕将名称保存到数据库
//        
//    }
    
    
    
}
#pragma mark-删除保存电影如果保存超过三部
/*
-(void)DeleteMovieFile:(NSString *)_fileName
{
    //NSString *imgename=[NSString stringWithFormat:@"movie/%@.jpg",self.movieID];
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase *db=app.db;
    FMResultSet *rs=[db executeQuery:@"select * from record"];
    [rs next];
    DZCmovieinfor *movie=[[DZCmovieinfor alloc]init];
    movie.Name=[rs stringForColumn:@"idid"];
    
    NSString * MOVIEPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    NSFileManager *fileManger=[NSFileManager defaultManager];
    NSError *error;
    [fileManger removeItemAtPath:[MOVIEPath stringByAppendingPathComponent:movie.Name] error:&error];
    DLog(@"保存的完整电影查过三部删除最早保存的一部%@",error);
    
}
-(void)SaveMovieFile:(NSString *)_fileName
{
    //NSString *imgename=[NSString stringWithFormat:@"movie/%@.jpg",self.movieID];
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase *db=app.db;
    // 判断是否已经收藏
    
    NSString * sql=[NSString stringWithFormat:@"select count(*) as rows from record where idid='%@'",_fileName];
    FMResultSet * rs= [db executeQuery:sql];
    [rs next];
    int recount=[rs intForColumn:@"rows"];
    if(recount>0)//这条记录已经保存过了
    {
        DLog(@"这条记录保存过了");
    }
    else
    {
        
        BOOL b=[db executeUpdate:@"insert into record(idid)values(?)",
                _fileName];
        if (!b)
        {
            DLog(@"记录本地播放记录失败");
        }
    }
    NSString *sqltwo=@"select count(*) as rows from record";
    FMResultSet *rscount=[db executeQuery:sqltwo];
    [rscount next];
    int recountNumber=[rscount intForColumn:@"rows"];
    if (recountNumber >3)
    {
        [self DeleteMovieFile:nil];
    }
    DLog(@"保存了几条数据%d",recountNumber);
}
 */
#pragma mark－播放器代理事件
- (BOOL)isHavePreviousMovie{
    return NO;
}
- (BOOL)isHaveNextMovie{
    //有改动默认为NO
    return NO;
}
- (NSDictionary *)previousMovieURLAndTitleToTheCurrentMovie{
   // NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSURL URLWithString:@"http://127.0.0.1:12222/v.mp4"],KURLOfMovieDicTionary,@"qqqqqqq",KTitleOfMovieDictionary, nil];
    return nil;
}

- (NSDictionary *)nextMovieURLAndTitleToTheCurrentMovie{
   // NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSURL URLWithString:@"http://127.0.0.1:12222/v.mp4"],KURLOfMovieDicTionary,@"qqqqqqq",KTitleOfMovieDictionary, nil];
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

#pragma mark - 系统相关
////隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}
-(BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

////横屏
//- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
//}
//- (NSUInteger)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscapeRight;
//}
- (void)createTopView
{
    CGFloat titleLableWidth = 400;
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, TopViewHeight)];
    _topView.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    _returnBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, TopViewHeight)];
    [_returnBtn setTitle:@"返回" forState:UIControlStateNormal];
    [_returnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[_returnBtn setTitleColor:[UIColor colorWithRed:0.01f green:0.48f blue:0.98f alpha:1.00f] forState:UIControlStateNormal];
    [_returnBtn addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_returnBtn];
    
    timerLable=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.height-100, 0, 100, TopViewHeight)];//创建显示广告倒计时标签
    [_topView addSubview:timerLable];
    timerTwo=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(adcountDown) userInfo:nil repeats:YES];
    
    _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.height/2-titleLableWidth/2, 0, titleLableWidth, TopViewHeight)];
    _titleLable.backgroundColor = [UIColor clearColor];
    _titleLable.text = self.movieName;
    _titleLable.textColor = [UIColor whiteColor];
    _titleLable.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_titleLable];
    CGAffineTransform transform=CGAffineTransformMakeRotation(M_PI/2);
    [_topView setTransform:transform];
    [_topView setTranslatesAutoresizingMaskIntoConstraints:NO];
    CGPoint point=CGPointMake(SCREENWIDTH-TopViewHeight/2, SCREENHEIGHT/2);
    [_topView setCenter:point];
    [self.view addSubview:_topView];
    
}
//广告倒计时事件

-(void)adcountDown
{
    //NSDictionary *dict=[DZCAppConfig shareApplication].AD;
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];//本地服务器地址
    webPath=[webPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.mp4",self.movieID,self.movieNumber]];
    timerLable.textColor=[UIColor whiteColor];
    timerLable.font=[UIFont systemFontOfSize:13];
    timerLable.text=[NSString stringWithFormat:@"播放倒计时:%d秒",number];
    
    //vip用户跳过广告
    DZCUiapplication *dzc=[DZCUiapplication shareApplication];
    if ([dzc.isVIP isEqualToString:@"1"]&&[dzc.linkeState isEqualToString:@"WIFI"])
    {
        timerLable.hidden=YES;
        if (self.movieUrls.count!=0)
        {
            [self playMovie];
        }
        
        

    }
    if ([dzc.isVIP isEqualToString:@"1"]&&![dzc.linkeState isEqualToString:@"WIFI"])
    {
        
        if (!isplay &&[DzcDES fileSizeAtPath:webPath]>6000000&&number==changenumber)
        {
            
            [self creatJumpBtn];
            
            
        }
        
        else if (!isplay &&[DzcDES fileSizeAtPath:webPath]>6000000)
        {
            if (JumpBtn==nil)
            {
                [self creatJumpBtn];
            }
        }
        
        /*
        else if (!isplay &&[DzcDES fileSizeAtPath:webPath]<6000000&& number==20)
        {
            [self videoFinished];
            isplay = NO;
            [self ASIQueueDownMovie];
        }
         */
        
    }
    number--;
    if (number==0)//第一次倒计时结束
    {
        
        DZCUiapplication *dzc=[DZCUiapplication shareApplication];
        if (![dzc.linkeState isEqualToString:@"WIFI"])//不是无限网络状况
        {
            
            
            if (!isplay &&[DzcDES fileSizeAtPath:webPath]>6000000)
            {
                [_ProgressHUD hide:YES];
                isplay=!isplay;
                [timerTwo invalidate];//销毁定时器
                [self playVideo];
                
                
            }
            if (!isplay &&[DzcDES fileSizeAtPath:webPath]<6000000)
            {
                
//                [self videoFinished];
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"抱歉！网络状况暂时不佳，请稍候在观看" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//                    [alert show];
//                    
//                    [timerTwo invalidate];
//                    return;
                //[timerTwo invalidate];
                timerLable.hidden=YES;
                [banner removeFromSuperview];
                number=30;
                unsigned long byte = [ASIHTTPRequest averageBandwidthUsedPerSecond];
                DLog(@"下载速度%ldkb/s",byte/1024);
                [_ProgressHUD setLabelText:[NSString stringWithFormat:@"%ldkb/s",byte/1024]];
                //[NSThread detachNewThreadSelector:@selector(testMovieFile:) toTarget:self withObject:webPath];
                /*
                while (1)
                {
                    if (!isplay &&[DzcDES fileSizeAtPath:webPath]>6000000)
                    {
                        [self playVideo];
                        break;
                    }
                }
                 */
                
                
            }
            
        }
        else//如果是无线网直接播放不走代理
        {
            if (self.movieUrls.count !=0)
            {
                [timerTwo invalidate];//销毁倒计时定时器
                [NSThread detachNewThreadSelector:@selector(playMovie) toTarget:self withObject:nil];
            }
            
            
        }
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[_ProgressHUD removeFromSuperview];
}
#pragma mark- 创建广告图片
/*
-(void)creatADimage
{
    
    DZCUiapplication *dzc=[DZCUiapplication shareApplication];
    
    NSString *strurl=[NSString stringWithFormat:@"http://%@/API/v.asmx/getAD?aID=%@&TimeStamp=%@",dzc.Requesthost,[DzcDES jiamiString:@"23"],[DzcDES DZCTimer]];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    strurl = [strurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:strurl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"框架请求地址%@--",strurl);
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[dict objectForKey:@"state"] isEqualToString:@"success"])
        {
            
            NSString *dd=[dict objectForKey:@"data"];
            dd=[DzcDES jiemiString:dd];
           DZCAdInfor *dzcad= [WHC_DataModel dataModelWithJson:dd className:[DZCAdInfor class]];
            
            
            for(AD *dzca in dzcad.AD)
            {
                NSString *str=[NSString stringWithFormat:@"%@%@",HOST,dzca.ImageUrl];
                [adArray addObject:str];
            }
            DLog(@"广告数组%@",adArray);
            CGRect rect=self.view.bounds;
            banner =[[WHC_Banner alloc]initWithFrame:CGRectMake(0, 0, rect.size.height-80, rect.size.width-80)];
            [banner setCenter:CGPointMake(rect.size.width/2, rect.size.height/2)];
            CGAffineTransform transform=CGAffineTransformMakeRotation(M_PI/2);
            [banner setTransform:transform];
            banner.delegate=self;
            banner.backgroundColor=[UIColor clearColor];
            banner.pageIndicatorTintColor = [UIColor whiteColor];
            banner.currentPageIndicatorTintColor = [UIColor blackColor];
            banner.imageUrls=adArray;
            [banner startBanner];
            [self.view addSubview:banner];
            
        }
        else
        {
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
   
}


    
    

-(NSMutableArray *)handleADMsg:(NSString *)_data
{
    NSString *msgstr=_data;
    NSDictionary *datadict=[NSDictionary dictionary];
    datadict=[DzcDES dictionaryWithJsonString:msgstr];
    msgstr=[datadict valueForKey:@"data"];
    msgstr=[DzcDES jiemiString:msgstr];
    datadict=[DzcDES dictionaryWithJsonString:msgstr];
    DLog(@"广告信息返回%@",datadict);
    NSArray *ADarr=[datadict objectForKey:@"AD"];
    NSMutableArray *ad=[[NSMutableArray alloc]initWithCapacity:5];
    for(NSDictionary *dic in ADarr)
    {
        DZCAdInfor *dzcAD=[[DZCAdInfor alloc]init];
//        dzcAD.AgentName=[dic valueForKey:@"AgentName"];
//        dzcAD.ComID=[dic valueForKey:@"ComID"];
//        dzcAD.ComName=[dic valueForKey:@"ComName"];
//        dzcAD.ExpireDate=[dic valueForKey:@"ExpireDate"];
//        dzcAD.ID=[dic valueForKey:@"ID"];
//        dzcAD.ImageUrl=[dic valueForKey:@"ImageUrl"];
//        dzcAD.LinkUrl=[dic valueForKey:@"LinkUrl"];
//        dzcAD.Name=[dic valueForKey:@"Name"];
//        dzcAD.Score=[dic valueForKey:@"Score"];
//        [ad addObject:dzcAD];
    }
    return ad;
    //[NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:imageUrlArray];//开始加载广告图片
    //[_progressHUD show:YES];
}


-(void)savePlayRecord
{
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
   FMDatabase * db=app.db;
    NSString *sql=[NSString stringWithFormat:@"update record set 'range'=%llu where idid='%@'",Recordull,self.movieID];
    BOOL b=[db executeUpdate:sql];
    if (!b)
    {
        DLog(@"更新下载进度失败");
    }
    
}
 */
#pragma mark-上传播放记录到服务器
-(void)AddPlayLogandstate:(NSMutableArray *)_arr

{
    DZCUiapplication *dzc=[DZCUiapplication shareApplication];
    message=[message stringByAppendingFormat:@"手机型号%@联网状态%@,运营商名称%@,播放时长%f,播放地址%@,代理IP%@,请求节点%@,倒计时%d",[DzcDES getUserPhoneVersion],dzc.linkeState,dzc.carrierName,playTime,[self.movieUrls lastObject],dzc.host,dzc.Requesthost,number];
//    
//    NSString *strEmailurl=[NSString stringWithFormat:@"http://%@/API/v.asmx/sendEmail?url=%@&Message=%@&ReceiveEmail=%@&TimeStamp=%@",dzc.Requesthost,[DzcDES jiamiString:[NSString stringWithFormat:@"%@",[self.movieUrls lastObject]]],[DzcDES jiamiString:[NSString stringWithFormat:@"下载视频出错%@%@",message,[self.movieUrls lastObject]]],[DzcDES jiamiString:@"651735823@qq.com"],[DzcDES DZCTimer]];
//    ASIHTTPRequest *req=[DZCHandleUrl DZChandleUrl:strEmailurl];
//    [req setTimeOutSeconds:10.0];
//    [req setNumberOfTimesToRetryOnTimeout:5];
//    [req startAsynchronous];
    
    NSString *strurl=[NSString stringWithFormat:@"http://%@/API/v.asmx/AddPlayLogs",dzc.Requesthost];
    //AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    AFHTTPSessionManager *manger=[AFHTTPSessionManager manager];
    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    manger.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/plain"];
    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    //uID=string&vID=string&vUrl=string&PlayTime=string&Model=string&State=string&TimeStamp=string
    [parameters setValue:[DzcDES jiamiString:dzc.ID] forKey:@"uID"];
    [parameters setValue:[DzcDES jiamiString:self.movieID] forKey:@"vID"];
    [parameters setValue:[DzcDES jiamiString:passurl] forKey:@"vUrl"];
    [parameters setValue:[DzcDES jiamiString:[_arr firstObject]] forKey:@"PlayTime"];
    DLog(@"===%@",[_arr firstObject]);
    NSInteger playNumber=[[NSUserDefaults standardUserDefaults]integerForKey:self.movieID];
    NSString *numberIndex=[NSString stringWithFormat:@"%d",(int)playNumber+1];
    [parameters setValue:[DzcDES jiamiString:numberIndex] forKey:@"PlayIndex"];
    NSString *str=[NSString stringWithFormat:@"%@%@%@:%@",dzc.carrierName,dzc.linkeState,dzc.host,dzc.port];
    [parameters setValue:[DzcDES jiamiString:str] forKey:@"Model"];
    [parameters setValue:[DzcDES jiamiString:[_arr lastObject]] forKey:@"State"];
    
    [parameters setValue:[DzcDES jiamiString:message] forKey:@"Message"];
    [parameters setValue:[DzcDES DZCTimer] forKey:@"TimeStamp"];
    
    
    [manger POST:strurl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress){
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSStringEncoding en=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *recive=[[NSString alloc]initWithData:responseObject encoding:en];
        DLog(@"添加记录成功%@%@",recive,parameters);
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求出错
        
    }];
}
//处理请求出来的视频地址
-(void)handleMsgWithRequest:(ASIHTTPRequest *)request
{
    NSString *requsetString=[request responseString];
    DLog(@"----%@",requsetString);
    NSRange range=[requsetString rangeOfString:@"error"];
    if (range.location!=NSNotFound)
    {
        DXAlertView *alert=[[DXAlertView alloc]initWithTitle:@"友情提示" contentText:@"sorry！当前视频比较忙，请稍后进行观看" leftButtonTitle:@"返回" rightButtonTitle:@"好的"];
        
        [alert show];
        CGAffineTransform transform=CGAffineTransformMakeRotation(M_PI/2);
        [alert setTransform:transform];
        alert.leftBlock=^{
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        alert.rightBlock=^{
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        return;
    }
    DLog(@"输出服务器返回的数据%@",requsetString);
    NSDictionary *datadict=[NSDictionary dictionary];
    datadict=[DzcDES dictionaryWithJsonString:requsetString];
    message=[datadict valueForKey:@"msg"];//记录解析服务器返回状态
    NSString *state=[datadict valueForKey:@"state"];
    if ([state isEqualToString:@"error"])
    {
        DZCUiapplication *dzc=[DZCUiapplication shareApplication];
        int a=(int)dzc.requestHosts.count;
        int num=arc4random()%a+1;
        dzc.Requesthost=dzc.requestHosts[num-1];
        DLog(@"视频集数不合法在次请求%@----%@",dzc.requestHosts,dzc.Requesthost);
        return [self requestMovieWithNumber:0];
    }
    message = [message stringByAppendingFormat:@"剩余存储空间%@",[DzcDES freeDiskSpaceInBytes]];
    state=[datadict valueForKey:@"state"];//
    requsetString=[datadict valueForKey:@"data"];
    requsetString=[DzcDES jiemiString:requsetString];
    DLog(@"解密后的视频地址%@",requsetString);
    datadict=[DzcDES dictionaryWithJsonString:requsetString];
    NSArray *arr=[datadict objectForKey:@"data"];
    NSDictionary *dict=[arr firstObject];
    URLType=[dict valueForKey:@"from"];//记录视频来源
    [URLType stringByAppendingFormat:@",%@",URLType];
    DLog(@"视频来源%@",URLType);
    passurl=[dict valueForKey:@"url"];//记录上传服务器播放网址
    NSArray *urlArr=[dict objectForKey:@"list"];
    [self.movieUrls addObjectsFromArray:urlArr];
    DZCUiapplication *dzc=[DZCUiapplication shareApplication];
    DLog(@"000提取视频播放地址----%@",self.movieUrls);
    if (![dzc.linkeState isEqualToString:@"WIFI"])//不是WIFI
    {
        //测试
        //[NSThread detachNewThreadSelector:@selector(ASILoadMovie) toTarget:self withObject:nil];
        //[NSThread detachNewThreadSelector:@selector(DownLoad) toTarget:self withObject:nil];
        
        [NSThread detachNewThreadSelector:@selector(ASIQueueDownMovie) toTarget:self withObject:nil];
    }
    
    else//是WIFI
    {
        
        
        //[NSThread detachNewThreadSelector:@selector(playMovie) toTarget:self withObject:nil];
        [self playMovie];
        //测试
        //[NSThread detachNewThreadSelector:@selector(DownLoad) toTarget:self withObject:nil];
        
    }
}
-(void)testMovieFile:(NSString *)_webpath
{
    while (1)
    {
        if (!isplay &&[DzcDES fileSizeAtPath:_webpath]>6000000)
        {
            isplay=YES;
            [self playVideo];
            break;
        }
        if (isplay==YES)
        {
            break;
        }
        DLog(@"测试线程");
        [NSThread sleepForTimeInterval:2.0];
        
    }
    
}
-(void)playLocationMovie
{
    
}
-(void)WHC_Banner:(WHC_Banner *)banner clickImageView:(UIImageView *)imageView index:(NSInteger)index
{
    
}
-(void)WHC_Banner:(WHC_Banner *)banner networkLoadingWithImageView:(UIImageView *)imageView imageUrl:(NSString *)url index:(NSInteger)index
{
    NSString *str=[adArray objectAtIndex:index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"00100"]];
}
@end
