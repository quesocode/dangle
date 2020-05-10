//
//  DangleDevice.m
//  Dangle
//
//  Created by Me on 5/11/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import "DangleDevice.h"


@interface DangleDevice ()
{
    BOOL _isPluggedIn;
    BOOL _isAvailable;
}
@property (nonatomic, retain) NSMutableArray *delegates;
@end

@implementation DangleDevice


+ (DangleDevice *) sharedDevice;
{
    static DangleDevice *_sharedDevice = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        _sharedDevice = [[[self class] alloc] init];
    });
    return _sharedDevice;
}




- (id) init;
{
    self = [super init];
    if(self)
    {
        self.delegates = [NSMutableArray array];
        [AVAudioSession sharedInstance];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)
                                                     name:AVAudioSessionRouteChangeNotification
                                                   object:nil];
    }
    return self;
}
- (NSString *) name;
{
    return @"DangleDeviceDebug";
}
- (NSString *) deviceID;
{
    return @"123456789";
}
- (BOOL) isPluggedIn;
{
#if !(TARGET_IPHONE_SIMULATOR)
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
#else
    DLog(@"Device running simulator");
    return YES;
#endif
    
}
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"AVAudioSessionRouteChangeReasonNewDeviceAvailable");
            NSLog(@"Headphone/Line plugged in");
            for (id <DangleDeviceDelegate> d in self.delegates) {
                [d dangleDevicePluggedIn:self];
            }
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            NSLog(@"AVAudioSessionRouteChangeReasonOldDeviceUnavailable");
            NSLog(@"Headphone/Line was pulled. Stopping player....");
            for (id <DangleDeviceDelegate> d in self.delegates) {
                [d dangleDeviceUnplugged:self];
            }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            for (id <DangleDeviceDelegate> d in self.delegates) {
                if([d respondsToSelector:@selector(dangleDeviceChangedStatus:)])
                {
                    [d dangleDeviceChangedStatus:self];
                }
            }
            break;
    }
}

#pragma mark - Delegate methods

- (void) addDelegate:(id <DangleDeviceDelegate>)delegate;
{
    if(delegate) [self.delegates addObject:delegate];
}
- (void) removeDelegate:(id <DangleDeviceDelegate>)delegate;
{
    if([self.delegates containsObject:delegate]) [self.delegates removeObject:delegate];
}
- (void) removeAllDelegates;
{
    self.delegates = [NSMutableArray array];

}



@end
