//
//  AppDelegate+Background.h
//  WiseUC
//
//  Created by 吴林峰 on 15/12/15.
//  Copyright © 2015年 WiseUC. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Background)

- (void)settingBackgroundTask;

- (void)startBackgroundTask;

- (void)stopBackgroundTask;

- (void)localNotification:(NSString *)noti;

@end
