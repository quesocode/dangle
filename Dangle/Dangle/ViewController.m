//
//  ViewController.m
//  Dangle
//
//  Created by Travis Weerts on 5/7/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import "ViewController.h"
#import "DangleChatViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIButton *noDangleButton;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [[DangleDevice sharedDevice] addDelegate:self];

    [self dangleDevicePluggedIn:[DangleDevice sharedDevice]];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - DangleDeviceDelegate

- (void) dangleDevicePluggedIn:(DangleDevice *)device;
{
    ALog(@"Dangle Device Plugged In", @[@"Device", device.name,
                                        @"Device ID", device.deviceID,
                                        @"Plugged", MBOOL(device.isPluggedIn),
                                        @""]);
    if(device.isPluggedIn)
    {
        self.messageLabel.text = @"Dangle Plugged In!";
        [NSTimer wait:0.15 block:^{
            [self pluggedIn];

        }];
    }
    else
    {
        self.messageLabel.text = @"Please plug in Dangle...";
        
    }
}
- (void) dangleDeviceUnplugged:(DangleDevice *)device;
{
    ALog(@"Dangle Device Unplugged", @[@"Device", device.name,
                                       @"Device ID", device.deviceID,
                                       @"Plugged", MBOOL(device.isPluggedIn),
                                       @""]);
    
    
    if(!device.isPluggedIn)
    {
        self.messageLabel.text = @"Dangle Unplugged...";
    }
    else
    {
        self.messageLabel.text = @"Please plug in Dangle...";
        
    }
    
}

#pragma mark - Success & Connect

- (void) pluggedIn;
{
    self.messageLabel.text = @"Connecting...";
    [self performSegueWithIdentifier:@"gotoChat" sender:self];

//    [DangleAPI connect:^(BOOL success, NSError *error) {
//       
//        ALog(@"Dangle API:connect:", @[@"success", MBOOL(success),
//                                       @"error", MObj(error),
//                                       @"-",
//                                       @"user", MObj([DangleUser user]),
//                                       ]);
//        if(success)
//        {
//            self.messageLabel.text = @"Connected!";
//            [self performSegueWithIdentifier:@"gotoChat" sender:self];
//            
//        }
//        else
//        {
//            self.messageLabel.text = @"Can't connect?";
//        }
//        
//    }];
}

@end
