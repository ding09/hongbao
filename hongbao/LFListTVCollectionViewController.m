//
//  LFListTVCollectionViewController.m
//  movie
//
//  Created by li wei on 15/10/24.
//  Copyright (c) 2015年 li wei. All rights reserved.
//

#import "LFListTVCollectionViewController.h"

#import "DzcDES.h"
#import "UIImageView+WebCache.h"
#import "DZCvideoList.h"
#import "DZCbusiness.h"
#import "TVDetailViewController.h"
@interface LFListTVCollectionViewController ()
{
     int tabhight;
}
@end

//static int indexImage;
@implementation LFListTVCollectionViewController
@synthesize listArray,progressHUD;
static NSString * const reuseIdentifier = @"listcell";
-(instancetype)init
{
    self.areaArray=[NSMutableArray array];
    self.yearArray=[NSMutableArray array];
    self.typeArray=[NSMutableArray array];
    self.vipArray=[NSMutableArray array];
    self.listArray=[NSMutableArray array];
    //self.imageArray=[[NSMutableArray alloc]initWithCapacity:10];
   
    keydict=[NSMutableDictionary dictionary];
    tabhight=0;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir=[paths lastObject];
    NSDictionary *dict;
    if ([[NSFileManager defaultManager]fileExistsAtPath:[docDir stringByAppendingPathComponent:@"videoList.txt"]])
    {
        dict=[NSDictionary dictionaryWithContentsOfFile:[docDir stringByAppendingPathComponent:@"videoList.txt"]];
    }
    else
    {
        dict=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"videoList" ofType:@"txt"]];
    }
    NSArray *navArray=[dict objectForKey:@"nav"];
    for(NSDictionary *dic in navArray)
    {
        if ([[dic valueForKey:@"tabName"]isEqualToString:@"电视剧"])
        {
            
            NSDictionary *    d=[dic objectForKey:@"videoclass"];
            self.areaArray=[d objectForKey:@"area"];
            self.typeArray=[d objectForKey:@"type"];
            self.yearArray=[d objectForKey:@"year"];
            self.vipArray=[d objectForKey:@"VIP"];
        }
    }
    if (self.areaArray.count!=0)
    {
        tabhight ++;
    }
    if (self.typeArray.count!=0)
    {
        tabhight ++;
    }
    if (self.yearArray.count!=0)
    {
        tabhight ++;
    }
    if (self.vipArray.count!=0)
    {
        tabhight ++;
    }
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    NSString *name=[DzcDES getUserPhoneVersion];
    NSRange rangeone=[name rangeOfString:@"4"];
    NSRange rangetwo=[name rangeOfString:@"5"];
    if (rangeone.location==NSNotFound&&rangetwo.location==NSNotFound)//如果不是4也不是5机器，每行显示三个Item
    {
        float width;
        float height;
        width=SCREENWIDTH/3;
        height=width*4/3;
        [flowLayout setItemSize:CGSizeMake(width, height)];//单元大小设置
        
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置Item内边距大小
        flowLayout.headerReferenceSize=CGSizeMake(SCREENWIDTH, 30*tabhight);//头部区域大小设置
        flowLayout.minimumLineSpacing=5;//每行最小边距
        flowLayout.minimumInteritemSpacing=0;//每列最小边距
        
        self = [self initWithCollectionViewLayout:flowLayout];
        if (self) {
            self.collectionView.bounces=NO;
        }
        return self;
    }
    else
    {
     
        float width;
        float height;
        width=SCREENWIDTH/2;
        height=width*4/3;
        [flowLayout setItemSize:CGSizeMake(width, height)];//单元大小设置
        
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置Item内边距大小
        flowLayout.headerReferenceSize=CGSizeMake(SCREENWIDTH, 120);//头部区域大小设置
        flowLayout.minimumLineSpacing=5;//每行最小边距
        flowLayout.minimumInteritemSpacing=0;//每列最小边距
        
        self = [self initWithCollectionViewLayout:flowLayout];
        if (self) {
            self.collectionView.bounces=NO;
        }
        return self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor=[UIColor whiteColor];
    [self setFllow];//设置集合视图数据流
    
    [self.collectionView reloadData];
    
    progressHUD=[[MBProgressHUD alloc]init];
    [self.view addSubview:progressHUD];
    
    [progressHUD setLabelText:@"加载影片信息"];
    [progressHUD show:YES];
    
    AppType=2;
    PageIndex=1;
    PageSize=10;
    
    [DZCbusiness DZCgetVideoDataWithApptype:AppType PageIndex:PageIndex PageSize:PageSize k:@""];
    
    //添加返回顶部按钮
    reBackBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-43, SCREENHEIGHT-48-43-100, 43, 43)];
    reBackBtn.alpha=0.7;
    reBackBtn.layer.masksToBounds=YES;
    reBackBtn.layer.cornerRadius=21.5;
    [reBackBtn setBackgroundImage:[UIImage imageNamed:@"reback"] forState:UIControlStateNormal];
    [reBackBtn addTarget:self action:@selector(ReBackTop) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:reBackBtn];
    [self.view bringSubviewToFront:reBackBtn];
    
}
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
    [self.collectionView reloadData];
    [progressHUD hide:YES];
}
//请求失败
-(void)DZCgetVideoDataFail:(NSNotification *)_obj
{
    DLog(@"请求失败%@",_obj);
    [progressHUD setDetailsLabelText:@"加载失败！"];
    [progressHUD hide:YES afterDelay:1.0];
}


