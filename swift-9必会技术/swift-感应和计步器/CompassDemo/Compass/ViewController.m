//
//  ViewController.m
//  Compass
//
//  Created by Hey Eleven on 16/5/10.
//  Copyright © 2016年 Eleven Yao. All rights reserved.
//

#define kWidth self.view.frame.size.width
#define kHeight self.view.frame.size.height

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()<CLLocationManagerDelegate> {
    
    //定位服务
    CLLocationManager   *_lm;
    
    //重力感应
    CMMotionManager     *_cmm;
    
    //计步
    CMPedometer         *_stepCounter;
    
    NSOperationQueue    *_queue;
    
    UIImageView         *_compassImageView;
    
    UILabel             *_stepCountLabel;
}

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_lm startUpdatingHeading];
    
//    [self startMagnetometerUpdate];
//    
//    [self startAccelerometerUpdate];
//    
//    [self startGyroUpdate];
//    
//    [self startListenProximity];
//    
//    [self startListenLevel];
    
    [self startPedometerUpdate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [self stopMagnetometerUpdate];
//    
//    [self stopAccelerometerUpdate];
//    
//    [self stopGyroUpdate];
//    
//    [self stopListenProximity];
//    
//    [self stopListenLevel];
}








- (void)viewDidLoad {
    [super viewDidLoad];
    
    _queue = [[NSOperationQueue alloc]init];
    
    _lm = [[CLLocationManager alloc]init];
    _lm.delegate = self;
    
    _cmm = [[CMMotionManager alloc]init];
    
    _stepCounter = [[CMPedometer alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"029"];
    _compassImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2 - 40, kHeight/2 - 150, 80, 300)];
    _compassImageView.image = image; 
    [self.view addSubview:_compassImageView];
    
    _stepCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kHeight - 50, kWidth, 50)];
    _stepCountLabel.text = @"开始统计行走步数";
    _stepCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_stepCountLabel];
}

#pragma mark  Magnetometer磁强仪
- (void)startMagnetometerUpdate {
    
    _cmm.magnetometerUpdateInterval = 1;
    
    if ([_cmm isMagnetometerAvailable] && ![_cmm isMagnetometerActive]) {
        
        [_cmm startMagnetometerUpdatesToQueue:_queue withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
            
            NSLog(@"magnetometer Data : %@", magnetometerData);
        }];
    }
}

- (void)stopMagnetometerUpdate {
    
    if ([_cmm isMagnetometerActive]) {
        
        [_cmm stopMagnetometerUpdates];
    }
}

#pragma mark  Accelerometer
- (void)startAccelerometerUpdate {
    
    _cmm.accelerometerUpdateInterval = 1;
    
    if ([_cmm isAccelerometerAvailable] && ![_cmm isAccelerometerActive]) {
        
        
        [_cmm startAccelerometerUpdatesToQueue:_queue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            
            NSLog(@"accelerometer Data : %@", accelerometerData);
        }];
    }else {
        
        NSLog(@"加速度传感器不可用");
    }
}

- (void)stopAccelerometerUpdate {
    
    if ([_cmm isAccelerometerActive]) {
        
        [_cmm stopAccelerometerUpdates];
    }
}

#pragma mark  Gyro
- (void)startGyroUpdate {
    
    _cmm.gyroUpdateInterval = 1;
    
    if ([_cmm isGyroAvailable] && ![_cmm isGyroActive]) {
        
        [_cmm startGyroUpdatesToQueue:_queue withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
            
            NSLog(@"gyro Data : %@", gyroData);
        }];
    }else {
        
        NSLog(@"陀螺仪不可用");
    }
}

- (void)stopGyroUpdate {
    
    if ([_cmm isGyroActive]) {
        
        [_cmm stopGyroUpdates];
    }
}

- (void)startPedometerUpdate {
    
    if ([CMPedometer isStepCountingAvailable]) {
       
        
        //计步
        [_stepCounter startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            
            _stepCountLabel.text = [NSString stringWithFormat:@"当前行走步数 : %@", pedometerData.numberOfSteps];
            NSLog(@"%@", pedometerData.numberOfSteps);
        }];
    }
}



#pragma mark  Proximity
- (void)startListenProximity {
    
    //靠近感应
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChanged) name:UIDeviceProximityStateDidChangeNotification object:nil];
}

- (void)stopListenProximity {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
}

- (void)proximityChanged {
    
    BOOL state = [[UIDevice currentDevice] proximityState];
    
    if (state) {
        NSLog(@"前方出现不明物体");
    }else {
        NSLog(@"一无所有");
    }
}

#pragma mark  Level
- (void)startListenLevel {
    
    //启动侦听电量的变化
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(levelChanged) name:UIDeviceBatteryLevelDidChangeNotification object:nil];
}

- (void)levelChanged {
    
    float deviceLevel = [UIDevice currentDevice].batteryLevel;
    
    if (deviceLevel < 0.2) {
       //  当设备电量少于20%时禁止某些操作 
    }
    NSLog(@"设备电量 : %.0f%%", deviceLevel*100);
}

- (void)stopListenLevel {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceBatteryLevelDidChangeNotification object:nil];
}














#pragma mark  CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    CGFloat rotation = -newHeading.magneticHeading/180 * M_PI;
    
    _compassImageView.transform = CGAffineTransformMakeRotation(rotation);
}

//  开始摇一摇
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    NSLog(@"开始摇一摇");
}

//  摇一摇被取消
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    NSLog(@"摇一摇被取消");
}

//  摇一摇停止
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    NSLog(@"摇一摇停止");
}

@end
