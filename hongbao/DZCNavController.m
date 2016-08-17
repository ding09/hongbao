//
//  DZCNavController.m
//  hongbao
//
//  Created by li wei on 16/8/16.
//  Copyright © 2016年 li wei. All rights reserved.
//

#import "DZCNavController.h"

@interface DZCNavController ()

@end

@implementation DZCNavController
-(void)DZCCancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self=[super initWithRootViewController:rootViewController];
    if (self)
    {
        UIBarButtonItem *LeftItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(DZCCancelAction)];
        
        rootViewController.navigationItem.leftBarButtonItem=LeftItem;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(BOOL)shouldAutorotate
{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
