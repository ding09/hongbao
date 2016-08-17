//
//  LFListCollectionViewCell.h
//  movie
//
//  Created by li wei on 15/10/23.
//  Copyright (c) 2015年 li wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *listImageView;
@property (weak, nonatomic) IBOutlet UILabel *listName;
@property (weak, nonatomic) IBOutlet UILabel *VIPLable;

@end
