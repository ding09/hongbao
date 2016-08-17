//
//  DZCRegisterViewController.h
//  hongbao
//
//  Created by li wei on 16/8/11.
//  Copyright © 2016年 li wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZCRegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *dzcCountNumber;
@property (weak, nonatomic) IBOutlet UITextField *dzcPassWord;
@property (weak, nonatomic) IBOutlet UITextField *dzcConfirmPassWord;
@property (weak, nonatomic) IBOutlet UITextField *dzcCallCode;

- (IBAction)dzcRegisterAction:(UIButton *)sender;
@end
