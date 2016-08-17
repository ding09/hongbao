//
//  AppDelegate.m
//  hongbao
//
//  Created by li wei on 16/8/4.
//  Copyright © 2016年 li wei. All rights reserved.
//

#import "AppDelegate.h"
#import "JOYConnect.h"
#import "DZCHelp.h"
#import "ASIHTTPRequest.h"
#import "DzcDES.h"
#import "DZCUiapplication.h"
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
//开启服务
- (void)startServer
{
    // Start the server (and check for problems)
    
    NSError *error;
    if([httpServer start:&error])
    {
        DLog(@"Started HTTP Server on port %hu", [httpServer listeningPort]);
    }
    else
    {
        DLog(@"Error starting HTTP Server: %@", error);
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [JOYConnect getConnect:@"822cd6ccb534bf1db0a50cd2a3586939" pid:nil userID:nil];
    [JOYConnect sharedJOYConnect].delegate=self;
    [DZCHelp DZCsetUINavigationBarBackGroundImage:nil withImageName:@"nav_bg"];
    [DZCHelp DZCsetUINavigationBarTitleFountSize:20];
    // 检测应用网络状态发生变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    hostReach =[Reachability reachabilityWithHostName:@"www.baidu.com"] ;//可以以多种形式初始化
    [hostReach startNotifier]; //开始监听,会启动一个run loop
    [self updateInterfaceWithReachability: hostReach];
    NSString *url=[NSString stringWithFormat:@"http://api.v.zhuovi.net/API/v.asmx/getXHost?Count=1&Type=中国联通&TimeStamp=%@",[DzcDES DZCTimer]];
   __block ASIHTTPRequest *request=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [request setCompletionBlock:^{
        if (request.responseStatusCode==200)
        {
            NSString *recivestr=[request responseString];
            NSDictionary *dict=[DzcDES dictionaryWithJsonString:recivestr];
            recivestr=[dict valueForKey:@"data"];
            recivestr=[DzcDES jiemiString:recivestr];
            dict=[DzcDES dictionaryWithJsonString:recivestr];
            DLog(@"---%@－－－%@",dict,recivestr);
            NSArray *arr=[dict objectForKey:@"data"];
            
            NSMutableArray *hostArray=[[NSMutableArray alloc]initWithCapacity:10];
            NSString *carrierName=[DZCUiapplication shareApplication].carrierName;
            for(NSDictionary *dic in arr)
            {
                
                if ([carrierName isEqualToString:[dic valueForKey:@"type"]]) {
                    [DZCUiapplication shareApplication].firstline=[dic valueForKey:@"firstline"];
                    [DZCUiapplication shareApplication].host=[dic valueForKey:@"host"];
                    [DZCUiapplication shareApplication].port=[dic valueForKey:@"port"];
                }
            }
        }
        
    }];
    //开启本地服务器
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    httpServer = [[HTTPServer alloc] init];
    
    [httpServer setType:@"_http._tcp."];
    
    [httpServer setPort:12224];
    
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    DLog(@"电影保存地址%@",webPath);
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:webPath])
    {
        [fileManager createDirectoryAtPath:webPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [httpServer setDocumentRoot:webPath];
    
    [self startServer];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [httpServer stop];//关闭服务器
    [UIApplication sharedApplication].idleTimerDisabled=NO;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self startServer];//重新打开服务器
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)onConnectSuccess
{
    NSLog(@"链接成功");
}
-(void)onConnectFailed:(NSString *)error
{
    NSLog(@"链接失败%@",error);
}
#pragma mark-检测网络状态发生改变处理事件
// 连接改变

- (void)reachabilityChanged: (NSNotification*)note
{
    Reachability*curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}
//处理连接改变后的情况

- (void)updateInterfaceWithReachability: (Reachability*)curReach
{
    //对连接改变做出响应的处理动作。
    //dispatch_async(dispatch_get_main_queue(), ^{
    
    
    NetworkStatus status=[curReach currentReachabilityStatus];
    
    if (status==ReachableViaWWAN)//手机网络
    {
        //获取一下运营商名称
        [DZCUiapplication shareApplication].carrierName=[DzcDES getcarrierName];
        //获取一下网络状态
        [DZCUiapplication shareApplication].linkeState=@"4G";
        NSString *name=  [DZCUiapplication shareApplication].carrierName;
        if(![name isEqualToString:@"中国移动"])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"您正在使用蜂窝数据网络，建议切换至wifi网络下使用" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
        DLog(@"手机网络");
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadhomedata" object:nil];
        
        
    }
    if (status== NotReachable) {
        //[self gettoken];
        //没有连接到网络就弹出提实况
        //        //获取一下运营商名称
        //        [DZCUiapplication shareApplication].carrierName=[DzcDES getcarrierName];
        //        //获取一下网络状态
        //        //[DZCUiapplication shareApplication].linkeState=[DzcDES networktype];
        //
        //        DLog(@"没有网络%@",name);
        //        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"网络连接失败，请检查您的手机网络" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        //        [alert show];
    }
    if(status==ReachableViaWiFi)//wifi网络
    {
        
        //获取一下运营商名称
        [DZCUiapplication shareApplication].carrierName=[DzcDES getcarrierName];
        //获取一下网络状态
        [DZCUiapplication shareApplication].linkeState=@"WIFI";//测试WIFI先修改为4G
        
        DLog(@"WIFI网络");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadhomedata" object:nil];
    }
    // });
    
}
@end
