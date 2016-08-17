//
//  DZCOneTableViewController.m
//  hongbao
//
//  Created by li wei on 16/8/5.
//  Copyright © 2016年 li wei. All rights reserved.
//

#import "DZCOneTableViewController.h"
#import "WHC_Banner.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "DZCHomeTableViewCellOneXIB.h"

#import "DZCHomeTableViewCellTwoXIB.h"
#import "DZCHomeTableViewCellThreeXIB.h"
#import "DZCbusiness.h"
#import "DZCvideoList.h"
#import "DzcDES.h"
#import "LFListCollectionViewController.h"
#import "LFListTVCollectionViewController.h"
#import "WMPageController.h"
#import "DZCNavController.h"
#import "LFNavigationController.h"
#import "MBProgressHUD.h"
#import "movieDetailViewController.h"
@interface DZCOneTableViewController ()<WHC_BannerDelegate>
{
    WHC_Banner * _banner1,*_banner2;
    CGFloat bannerHeight;
    UIView *dzcfootview;
    UINib *onenib;
    UINib *twonib;
    UINib *threenib;
    NSArray *videolistArr;
}

@end

@implementation DZCOneTableViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DZCgetVideoDataFinish:) name:@"getVideoDataFinishedNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DZCgetVideoDataFail:) name:@"getVideoDataFailedNotification" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"getVideoDataFinishedNotification" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"getVideoDataFailedNotification" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    progressHUD=[[MBProgressHUD alloc]init];
    [progressHUD setDetailsLabelText:@"加载中"];
    [progressHUD show:YES];
    
    bannerHeight = (CGRectGetHeight([UIScreen mainScreen].bounds) - 64) / 4;
    self.tableView.backgroundColor=[UIColor colorWithRed:249 green:249 blue:249 alpha:1.0];
    [DZCbusiness DZCgetVideoDataWithApptype:1 PageIndex:1 PageSize:6 k:@""];
   // [DZCbusiness DZCgetVideoInfosWithID:@"ae4f866f799d4ffaa3b91dad4f257adb"];
    //[DZCbusiness DZCgetVideosWithID:@"ae4f866f799d4ffaa3b91dad4f257adb" index:0 uType:@"url" vType:1];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
