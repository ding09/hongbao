//
//  HScrollView.h
//  新闻客户端
//
//  Created by 张久霞 on 15/3/5.
//  Copyright (c) 2015年 张久霞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HScrollView : UIScrollView
{
    //按钮集合
    NSMutableArray * buttons;
}
-(HScrollView *)init;
-(void)addButton:(UIButton *)button;
-(void)clearcolor;
@end
