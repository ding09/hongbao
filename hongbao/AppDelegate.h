//
//  AppDelegate.h
//  hongbao
//
//  Created by li wei on 16/8/4.
//  Copyright © 2016年 li wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JOYConnect.h"
#import "Reachability.h"
@class HTTPServer;
@interface AppDelegate : UIResponder <UIApplicationDelegate,JOYConnectDelegate>
{
    HTTPServer *httpServer;
    Reachability *hostReach;
}
@property (strong, nonatomic) UIWindow *window;


@end

