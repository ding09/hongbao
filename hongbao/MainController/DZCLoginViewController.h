//
//  DZCLoginViewController.h
//  hongbao
//
//  Created by li wei on 16/8/11.
//  Copyright © 2016年 li wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZCLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *dzcCountNumber;

@property (weak, nonatomic) IBOutlet UITextField *dzcPassWord;
- (IBAction)DZCLoginAction:(UIButton *)sender;
- (IBAction)dzcCancelLogin:(UIBarButtonItem *)sender;
@end
