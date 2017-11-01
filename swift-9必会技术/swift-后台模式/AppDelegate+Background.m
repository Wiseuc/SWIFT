//
//  AppDelegate+Background.m
//  WiseUC
//
//  Created by 吴林峰 on 15/12/15.
//  Copyright © 2015年 WiseUC. All rights reserved.
//

#import "AppDelegate+Background.h"
#import "List.h"
#import "Macros.h"

@implementation AppDelegate (Background)

- (void)settingBackgroundTask
{
//    if ( IS_IOS8 ) {
//        UIUserNotificationType myType = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//        UIUserNotificationSettings *mySetting = [UIUserNotificationSettings settingsForTypes:myType categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:mySetting];
//    }
//    else {
//        UIRemoteNotificationType myType = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myType];
//    }
}

- (void)startBackgroundTask
{
    self.backgroundTask =[[BackgroundTask alloc] init];
    
    //Star the timer
    [self.backgroundTask startBackgroundTasks:180-2 target:self selector:@selector(backgroundCallback:)];
}

- (void)stopBackgroundTask {
    //Stop the task
    [self.backgroundTask stopBackgroundTask];
}

- (void)backgroundCallback:(id)info
{
//    [UIApplication sharedApplication].applicationIconBadgeNumber = [Conversation unreadMessagesCount];
    NSLog(@"进入后台");
}

- (void)localNotification:(NSString *)noti
{
    // 创建本地通知
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    // 设置什么时间弹出
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.5];
    
    // 设置弹出的内容
    localNote.alertBody = noti;
    
    // 设置锁屏状态下,显示的一个文字
    localNote.alertAction = @"查看";
    //   localNote.hasAction = YES;
    // 设置音效
    localNote.soundName = UILocalNotificationDefaultSoundName;
    //localNote.soundName = @"msg.caf";
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}

@end
