//
//  movieDetailViewController.h
//  moneybaby
//
//  Created by 张久霞 on 15/7/15.
//  Copyright (c) 2015年 li wei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>
#import "MBProgressHUD.h"
#import "WHC_Download.h"
#import "DZCvideoList.h"

@interface movieDetailViewController : UIViewController<WHCDownloadDelegate,UITextFieldDelegate>
{
    
    
    NSString *pathimage;
    NSString *contentlength;
    NSMutableArray *ADarray;//广告数据
    NSString *ADpathImage;//广告图片保存路径
    NSMutableArray *imageUrlArray;//保存广告图片下载路径
   
    UITextField *commentfiled;
    int PageIndex;
    int PageSize;
    
    
}

@property (weak, nonatomic) IBOutlet UIImageView *movieimage;
@property (weak, nonatomic) IBOutlet UILabel *movieName;
@property (weak, nonatomic) IBOutlet UILabel *movieLocation;
@property (weak, nonatomic) IBOutlet UILabel *moviepeople;
@property (weak, nonatomic) IBOutlet UILabel *movieStyle;
@property (weak, nonatomic) IBOutlet UILabel *movieScore;
- (IBAction)moviePlayTap:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *mainscrol;
@property (weak, nonatomic) IBOutlet UITextView *movieContent;
@property (weak, nonatomic) IBOutlet UILabel *movieYear;
@property (nonatomic,strong)NSMutableArray *listArray;
@property (nonatomic,strong)MBProgressHUD *progressHUD;
@property (nonatomic,strong)NSString *movieID;
@property (nonatomic ,strong)DZCvideoList *videoList;




//电影缓存
- (IBAction)CacheMovie:(UIButton *)sender;

@end
