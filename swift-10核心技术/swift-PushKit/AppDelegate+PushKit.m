//
//  AppDelegate+PushKit.m
//  WiseUC
//
//  Created by JH on 2017/9/25.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import "AppDelegate+PushKit.h"
#import <PushKit/PushKit.h>
#import "PushKitManager.h"
#import "UserManager.h"

@interface AppDelegate ()<PKPushRegistryDelegate>

@end

@implementation AppDelegate (PushKit)

-(void)settingPushKitNotification {
    //获取apnsToken
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getpushkitInfo)
                                                 name:kNotification_GetAPNsToken
                                               object:nil];
    //获取VoIPToken
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getpushkitInfo)
                                                 name:kNotification_GetVoIPToken
                                               object:nil];
    //登录成功，pid
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getpushkitInfo)
                                                 name:Wiseuc_Notification_LoginSuccess
                                               object:nil];
}

-(void)getpushkitInfo{
    
    
    //如果时iLinux服务器，则没有语音视频功能
    if (!LoginManager.shareHelper.isLinux) {
        return;
    }
    
    if(self.apnsToken == nil || [self.apnsToken  isEqual: @""] ||
       self.voipToken == nil || [self.voipToken  isEqual: @""] ||
       self.pidToken  == nil || [self.pidToken  isEqual:  @""]  )
    {
        return;
    }
    NSLog(@"//==========================message=============================//");
    NSLog(@"apnsToken: %@",self.apnsToken);
    NSLog(@"voipToken: %@",self.voipToken);
    NSLog(@"pidToken:  %@",self.pidToken);
    NSLog(@"//==========================message=============================//");
    
    
    /*
     
     */
    
    [PushKitManager.defaultManager settingPushKitManagerWithAPNsToken:self.voipToken
                                                            VoIPToken:self.voipToken
                                                             platform:@(1)
                                                             serverip:UserManager.shareInstance.currentUser.serverIP
                                                           serverPort:UserManager.shareInstance.currentUser.serverPort
                                                             voipPort:@"25060"
     
                                                             username:UserManager.shareInstance.currentUser.username
                                                             password:UserManager.shareInstance.currentUser.password
                                                   registerIdentifies:UserManager.shareInstance.currentUser.pid
                                                            transport:@"tcp"];
    
}









-(void)settingPushKit
{
    //添加通知
    [self settingPushKitNotification];
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    PKPushRegistry * voipRegistry = [[PKPushRegistry alloc] initWithQueue: mainQueue];
    voipRegistry.delegate = self;
    voipRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

//获取voipToken
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type
{
    NSString *str = [NSString stringWithFormat:@"%@",credentials.token];
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSString *voipTokenStr = [str2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.voipToken = voipTokenStr;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_GetVoIPToken object:nil];
}
- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type
{
    // 收到推送来电
    // 呼出系统接听界面
    // 或者生成本地推送
    JIANGHAI_LOG(@"//===============收到VoIP推送==================//")
}


#pragma clang diagnostic pop






@end