-(void)ReBackTop
{
    if (self.listArray.count!=0)
    {
         [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
   
    
}
//注册自定义集合视图单元和头部分区xib
-(void)setFllow
{
    
    
    UINib *nib=[UINib nibWithNibName:@"LFListCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    UINib *headnib=[UINib nibWithNibName:@"LFHeadCollectionReusableView" bundle:nil];
    
    [self.collectionView registerNib:headnib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"lfheadcell"];
    
}
#pragma mark- 请求网络数据事件


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}




#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    listcell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    DZCvideoList *moviedata=self.listArray[indexPath.row];
    if (![moviedata.Score isEqualToString:@"0"])
    {
        listcell.VIPLable.hidden=NO;
    }
    else
    {
        listcell.VIPLable.hidden=YES;
    }
    listcell.listName.text=moviedata.AppName;
    

    
    NSURL *url=[NSURL URLWithString:[DzcDES testUrl:moviedata.ImageUrl]];
    [listcell.listImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"00100"]];
    
    return listcell;
}
//添加集合视图头部区域
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    headcell=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"lfheadcell" forIndexPath:indexPath];
    
        
        headcell.backgroundColor=[UIColor whiteColor];
    if (hsv1==nil)
    {
        //创建我们定制的滚动视图
        hsv1=[[HScrollView alloc]init];
        //设定位置和大小
        hsv1.frame=CGRectMake(0, 0, SCREENWIDTH, 30);
        
        [self addScrollView:hsv1 WithTitleArray:self.areaArray andFenLeiId:1];
    }
    if (hsv2==nil)
    {
        //创建我们定制的滚动视图
        hsv2=[[HScrollView alloc]init];
        //设定位置和大小
        hsv2.frame=CGRectMake(0, 30, SCREENWIDTH, 30);
        
        [self addScrollView:hsv2 WithTitleArray:self.typeArray andFenLeiId:2];
    }
    if (hsv3==nil)
    {
        //创建我们定制的滚动视图
        hsv3=[[HScrollView alloc]init];
        //设定位置和大小
        hsv3.frame=CGRectMake(0, 60, SCREENWIDTH, 30);
        
        [self addScrollView:hsv3 WithTitleArray:self.yearArray andFenLeiId:3];
    }
    if (hsv4==nil)
    {
        //创建我们定制的滚动视图
        hsv4=[[HScrollView alloc]init];
        //设定位置和大小
        hsv4.frame=CGRectMake(0, 90, SCREENWIDTH, 30);
        
        [self addScrollView:hsv4 WithTitleArray:self.vipArray andFenLeiId:4];
    }
    
    
   

    
    
    return headcell;
}
//集合视图单元点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"暂未更新影片" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
//    [alert show];
    DZCvideoList *moviedata=self.listArray[indexPath.row];
    DLog(@"%@====",moviedata.AddDate);
    
    TVDetailViewController *TVdetail=[[TVDetailViewController alloc]init];
   
    
    TVdetail.videoList=moviedata;
    
    [self.navigationController pushViewController:TVdetail animated:YES];
    
    
}
#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 
 
 
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 
 
 
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */
#pragma mark-添加集合视图头部分类检索信息
-(void)addScrollView:(HScrollView *)_hsv WithTitleArray:(NSArray *)_titleArray andFenLeiId:(int)_flid
{
    for (int i=0; i<_titleArray.count; i++)
    {
        
        UIButton * one=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        if (i==0)
        {
            one.backgroundColor=[UIColor whiteColor];
            [one setTitleColor:[UIColor colorWithRed:0.0 green:177.0/255 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
        [one setTitle:_titleArray[i] forState:UIControlStateNormal];
        one.titleLabel.textAlignment=NSTextAlignmentLeft;
        one.layer.cornerRadius=20;
        [one addTarget:self action:@selector(OneTap:) forControlEvents:UIControlEventTouchUpInside];
        one.frame=CGRectMake(0, 0, 60, 30);
        one.tag=_flid;
        
        [_hsv addButton:one];
    }
    
    [headcell addSubview:_hsv];
}
//分类信息点击事件
-(void)OneTap:(UIButton *)sender
{
    
    DLog(@"单机一次%@",sender.titleLabel.text);
    [progressHUD setLabelText:@"加载中"];
    //int flid=sender.tag+1;
    switch (sender.tag) {
        case 1:
        {
            [hsv1 clearcolor];
            [keydict removeObjectForKey:@"area"];
            [keydict setValue:sender.titleLabel.text forKey:@"area"];
            if ([sender.titleLabel.text isEqualToString:@"全部"]) {
                [keydict removeObjectForKey:@"area"];
                [keydict setValue:@"" forKey:@"area"];
            }
            AppType=2;
            PageIndex=1;
            PageSize=10;
            
            [self.listArray removeAllObjects];
           
            [progressHUD show:YES];
            [self loadinforWithKey:keydict];
            
        }
            break;
        case 2:
        {
            [hsv2 clearcolor];
            [keydict removeObjectForKey:@"type"];
            [keydict setValue:sender.titleLabel.text forKey:@"type"];
            if ([sender.titleLabel.text isEqualToString:@"全部"]) {
                [keydict removeObjectForKey:@"type"];
                [keydict setValue:@"" forKey:@"type"];
            }
            AppType=2;
            PageIndex=1;
            PageSize=10;
            
            [self.listArray removeAllObjects];
           
            [progressHUD show:YES];
            
            [self loadinforWithKey:keydict];
        }
            break;
        case 3:
        {
            [hsv3 clearcolor];
            [keydict removeObjectForKey:@"year"];
            [keydict setValue:sender.titleLabel.text forKey:@"year"];
            if ([sender.titleLabel.text isEqualToString:@"全部"]) {
                [keydict removeObjectForKey:@"year"];
                [keydict setValue:@"" forKey:@"year"];
            }
            AppType=2;
            PageIndex=1;
            PageSize=10;
            
            [self.listArray removeAllObjects];
            
            [progressHUD show:YES];
            
            [self loadinforWithKey:keydict];
        }
            break;
        case 4:
        {
            [hsv4 clearcolor];
            [keydict removeObjectForKey:@"vip"];
            [keydict setValue:sender.titleLabel.text forKey:@"vip"];
            if ([sender.titleLabel.text isEqualToString:@"全部"]) {
                [keydict removeObjectForKey:@"vip"];
                [keydict setValue:@"" forKey:@"vip"];
            }
            AppType=2;
            PageIndex=1;
            PageSize=10;
            
            [self.listArray removeAllObjects];
           
            [progressHUD show:YES];
            
            [self loadinforWithKey:keydict];
        }
            break;
        default:
            break;
    }
    
    
    
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:177.0/255 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    sender.backgroundColor=[UIColor whiteColor];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat height=scrollView.frame.size.height;
    int contentYoffset=scrollView.contentOffset.y;
    int distanceFromBottom=(int)scrollView.contentSize.height-contentYoffset;
    if (distanceFromBottom == height||distanceFromBottom<height)
    {
        DLog(@"滚动到底部了");
        [progressHUD setLabelText:@"数据加载中"];
        [progressHUD show:YES];
        [self loadinforWithKey:keydict];
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

@end
