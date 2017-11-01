//
//  AppDelegate+JPush.h
//  WiseUC
//
//  Created by JH on 2017/8/31.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import "AppDelegate.h"

//======================================================//
// JPushSDK
//======================================================//

#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <AdSupport/AdSupport.h> //IDFA





@interface AppDelegate (JPush)<JPUSHRegisterDelegate>

//初始化设置
-(void)settingJPush;

//别名
- (void)JPush_setAlias;
- (void)JPush_deleteAlias;
- (void)JPush_getAlias;
    
@end
