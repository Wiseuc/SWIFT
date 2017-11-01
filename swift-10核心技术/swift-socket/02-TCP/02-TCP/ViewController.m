//
//  ViewController.m
//  02-TCP
//
//  Created by vera on 16/10/14.
//  Copyright © 2016年 deli. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
#import "DDXML.h"

//主机地址
#define kHostName @"10.20.161.179"
//IP地址
#define kHostPort 54321

@interface ViewController ()<GCDAsyncSocketDelegate>
{
    //套接字
    GCDAsyncSocket *_tcpSocket;
}
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@end

@implementation ViewController
/*
 <chat to=xx>
 <message>111</message>
 <chat>
 */


/*
 <message to = "test1@xxx">
 <body>你好</body>
 </message>
 */


- (IBAction)sendButtonClick:(id)sender
{
    NSString *text = _textfield.text;
    
    DDXMLElement *message = [DDXMLElement elementWithName:@"message"];
    
    DDXMLElement *body = [DDXMLElement elementWithName:@"body" stringValue:text];
    //添加子元素
    [message addChild:body];
    
    DDXMLNode *toNode = [DDXMLNode attributeWithName:@"to" stringValue:@"test1@163.com"];
    
    [message addAttribute:toNode];
    //发送
    [_tcpSocket writeData:[[message description] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    //继续读
    [_tcpSocket readDataWithTimeout:-1 tag:0];
}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.textfield.text = @"你好！";
    //初始化socket对象
    _tcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //连接服务器
    [_tcpSocket connectToHost:kHostName onPort:kHostPort error:nil];
}







#pragma mark - GCDAsyncSocketDelegate
//已经连接
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"已经建立和服务器的连接");
}
//断开连接
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error
{
    NSLog(@"断开连接 -- %@",error);
}
//已经接收数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"收到服务器数据：%@",[[NSString alloc] initWithData:data encoding:4]);
}

@end
