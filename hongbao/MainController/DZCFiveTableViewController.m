//
//  DZCFiveTableViewController.m
//  hongbao
//
//  Created by li wei on 16/8/5.
//  Copyright © 2016年 li wei. All rights reserved.
//

#import "DZCFiveTableViewController.h"
#import "UIImageView+WebCache.h"
#import "DZCUiapplication.h"
#import "LFNavigationController.h"
//#import "DZC_UserInfor.h"
//#import "DZC_LoginViewController.h"
//#import "DZC_MyMessageList.h"
@interface DZCFiveTableViewController ()

@end

@implementation DZCFiveTableViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    MB_HUD=[[MBProgressHUD alloc]init];
    [self.view addSubview:MB_HUD];
    array=[NSArray arrayWithObjects:@"个人资料",@"我的消息", @"我的红包",@"提现记录",nil];
    self.tableView.backgroundColor=[UIColor colorWithRed:249 green:249 blue:249 alpha:1.0];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-表示图
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 150)];
    UIImageView *bgimage=[[UIImageView alloc]initWithFrame:view.frame];
    bgimage.image=[UIImage imageNamed:@"uer_bg"];
    bgimage.backgroundColor=[UIColor whiteColor];
    [view addSubview:bgimage];
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(10, 35, 80, 80)];
    image.backgroundColor=[UIColor clearColor];
    [image sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"user_Header"]];
    
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(100, 90, CGRectGetWidth(self.view.frame)-150, 50)];
    //lable.backgroundColor=[UIColor blueColor];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(100, 30, CGRectGetWidth(self.view.frame)-150, 50)];
    
    
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [btn setTitle:@"点击登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[btn setBackgroundColor:[UIColor blackColor]];
    [btn addTarget:self action:@selector(LoginTap) forControlEvents:UIControlEventTouchUpInside];
    NSString *state=[DZCUiapplication shareApplication].loginState;
    if ([state isEqualToString:@"Y"])
    {
        lable.textColor=[UIColor blackColor];
        //lable.text=[DZCUiapplication shareApplication].nick_name;
        [lable setFrame:CGRectMake(100, 60, CGRectGetWidth(self.view.frame)-150, 50)];
        btn.hidden=YES;
    }
    else
    {
        lable.text=@"注册就送";
        btn.hidden=NO;
        [lable setFrame:CGRectMake(100, 90, CGRectGetWidth(self.view.frame)-150, 50)];
    }
    [view addSubview:image];
    [view addSubview:lable];
    [view addSubview:btn];
    return view;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"dzc_userinfor";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    
    cell.textLabel.text=[array objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0://个人资料
        {
            if ([[DZCUiapplication shareApplication].loginState isEqualToString:@"Y"])
            {
                
                NSLog(@"个人资料");
               // UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
               // DZC_UserInfor *tabview=[main instantiateViewControllerWithIdentifier:@"dzcuserinfor"];
               // [self.navigationController pushViewController:tabview animated:YES];
            }
            else
            {
                [MB_HUD show:YES];
                [MB_HUD setDetailsLabelText:@"您还没有登陆"];
                [MB_HUD hide:YES afterDelay:1.5];
            }
        }
            break;
        case 1://我的消息
        {
            if ([[DZCUiapplication shareApplication].loginState isEqualToString:@"Y"])
            {
                
                NSLog(@"我的消息");
               // DZC_MyMessageList *myList=[[DZC_MyMessageList alloc]initWithStyle:UITableViewStylePlain];
               // [self.navigationController pushViewController:myList animated:YES];
                
            }
            else
            {
                [MB_HUD show:YES];
                [MB_HUD setDetailsLabelText:@"您还没有登陆"];
                [MB_HUD hide:YES afterDelay:1.5];
            }
        }
            break;
        case 2://兑换纪录
        {
            if ([[DZCUiapplication shareApplication].loginState isEqualToString:@"Y"])
            {
                
                NSLog(@"兑换纪录");
            }
            else
            {
                [MB_HUD show:YES];
                [MB_HUD setDetailsLabelText:@"您还没有登陆"];
                [MB_HUD hide:YES afterDelay:1.5];
            }
        }
            break;
        case 3://我的好友
        {
            if ([[DZCUiapplication shareApplication].loginState isEqualToString:@"Y"])
            {
                
                NSLog(@"我的好友");
            }
            else
            {
                [MB_HUD show:YES];
                [MB_HUD setDetailsLabelText:@"您还没有登陆"];
                [MB_HUD hide:YES afterDelay:1.5];
            }
        }
            break;
            
        case 4://关于E流
        {
            NSLog(@"关于一流");
        }
            break;
        case 5://检查更新
        {
            NSLog(@"检查更新");
        }
            break;
        default:
            break;
    }
}
#pragma mark 点击登陆
-(void)LoginTap
{
    NSLog(@"登陆");
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginViewController=[main instantiateViewControllerWithIdentifier:@"dzcloginView"];
    LFNavigationController *nav=[[LFNavigationController alloc]initWithRootViewController:loginViewController];
    [self presentViewController:nav animated:YES completion:nil];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
