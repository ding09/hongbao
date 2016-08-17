//
//  LFSearchViewController.h
//  movie
//
//  Created by li wei on 15/10/21.
//  Copyright (c) 2015年 li wei. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "MBProgressHUD.h"

@interface LFSearchViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableViewCell *cell;
    int AppType;
    int PageIndex;
    int PageSize;
    NSString *imagePath;
    NSMutableDictionary *keydict;
   
}
@property (strong,nonatomic)UITableView *dzctableview;
@property (strong,nonatomic)MBProgressHUD *progressHUD;
@property (nonatomic,strong)NSMutableArray *listArray;
@property (nonatomic,strong)NSMutableArray *imageUrlArray;
@end
