//
//  DZCLoginViewController.m
//  hongbao
//
//  Created by li wei on 16/8/11.
//  Copyright © 2016年 li wei. All rights reserved.
//

#import "DZCLoginViewController.h"

@interface DZCLoginViewController ()

@end

@implementation DZCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)DZCLoginAction:(UIButton *)sender {
    DLog(@"点击登录按钮");
    /*
    UIStoryboard *main=[UIStoryboard  storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tab=[main instantiateViewControllerWithIdentifier:@"dzchometab"];
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    window.rootViewController=tab;
     */
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dzcCancelLogin:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
