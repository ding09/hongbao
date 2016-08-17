//
//  TVDetailViewController.m
//  moneybaby
//
//  Created by li wei on 15/9/10.
//  Copyright (c) 2015年 li wei. All rights reserved.
//

#import "TVDetailViewController.h"
#import "AFNetworking.h"

#import <MediaPlayer/MediaPlayer.h>

#import "DzcDES.h"
#import "UIImageView+WebCache.h"
#import "LFPlayViewController.h"

@interface TVDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@end
//static int indexImage;
@implementation TVDetailViewController
@synthesize videoList;
//static NSString *cellid=@"dzc";


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DetailvideoFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//        DLog(@"初始化通知");
    }
    return self;
}
-(void)backTap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.title=@"电视剧详情";
    CGSize size=CGSizeMake(SCREENWIDTH, 551*2+64-SCREENHEIGHT);
    
    self.MainScrollView.contentSize=size;
    
    
    _progressHUD=[[MBProgressHUD alloc]init];
    [self.view addSubview:_progressHUD];
    [_progressHUD setLabelText:@"数据刷新中"];
    [_progressHUD show:YES];
    [self.DZCTabview setDataSource:self];
    [self.DZCTabview setDelegate:self];
    //注册集合视图xib单元文件
//    UINib *nib=[UINib nibWithNibName:@"TVCollectionViewCell" bundle:nil];
//    [self.collectionview registerNib:nib forCellWithReuseIdentifier:@"tvcell"];
    
    
    self.TVName.text=videoList.AppName;
    self.navigationItem.title=videoList.AppName;
    self.TVArea.text=[NSString stringWithFormat:@"地区：%@",videoList.AppArea];
    self.TVstar.text=[NSString stringWithFormat:@"主演:%@",videoList.Author];
    self.TVType.text=[NSString stringWithFormat:@"集数:%@",videoList.AppSize];
    self.TVScore.text=[NSString stringWithFormat:@"评分：%@",videoList.Star];
    [self.TvPictureImageView sd_setImageWithURL:[NSURL URLWithString:[DzcDES testUrl:videoList.ImageUrl]]];
    
    [_progressHUD hide:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Identifier = @"xuanjicell";
    UITableViewCell * dzccell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (dzccell==nil) {
        dzccell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
    }
    //int w=SCREENWIDTH/6;
    CGFloat spaceX=(SCREENWIDTH-50*5)/6.0f;
    CGFloat spaceY=(SCREENHEIGHT-157-59-50*5)/6.0f+10;
    
    
    NSInteger index=[[NSUserDefaults standardUserDefaults]integerForKey:videoList.ID];
    for(int i=0;i<[videoList.AppSize intValue];i++)
    {
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(spaceX+(50+spaceX)*(i%5), spaceY+(spaceY+50)*(i/5), 50, 50)];//-21
        btn.layer.masksToBounds=YES;
        btn.layer.cornerRadius=8;
        [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.tag=100+i;
        btn.backgroundColor=[UIColor colorWithRed:0.0 green:177.0/255 blue:255.0/255.0 alpha:1.0];
        [btn addTarget:self action:@selector(clickTvNumber:) forControlEvents:UIControlEventTouchUpInside];
        if (i==index)
        {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        
        [dzccell addSubview:btn];
    }
    dzccell.selectionStyle=UITableViewCellSelectionStyleNone;
    return dzccell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat spaceY=(SCREENHEIGHT-157-59-50*5)/6.0f+10;
    
    return spaceY+(spaceY+50)*([videoList.AppSize intValue]/5)-21+150;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)clickTvNumber:(UIButton *)_btn
{
    DLog(@"点击了第%ld个",_btn.tag);
    LFPlayViewController *movieplayer=[[LFPlayViewController alloc]init];
    
    movieplayer.movieID=videoList.ID;
    movieplayer.movieNumber=(int)_btn.tag-100+1;
    movieplayer.movieName=videoList.AppName;
    movieplayer.allMovieNumber=[videoList.AppSize intValue];
    //movieplayer.range=self.range;
    //[self.navigationController pushViewController:movieplayer animated:YES];
    
    
    [self presentViewController:movieplayer animated:NO completion:^{
        [self.DZCTabview reloadData];
    }];
}


-(void)TVPlay:(NSIndexPath *)indexPath
{
    /*
    DZCmovieinfor *listmovie=[[DZCmovieinfor alloc]init];
    listmovie=self.listArray[0];
    if ([self.from isEqualToString:@"record"]) {
        LFPlayViewController *movieplayer=[[LFPlayViewController alloc]init];
        
        movieplayer.movieID=self.TVID;
        movieplayer.movieNumber=(int)indexPath.row+1;
        movieplayer.movieName=self.TVName.text;
        movieplayer.allMovieNumber=[listmovie.CurIndex intValue];
        
            
        }];
    }
    else
    {
        LFPlayViewController *movieplayer=[[LFPlayViewController alloc]init];
        
        movieplayer.movieID=self.TVID;
        movieplayer.movieNumber=(int)indexPath.row+1;
        movieplayer.movieName=self.TVName.text;
        movieplayer.allMovieNumber=[listmovie.CurIndex intValue];
        //MoviePlayerViewController *player=[[MoviePlayerViewController alloc]init];
        //[player deleteRecord:self.TVName.text];//删除播放位置记录
        //[self.navigationController pushViewController:movieplayer animated:YES];
        
        
        [self presentViewController:movieplayer animated:NO completion:^{
            [self.collectionview reloadData];
           
        }];
    }
    */
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat height=scrollView.frame.size.height;
    int contentYoffset=scrollView.contentOffset.y;
    int distanceFromBottom=(int)scrollView.contentSize.height-contentYoffset;
    if (distanceFromBottom == height||distanceFromBottom<height)
    {
        DLog(@"滚动到底部了");
        
        
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma mark-最新电影分享后观看
#pragma mark-分享成功或失败回调事件

/*
-(void)clickTvNumber:(UIButton *)_sender
{
    [_sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    DZCUiapplication *dzc=[DZCUiapplication shareApplication];
    [[NSUserDefaults standardUserDefaults]setValue:dzc.linkeState forKey:@"Netstate"];
    DZCmovieinfor *listmovie=[[DZCmovieinfor alloc]init];
    listmovie=self.listArray[0];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_sender.tag-100 inSection:_sender.tag-100 ];
    [[NSUserDefaults standardUserDefaults]setInteger:indexPath.row forKey:listmovie.ID];
    //先检测手机剩余空间大小
    NSString *fileSize=[DzcDES freeDiskSpaceInBytes];
    DLog(@"手机剩余%@MB",fileSize);
    if ([fileSize doubleValue]<1000.0)
    {
        
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
        if (![dzc.linkeState isEqualToString:@"WIFI"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"手机存储空间不足1G，请清理后使用" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        
        
    }
    NSRange range=[listmovie.SiteUrl rangeOfString:@"cloud"];
    if (range.location!=NSNotFound)//抢先电影
    {
        
        NSString *shareBZ=[[NSUserDefaults standardUserDefaults]objectForKey:movieinfor.Name];
        DLog(@"分享标志%@",shareBZ);
        if (![shareBZ isEqualToString:@"1"])//已经分享过了
        {
            
            DXAlertView *alert=[[DXAlertView alloc]initWithTitle:@"温馨提示" contentText:@"最新上映电影需要分享成功后观看" leftButtonTitle:@"稍后再说" rightButtonTitle:@"分享观看"];
            [alert show];
            alert.leftBlock=^{
                return ;
            };
            alert.rightBlock=^{
                NSDictionary *share=[DZCAppConfig shareApplication].Share;
                [self share:share];
                DLog(@"分享内容content%@movieContent%@tips%@",[DzcDES DecodeBase64:[share valueForKey:@"Content"]],[DzcDES DecodeBase64:[share valueForKey:@"MovieContent"]],[DzcDES DecodeBase64:[share valueForKey:@"Tips"]]);
            };
            
        }
        
    }
    
    
    
    
    
    if ([dzc.loginState isEqualToString:@"Y"])//登录
    {
        
        
        if ([listmovie.Score isEqualToString:@"0"])//非VIP电影
        {
            if ([dzc.linkeState isEqualToString:@"WIFI"])//无线网络下
            {
                
                [self TVPlay:indexPath];
            }
            else//手机网络下
            {
                
                
                
                if ([dzc.isVIP isEqualToString:@"1"])//VIP会员
                    
                {
                    if([dzc.carrierName isEqualToString:@"中国移动"])//移动用户
                    {
                        [self TVPlay:indexPath];
                    }
                    else//非移动用户
                    {
                        
                        DXAlertView *alert=[[DXAlertView alloc]initWithTitle:@"友情提示" contentText:@"您正在使用蜂窝数据网络，建议切换至wifi网络下使用" leftButtonTitle:@"取消播放" rightButtonTitle:@"继续播放"];
                        [alert show];
                        alert.leftBlock=^(){
                            return ;
                        };
                        alert.rightBlock=^(){
                            [self TVPlay:indexPath];
                        };
                        alert.dismissBlock=^(){
                            return ;
                        };
                        
                    }
                    
                }
                else//非VIP会员
                {
                    
                    DXAlertView *alert=[[DXAlertView alloc]initWithTitle:@"友情提示" contentText:@"您正在使用蜂窝数据网络，建议切换至wifi网络下使用" leftButtonTitle:@"取消播放" rightButtonTitle:@"继续播放"];
                    [alert show];
                    alert.leftBlock=^(){
                        return ;
                    };
                    alert.rightBlock=^(){
                        [self TVPlay:indexPath];
                    };
                    alert.dismissBlock=^(){
                        return ;
                    };
                }
            }
        }
        else//VIP电影
        {
            if([dzc.linkeState isEqualToString:@"WIFI"])//无线网路下
            {
                if ([dzc.isVIP isEqualToString:@"1"])//Vip会员用户
                {
                    
                    [self TVPlay:indexPath];
                    
                    
                }
                else//非VIP会员用户
                {
                    DXAlertView *alert=[[DXAlertView alloc]initWithTitle:@"友情提示" contentText:@"该影片为VIP资源，请开通VIP继续观看" leftButtonTitle:@"取消" rightButtonTitle:@"开通"];
                    [alert show];
                    alert.leftBlock=^(){
                        return ;
                    };
                    alert.rightBlock=^(){
                        //跳转到充值VIP界面
                        LFVipTableViewController *vip=[[LFVipTableViewController alloc]initWithStyle:UITableViewStylePlain];
                        [self.navigationController pushViewController:vip animated:YES];
                    };
                    alert.dismissBlock=^(){
                        return ;
                    };
                }
            }
            else//手机网络下
            {
                if ([dzc.isVIP isEqualToString:@"1"])//Vip会员用户
                {
                    
                    
                    if ([dzc.carrierName isEqualToString:@"中国移动"])//移动用户
                    {
                        [self TVPlay:indexPath];
                    }
                    else//非移动用户
                    {
                        DXAlertView *alert=[[DXAlertView alloc]initWithTitle:@"友情提示" contentText:@"您正在使用蜂窝数据网络，建议切换至wifi网络下使用" leftButtonTitle:@"继续观看" rightButtonTitle:@"取消"];
                        [alert show];
                        alert.leftBlock=^(){
                            [self TVPlay:indexPath];
                        };
                        alert.rightBlock=^(){
                            return ;
                        };
                        alert.dismissBlock=^(){
                            return ;
                        };
                    }
                    
                    
                }
                else//非VIP会员用户
                {
                    DXAlertView *alert=[[DXAlertView alloc]initWithTitle:@"友情提示" contentText:@"该影片为VIP资源，请开通VIP继续观看" leftButtonTitle:@"取消" rightButtonTitle:@"开通"];
                    [alert show];
                    alert.leftBlock=^(){
                        return ;
                    };
                    alert.rightBlock=^(){
                        //跳转到充值VIP界面
                        LFVipTableViewController *vip=[[LFVipTableViewController alloc]initWithStyle:UITableViewStylePlain];
                        [self.navigationController pushViewController:vip animated:YES];
                    };
                    alert.dismissBlock=^(){
                        return ;
                    };
                }
            }
            
            
        }
    }
    else//未登陆
    {
        DXAlertView *alert=[[DXAlertView alloc]initWithTitle:@"友情提示" contentText:@"您还没有登录，请登录后观看影片" leftButtonTitle:@"稍候登录" rightButtonTitle:@"立即登陆"];
        [alert show];
        alert.leftBlock=^(){
            return ;
        };
        alert.rightBlock=^(){
            //跳转到登录界面
            LFLoginViewController *login=[[LFLoginViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
        };
        alert.dismissBlock=^(){
            return ;
        };
    }

}
*/
@end
