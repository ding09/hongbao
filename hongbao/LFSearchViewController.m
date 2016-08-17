//
//  LFSearchViewController.m
//  movie
//
//  Created by li wei on 15/10/21.
//  Copyright (c) 2015年 li wei. All rights reserved.
//

#import "LFSearchViewController.h"


#import "DzcDES.h"
#import "DZCbusiness.h"
#import "DZCvideoList.h"
@interface LFSearchViewController ()

@end

@implementation LFSearchViewController
@synthesize dzctableview,progressHUD;
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
//请求成功
-(void)DZCgetVideoDataFinish:(NSNotification *)_obj
{
    DLog(@"请求成功%@",_obj.object );
    for(DZCvideoList *videoList in _obj.object)
    {
        [self.listArray addObject:videoList];
    }
    NSArray *arr=[NSArray arrayWithObject:_obj.object];
    if (arr.count>0)
    {
        PageIndex++;
    }
    [self.dzctableview reloadData];
    [progressHUD hide:YES];
}
//请求失败
-(void)DZCgetVideoDataFail:(NSNotification *)_obj
{
    DLog(@"请求失败%@",_obj);
    [progressHUD setDetailsLabelText:@"请求数据失败！"];
    [progressHUD hide:YES afterDelay:1.0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.listArray=[NSMutableArray array];
    UISearchBar *searchBar=[[UISearchBar alloc]init];
    [searchBar setBarTintColor:[UIColor whiteColor]];
    [searchBar setTintColor:[UIColor whiteColor]];
    searchBar.delegate=self;
    [searchBar becomeFirstResponder];
    searchBar.searchBarStyle=UISearchBarStyleProminent;
    searchBar.placeholder=@"请输入影片名称搜索";
    searchBar.showsCancelButton=YES;
    
    self.navigationItem.titleView=searchBar;
    
    
    //创建表示图
    dzctableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    dzctableview.delegate=self;
    dzctableview.dataSource=self;
    [self.view addSubview:dzctableview];
    keydict=[NSMutableDictionary dictionary];
    AppType=0;
    PageIndex=1;
    PageSize=10;
    
    progressHUD=[[MBProgressHUD alloc]init];
    [self.view addSubview:progressHUD];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- 搜索栏代理方法
//点击取消按钮
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:NO completion:nil];//视图消失返回首页
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    DLog(@"您将要搜索的内容是%@",searchBar.text);
    [self.listArray removeAllObjects];
    [keydict setValue:searchBar.text forKey:@"title"];
    [progressHUD show:YES];
    [searchBar resignFirstResponder];
    [self loadinforWithKey:keydict];
    
   
}
#pragma mark-UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"dzcsearch";
    cell =[dzctableview
           dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    DZCvideoList *listmovie=self.listArray[indexPath.row];
    
    cell.textLabel.text=listmovie.AppName;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZCvideoList *moviedata=self.listArray[indexPath.row];
    //DLog(@"点击搜索到的电影%@",moviedata.AppType);
    if ([moviedata.AppType isEqualToString:@"1"])//电影
    {
        DLog(@"电影");
    /*
    movieDetailViewController *movieDetail=[[movieDetailViewController alloc]init];
    //self.tabBarController.hidesBottomBarWhenPushed=YES;
    movieDetail.movieID=moviedata.ID;
    NSString *path=[NSTemporaryDirectory() stringByAppendingPathComponent:@"movie"];
    NSString *pathimg=[NSString stringWithFormat:@"%@/%@.jpg",path,moviedata.ID];
    
    NSFileManager *fileManger=[NSFileManager defaultManager];
        if ([fileManger fileExistsAtPath:pathimg])//如果这个图片已经有了
        {
            movieDetail.imagePath=pathimg;
        }
    [self.navigationController pushViewController:movieDetail animated:YES];
     */
    }
    else if ([moviedata.AppType isEqualToString:@"2"]||[moviedata.AppType isEqualToString:@"3"])//电视剧//动漫
    {
        DLog(@"电视剧");
        /*
        TVDetailViewController *TVdetail=[[TVDetailViewController alloc]init];
        
       
        TVdetail.Address=@"sb";
        TVdetail.TVID=moviedata.ID;
        NSString *path=[NSTemporaryDirectory() stringByAppendingPathComponent:@"tv"];
        NSString *pathimg=[NSString stringWithFormat:@"%@/%@.jpg",path,moviedata.ID];
        
        NSFileManager *fileManger=[NSFileManager defaultManager];
        if ([fileManger fileExistsAtPath:pathimg])//如果这个图片已经有了
        {
            TVdetail.imagePath=pathimg;
        }
        
        [self.navigationController pushViewController:TVdetail animated:YES];
         */
    }
    else
    {
        /*
        LFZYDetailViewController *ZYdetail=[[LFZYDetailViewController alloc]init];
        ZYdetail.TVID=moviedata.ID;
        [self.navigationController pushViewController:ZYdetail animated:YES];
         */
    }
}
-(void)loadinforWithKey:(NSMutableDictionary *)_dict
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_dict options:NSJSONWritingPrettyPrinted error:&parseError];
    DLog(@"key解析失败%@",parseError);
    
    NSString *key=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [DZCbusiness DZCgetVideoDataWithApptype:AppType PageIndex:PageIndex PageSize:PageSize k:key];
    
}
#pragma mark-不支持自动旋转屏幕
-(BOOL)shouldAutorotate
{
    return NO;
}
////横屏
//- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    return (toInterfaceOrientation == UIInterfaceOrientationMaskPortrait);
//
//}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
