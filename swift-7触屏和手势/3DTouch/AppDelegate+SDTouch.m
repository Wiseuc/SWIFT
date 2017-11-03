//
//  AppDelegate+SDTouch.m
//  WiseUC
//
//  Created by JH on 2017/9/1.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import "AppDelegate+SDTouch.h"

@implementation AppDelegate (SDTouch)

-(void)setting3DTouch
{
    UIApplicationShortcutIcon *qrIcon        = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3DTouch_QRcode"];
    UIApplicationShortcutIcon *addFriendIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3DTouch_addFriend"];
    UIApplicationShortcutIcon *shareIcon     = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3DTouch_share"];
    
    
    
    UIApplicationShortcutItem *qrItem = [[UIApplicationShortcutItem alloc]initWithType:@"com.wiseuc.qr"
                                                                            localizedTitle:@"扫一扫"
                                                                         localizedSubtitle:nil
                                                                                      icon:qrIcon
                                                                                  userInfo:nil];
    
    UIApplicationShortcutItem *addFriendItem = [[UIApplicationShortcutItem alloc]initWithType:@"com.wiseuc.addFriend"
                                                                         localizedTitle:@"加好友"
                                                                      localizedSubtitle:nil
                                                                                   icon:addFriendIcon
                                                                               userInfo:nil];


    NSString *bundleDisplayName =  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *title = [NSString stringWithFormat:@"分享“%@”",bundleDisplayName];
    UIApplicationShortcutItem *shareItem = [[UIApplicationShortcutItem alloc]initWithType:@"com.wiseuc.share"
                                                                          localizedTitle:title
                                                                       localizedSubtitle:nil
                                                                                    icon:shareIcon
                                                                                userInfo:nil];
    
    UIApplication.sharedApplication.shortcutItems = @[qrItem,         //扫一扫
                                                      addFriendItem,  //加好友
                                                      //shareItem       //分享 系统会自动加上
                                                    ];
    
    
    
    
    
    
}




-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
 completionHandler:(void (^)(BOOL))completionHandler
{
    if ([shortcutItem.type isEqualToString:@"com.wiseuc.qr"]) {
        NSLog(@"跳转到com.wiseuc.qr页面");
    }
    else if ([shortcutItem.type isEqualToString:@"com.wiseuc.addFriend"]) {
        NSLog(@"跳转到com.wiseuc.addFriend页面");
    }
    else if ([shortcutItem.type isEqualToString:@"com.wiseuc.share"]) {
        NSLog(@"跳转到com.wiseuc.share页面");
    }
}




@end
