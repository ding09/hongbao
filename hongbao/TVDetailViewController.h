//
//  TVDetailViewController.h
//  moneybaby
//
//  Created by li wei on 15/9/10.
//  Copyright (c) 2015年 li wei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>
#import "MBProgressHUD.h"
#import "DZCvideoList.h"

@class ASIHTTPRequest;
@interface TVDetailViewController : UIViewController
{
    
    
    int PageIndex;
    int PageSize;
    int tvtimes;//请求次数
    
}

@property (weak, nonatomic) IBOutlet UIImageView *TvPictureImageView;


@property (weak, nonatomic) IBOutlet UITableView *DZCTabview;


@property (weak, nonatomic) IBOutlet UILabel *TVName;
@property (weak, nonatomic) IBOutlet UILabel *TVArea;
@property (weak, nonatomic) IBOutlet UILabel *TVstar;
@property (weak, nonatomic) IBOutlet UILabel *TVType;
@property (weak, nonatomic) IBOutlet UILabel *TVScore;

@property (nonatomic,strong)MBProgressHUD *progressHUD;

@property (nonatomic,strong)NSString *TVnumbers;
@property (weak, nonatomic) IBOutlet UIScrollView *MainScrollView;
@property (nonatomic,strong)DZCvideoList *videoList;

@end
