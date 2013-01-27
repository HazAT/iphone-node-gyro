//
//  ViewController.h
//  Gyro
//
//  Created by Daniel Griesser on 27.01.13.
//  Copyright (c) 2013 Daniel Griesser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"
#import <CoreMotion/CoreMotion.h>
#import <GLKit/GLKit.h>

@interface ViewController : UIViewController <SocketIODelegate>
{
    SocketIO *socketIO;
    CMMotionManager *motionManager;
    NSTimer *timer;
}

@property (strong, nonatomic) IBOutlet UITextField *url;
@property (strong, nonatomic) IBOutlet UITextField *port;
@property (strong, nonatomic) IBOutlet UILabel *status;


-(IBAction)reconnect:(id)sender;


@end
