//
//  LFListCollectionViewController.h
//  movie
//
//  Created by li wei on 15/10/23.
//  Copyright © 2015年 li wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFListCollectionViewCell.h"
#import "LFHeadCollectionReusableView.h"
#import "HScrollView.h"
#import "MBProgressHUD.h"




@interface LFListCollectionViewController : UICollectionViewController
{
    
    LFListCollectionViewCell *listcell;
    LFHeadCollectionReusableView *headcell;
    HScrollView *hsv1;
    HScrollView *hsv2;
    HScrollView *hsv3;
    HScrollView *hsv4;
    int AppType;
    int PageIndex;
    int PageSize;
    NSMutableDictionary *keydict;
    UIButton *reBackBtn;
    
    
    int movie;
    
    
    
    
}

@property(nonatomic,strong)NSMutableArray *listArray;


@property (nonatomic,strong)MBProgressHUD *progressHUD;
//保存分类信息到数组
@property (nonatomic,strong)NSMutableArray *areaArray;
@property (nonatomic,strong)NSMutableArray *typeArray;
@property (nonatomic,strong)NSMutableArray *yearArray;
@property (nonatomic,strong)NSMutableArray *vipArray;
@end
