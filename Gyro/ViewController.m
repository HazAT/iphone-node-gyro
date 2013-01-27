//
//  ViewController.m
//  Gyro
//
//  Created by Daniel Griesser on 27.01.13.
//  Copyright (c) 2013 Daniel Griesser. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	socketIO = [[SocketIO alloc] initWithDelegate:self];
    //socketIO.useSecure = YES;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/60) target:self selector:@selector(sendGyroData) userInfo:nil repeats:YES];
    
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 1.0/60;
    [motionManager startDeviceMotionUpdates];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
-(void)sendGyroData
{
    CMDeviceMotion *motion = motionManager.deviceMotion;
    CMAttitude *attitude = motion.attitude;
    
    CMQuaternion quat = attitude.quaternion;
    GLKQuaternion q = GLKQuaternionMake(quat.x, quat.y, quat.z, quat.w);
    
    GLKQuaternion rq = GLKQuaternionMakeWithAngleAndAxis(DEGREES_TO_RADIANS(-90), 1, 0, 0);
    
    q = GLKQuaternionMultiply(rq, q);
    
    GLKVector3 axis = GLKQuaternionAxis(GLKQuaternionInvert(q));
    
    NSString *x = [NSString stringWithFormat:@"%f", axis.v[0]];
    
    NSString *y = [NSString stringWithFormat:@"%f", -axis.v[1]];
    
    NSString *z = [NSString stringWithFormat:@"%f", axis.v[2]];
    
    NSString *w = [NSString stringWithFormat:@"%f", GLKQuaternionAngle(q)];
    
    NSDictionary *dic = (@{@"x": x, @"y" : y, @"z" : z, @"w" : w});
    
    if ([socketIO isConnected])
    {
        self.status.text = @"Connected";
        self.status.textColor = [UIColor greenColor];
        [socketIO sendEvent:@"move" withData:dic andAcknowledge:nil];
    }
    else
    {
        self.status.text = @"Disconnected";
        self.status.textColor = [UIColor redColor];
    }
}


-(IBAction)reconnect:(id)sender
{
    [self.url resignFirstResponder];
    [self.port resignFirstResponder];
    //socketIO.useSecure = YES;
    [socketIO connectToHost:self.url.text onPort:[self.port.text integerValue]];
}


- (void)viewDidUnload {
    [self setPort:nil];
    [self setStatus:nil];
    [super viewDidUnload];
}


@end
