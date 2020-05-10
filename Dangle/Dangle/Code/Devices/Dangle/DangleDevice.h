//
//  DangleDevice.h
//  Dangle
//
//  Created by Me on 5/11/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Dangle.h"

@class DangleDevice;

@protocol DangleDeviceDelegate <NSObject>

@required
- (void) dangleDevicePluggedIn:(DangleDevice *)device;
- (void) dangleDeviceUnplugged:(DangleDevice *)device;

@optional
- (void) dangleDeviceChangedStatus:(DangleDevice *)device;

@end


@interface DangleDevice : NSObject

@property (nonatomic, readonly) BOOL isPluggedIn;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *deviceID;

+ (DangleDevice *) sharedDevice;
- (void) addDelegate:(id <DangleDeviceDelegate>)delegate;
- (void) removeDelegate:(id <DangleDeviceDelegate>)delegate;


@end
