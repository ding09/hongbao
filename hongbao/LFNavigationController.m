//
//  LFNavigationController.m
//  movie
//
//  Created by li wei on 15/10/17.
//  Copyright (c) 2015年 li wei. All rights reserved.
//

#import "LFNavigationController.h"

@interface LFNavigationController ()

@end

@implementation LFNavigationController

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self=[super initWithRootViewController:rootViewController];
    
    [self.navigationBar setBarTintColor:[UIColor colorWithRed:0.0 green:177.0/255 blue:255.0/255.0 alpha:1.0]];
    //统一设置导航栏颜色
    UINavigationBar *bar=[UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    [bar setTitleTextAttributes:@{
                                  NSForegroundColorAttributeName :[UIColor whiteColor]
                                  }];
    
    
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldAutorotate
{
    return NO;
}
////横屏
//- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    return (toInterfaceOrientation == UIInterfaceOrientationMaskPortrait);
//
//}
/*
- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}
 */
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
/*
-(UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}
*/
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
