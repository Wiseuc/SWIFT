//
//  ViewController.m
//  03-UDP
//
//  Created by vera on 16/10/14.
//  Copyright © 2016年 deli. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncUdpSocket.h"

@interface ViewController ()<GCDAsyncUdpSocketDelegate>
{
    //发送方
    GCDAsyncUdpSocket *_sendSocket;
    
    //接收方
    GCDAsyncUdpSocket *_receiveSocket;
}

@end

@implementation ViewController

- (IBAction)sendData:(id)sender
{
    //10.20.161.179 : 54321
    
    //发送数据
    [_sendSocket sendData:[@"hello world" dataUsingEncoding:NSUTF8StringEncoding] toHost:@"10.20.161.179" port:54321 withTimeout:-1 tag:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //发送方
    _sendSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //绑定端口
    [_sendSocket bindToPort:12345 error:nil];
    //接收方
    _receiveSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //绑定端口
    [_receiveSocket bindToPort:54321 error:nil];
    //接收侦听数据
    [_receiveSocket beginReceiving:nil];
    
}





#pragma mark - GCDAsyncUdpSocketDelegate
/**
 收到对方发来的数据会触发
 */
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    if (sock == _receiveSocket)
    {
        NSString *hostName;
        uint16_t hostPort;
        //获取发送方的IP和端口
        [GCDAsyncUdpSocket getHost:&hostName port:&hostPort fromAddress:address];
        
        NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"收到发送方%@:%d的数据：%@",hostName,hostPort,message);
    }
}




@end
