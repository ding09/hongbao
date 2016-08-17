//
//  TVCollectionViewCell.m
//  moneybaby
//
//  Created by li wei on 15/9/12.
//  Copyright (c) 2015年 li wei. All rights reserved.
//

#import "TVCollectionViewCell.h"

@implementation TVCollectionViewCell

- (void)awakeFromNib {
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=8;
    
    [self.numberLable setTextColor:[UIColor whiteColor]];
    
    self.backgroundColor=[UIColor colorWithRed:0.0 green:177.0/255 blue:255.0/255.0 alpha:1.0];
    // Initialization code
}

@end