//请求成功
-(void)DZCgetVideoDataFinish:(NSNotification *)_obj
{
    DLog(@"请求成功%@",_obj.object );
    videolistArr=_obj.object;
    [self.tableView reloadData];
    [progressHUD hide:YES];
}
//请求失败
-(void)DZCgetVideoDataFail:(NSNotification *)_obj
{
    DLog(@"请求失败%@",_obj);
    [progressHUD setDetailsLabelText:@"加载失败!"];
    [progressHUD hide:YES afterDelay:1.0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0)
    {
        static NSString * onecellid = @"dzchomeonecell";
        
        if (onenib == nil) {
            onenib = [UINib nibWithNibName:@"DZCHomeTableViewCellOneXIB" bundle:nil];
            [tableView registerNib:onenib forCellReuseIdentifier:onecellid];
            DLog(@"我是从nib过来的");
        }

        DZCHomeTableViewCellOneXIB *onecell=[tableView dequeueReusableCellWithIdentifier:onecellid ];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _banner1 = [[WHC_Banner alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), bannerHeight)];
            _banner1.pageViewPosition = Left;
            //_banner1.pageViewBackgroundColor=[UIColor grayColor];
            
            _banner1.delegate=self;
            
        });
        _banner1.images = @[@"banner-2.jpg",@"banner-0.jpg",@"banner-1.jpg"];
        //_banner3.imageTitles = @[@"优秀开源项目",@"WHC_iOS",@"WHC_android"];
        _banner1.currentPageIndicatorTintColor=[UIColor whiteColor];
        _banner1.pageIndicatorTintColor=[UIColor blackColor];
        [_banner1 startBanner];
        [_banner1 removeFromSuperview];
        [onecell.showBannerview addSubview:_banner1];
        
        return onecell;
    }
    else if (indexPath.section==1)
    {
        static NSString * twocellid = @"dzchometwocell";
        
        if (twonib == nil) {
            twonib = [UINib nibWithNibName:@"DZCHomeTableViewCellTwoXIB" bundle:nil];
            [tableView registerNib:twonib forCellReuseIdentifier:twocellid];
            DLog(@"我是从nib过来的");
        }
        DZCHomeTableViewCellTwoXIB *twocell=[tableView dequeueReusableCellWithIdentifier:twocellid ];
        
        return twocell;
    }
    else
    {
        static NSString * threecellid = @"dzchomethreecell";
        
        if (threenib == nil) {
            threenib = [UINib nibWithNibName:@"DZCHomeTableViewCellThreeXIB" bundle:nil];
            [tableView registerNib:threenib forCellReuseIdentifier:threecellid];
            DLog(@"我是从nib过来的");
        }
        DZCHomeTableViewCellThreeXIB *threecell=[tableView dequeueReusableCellWithIdentifier:threecellid ];
        threecell.listArray=videolistArr;
        for(int i=0; i<videolistArr.count; i++)
        {
            UIButton *btn=[self.tableView viewWithTag:100+i];
            [btn addTarget:self action:@selector(dzcBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *lab=[self.tableView viewWithTag:200+i];
            DZCvideoList *videolist=[videolistArr objectAtIndex:i];
            
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[DzcDES testUrl:videolist.ImageUrl]] forState:UIControlStateNormal];
            lab.text=videolist.AppName;
        }
        return threecell;
    }
    
    
    
}
-(void)dzcBtnAction:(UIButton *)sender
{
    if (sender.tag-100<videolistArr.count) {
        DZCvideoList *videolist=[videolistArr objectAtIndex:sender.tag-100];
        DLog(@"电影名称%@",videolist.AppName);
        movieDetailViewController *movie=[[movieDetailViewController alloc]init];
        movie.videoList=videolist;
        DZCNavController *nav=[[DZCNavController alloc]initWithRootViewController:movie];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return bannerHeight;
    }
    else if (indexPath.section==1)
    {
        return 200;
    }
    else
    {
        return 310;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1)
    {
        return 40;
    }
    else
    {
        return 1;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==1)
    {
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
        if (dzcfootview==nil)
        {
            dzcfootview =[[UIView alloc]initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame),50)];
            UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
            lable.text=@"热门影视";
            [dzcfootview addSubview:lable];
            UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-105, 0, 100, 40)];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:@"更多资源" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(movieMoreAction) forControlEvents:UIControlEventTouchUpInside];
            [dzcfootview addSubview:btn];
        }
        
            
        //});
        return dzcfootview;
    }
    else
    {
        return nil;
    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - WHC_BannerDelegate 

- (void)WHC_Banner:(WHC_Banner *)banner networkLoadingWithImageView:(UIImageView *)imageView
          imageUrl:(NSString *)url
             index:(NSInteger)index {
    // 这里加载网络图片操作 以YYWebImage为例
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"banner-0.jpg"]];
    
}

- (void)WHC_Banner:(WHC_Banner *)banner clickImageView:(UIImageView *)imageView index:(NSInteger)index {
    // 处理点击图片操作
    DLog(@"点击图片index = %ld",(long)index);
}
#pragma mark-加载影视列表
-(void)movieMoreAction
{
    DLog(@"加载影视列表");
    
    
    
    NSArray *vcArr=[NSArray arrayWithObjects:[LFListCollectionViewController class],[LFListTVCollectionViewController class], nil];
    NSArray *titleArr=[NSArray arrayWithObjects:@"电影",@"电视剧", nil];
    WMPageController *pageController=[[WMPageController alloc]initWithViewControllerClasses:vcArr andTheirTitles:titleArr];
    pageController.titleColorSelected=[UIColor colorWithRed:0.0 green:177.0/255 blue:255.0/255.0 alpha:1.0];
    pageController.menuViewStyle=WMMenuViewStyleLine;
    pageController.pageAnimatable = NO;
    pageController.menuItemWidth = SCREENWIDTH*0.4;
    pageController.postNotification = NO;
    pageController.menuHeight=35;
    pageController.navigationItem.title=@"影视";
    LFNavigationController *nav=[[LFNavigationController alloc]initWithRootViewController:pageController];
    [self presentViewController:nav animated:YES completion:nil];
    
}

@end
