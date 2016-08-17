//
//  HScrollView.m
//  新闻客户端
//
//  Created by 张久霞 on 15/3/5.
//  Copyright (c) 2015年 张久霞. All rights reserved.
//

#import "HScrollView.h"

@implementation HScrollView

-(HScrollView *)init
{
    
    self =[super init];
    if (self)
    {
        //实例话集合
        buttons=[[NSMutableArray alloc]initWithCapacity:10];
        //背景颜色
        self.backgroundColor=[UIColor whiteColor];
        //允许滚动
        self.scrollEnabled=YES;
        //取消滚动指示器
        self.showsVerticalScrollIndicator=NO;
        self.showsHorizontalScrollIndicator=NO;
        
    }
    return self;
    
    
}

//往滚动视图上放按钮
-(void)addButton:(UIButton *)button
{
    //滚动宽度为5，既是每个按钮之间的距离是五
    NSInteger width=5;
    //得到最后那个按钮
    UIButton * lastButton=[buttons lastObject];
    //计算宽度
    if (lastButton)
    {
        width+=lastButton.frame.origin.x+lastButton.frame.size.width;
    }
    else
    {
        width=0;
    }
    //得到要放倒滚动视图上按钮的frame
    CGRect frame=button.frame;
    //设定按钮距离滚动视图左边的距离
    frame.origin.x=width;
    //设定按钮距离滚动视图上边的距离
    //frame.origin.y=2;
    frame.origin.y=0;
    button.frame=frame;
    button.titleLabel.font=[UIFont systemFontOfSize:14];
    button.tintColor=[UIColor blackColor];
    //把按钮放到滚动视图上
    [self addSubview:button];
    //在集合中保存这个按钮
    [buttons addObject:button];
    //调节滚动范围
    if(width>self.frame.size.width)
    {
        self.contentSize=CGSizeMake(width+button.frame.size.width+5, 0);
    }
}
-(void)clearcolor
{
    for(UIButton * btn in buttons)
    {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor clearColor];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
