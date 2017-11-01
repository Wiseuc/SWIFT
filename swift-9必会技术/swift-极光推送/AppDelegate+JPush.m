//
//  AppDelegate+JPush.m
//  WiseUC
//
//  Created by JH on 2017/8/31.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import "AppDelegate+JPush.h"
#import "UserManager.h"
#import "NSData+NSData2NSString.h"


extern NSString * const kJPFNetworkIsConnectingNotification; // 正在连接中
extern NSString * const kJPFNetworkDidSetupNotification; // 建立连接
extern NSString * const kJPFNetworkDidCloseNotification; // 关闭连接
extern NSString * const kJPFNetworkDidRegisterNotification; // 注册成功
extern NSString * const kJPFNetworkFailedRegisterNotification; //注册失败
extern NSString * const kJPFNetworkDidLoginNotification; // 登录成功
extern NSString * const kJPFNetworkDidReceiveMessageNotification; // 收到自定义消息(非APNs)
static NSInteger seq = 0;


@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end


@implementation AppDelegate (JPush)

/**
 * 序列号
 */
- (NSInteger)seq
{
    return ++ seq;
}
/**
 * 标记Tag
 */
-(NSSet<NSString *> *)tags {
    NSArray * tagsList = @[@"groupA",@"groupB"];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"没有输入tags,请使用逗号作为tags分隔符"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil, nil];
    [alert show];
    NSMutableSet * tags = [[NSMutableSet alloc] init];
    [tags addObjectsFromArray:tagsList];
    return tags;
}



-(void)addAllNotification
{
    //连接上极光服务器
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(xxxxxx)
                                                 name:kJPFNetworkIsConnectingNotification
                                               object:nil];
    //通知打开
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(xxxxxx)
                                                 name:kJPFNetworkDidSetupNotification
                                               object:nil];
    //通知关闭
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(xxxxxx)
                                                 name:kJPFNetworkDidCloseNotification
                                               object:nil];
    
    //注册成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(xxxxxx)
                                                 name:kJPFNetworkDidRegisterNotification
                                               object:nil];
    //注册失败
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(xxxxxx)
                                                 name:kJPFNetworkFailedRegisterNotification
                                               object:nil];
    //登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(xxxxxx)
                                                 name:kJPFNetworkDidLoginNotification
                                               object:nil];
    //接收到消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(xxxxxx)
                                                 name:kJPFNetworkDidReceiveMessageNotification
                                               object:nil];
}


-(void)xxxxxx
{
    NSLog(@"其他通知");
}



/*
 *自定义参数描述：
 
 *content：获取推送的内容
 *extras：获取用户自定义参数
 *customizeField1：根据自定义key获取自定义的value
 */
//-(void)kJPFNetworkDidReceiveMessageNotificationAction:(NSNotification *)notification
//{
//    NSLog(@"收到通知");
//    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
//
//    NSLog(@"content0        = %@",content);
//    NSLog(@"extras0         = %@",extras);
//    NSLog(@"customizeField0 = %@",customizeField1);
//}







-(void)settingJPush
{
    //通知
    [self addAllNotification];
    
    //ios10请求权限
    if (IS_OS_10_OR_LATER) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:  UNAuthorizationOptionBadge
                                                | UNAuthorizationOptionSound
                                                | UNAuthorizationOptionAlert
                                                | UNAuthorizationOptionCarPlay
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (granted)
                                  {
                                      NSLog(@"请求成功");
                                  } else {
                                      NSLog(@"请求失败: %@",error.localizedDescription);
                                  }
                              }];
    }
    
    /*!
     * @abstract 开启Crash日志收集
     *
     * @discussion 默认是关闭状态.
     */
//    #ifdef DEBUG
//    
//    #else
//        [JPUSHService crashLogON];
//    #endif
    
    //初始化APNs
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    /*
     *初始化JPush
     *
     *appKey: 填写管理Portal上创建应用后自动生成的AppKey值
     *channel:应用程序包的下载渠道
     *apsForProduction:当前应用所使用的APNs证书环境(0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用。)
     *advertisingIdentifier:详见关于IDFA https://docs.jiguang.cn/jpush/client/iOS/ios_guide_new/#_8
     */
    BOOL apsForProduction = NO;
    #ifdef DEBUG
       apsForProduction = NO;
    #else
       apsForProduction = YES;
    #endif
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [JPUSHService setupWithOption:self.launchOptions
                           appKey:@"38cc2f97d842a0eca6390aa2"
                          channel:@"App Store"
                 apsForProduction:apsForProduction
            advertisingIdentifier:advertisingId];
    //2.1.9版本新增获取<registration id>的接口。   1a1018970a9ca2e6dba
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"获取成功registrationID = %@",registrationID);
        }else{
            NSLog(@"获取失败registrationID，code = %d",resCode);
        }
    }];
    // 放在登录成功
    // 删除放在注销
    //[self JPush_setAlias];
}





/*
 *别名Alias
 *
 *Alias:别名
 *iResCode：结果编号
 *iAlias：返回别名
 *seq：序列号
 */
- (void)JPush_setAlias{
    //应该在登录成功之后设置别名 江海@wiseuc
    NSString *jid = UserManager.shareInstance.currentUser.jid;
    [JPUSHService setAlias:jid completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
    } seq:[self seq]];
}
- (void)JPush_deleteAlias {
    //注销后调用
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
    } seq:[self seq]];
}
- (void)JPush_getAlias {
    [JPUSHService getAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:[self seq]];
}







/*
 *标记Tag
 *
 *
 */
- (void)addTags {
    [JPUSHService addTags:[self tags] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
    } seq:[self seq]];
}
- (void)setTags{
    [JPUSHService setTags:[self tags] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
    } seq:[self seq]];
}
- (void)getAllTags {
    [JPUSHService getAllTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
    } seq:[self seq]];
}
- (void)deleteTags {
    [JPUSHService deleteTags:[self tags] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
    } seq:[self seq]];
}
- (void)cleanTags {
    [JPUSHService cleanTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
    } seq:[self seq]];
}
- (void)vaildTag{
    [JPUSHService validTag:[[self tags] anyObject] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq, BOOL isBind) {
    } seq:[self seq]];
}








/*
 *注册APNS成功并上报DeviceToken<这里是极光推送服务器>
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    AppDelegateInstance.apnsToken = [deviceToken getTokenStr];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_GetAPNsToken object:nil];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //NSLog(@"远程推送注册失败: %@", error);
    JIANGHAI_LOG(@"远程推送注册失败: %@", error)
}








//APNS通知

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    //远程推送会走这里，但只是活跃状态走，后台状态不走
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionAlert);
}
// iOS 10 Support//用户点击了通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}









//必须：万一极光不可用，可重新使用APNs系统推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7及以上
    //利用极光实现精准推送，在这里我们将userInfo进行处理
    JIANGHAI_LOG(@"===%@",userInfo);
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,iOS6及以下
    //利用极光实现精准推送，在这里我们将userInfo进行处理
    JIANGHAI_LOG(@"===%@",userInfo);
    
    [JPUSHService handleRemoteNotification:userInfo];
}


@end
