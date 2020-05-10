//
//  MysticLogger.h
//  Mystic
//
//  Created by Me on 3/26/15.
//  Copyright (c) 2015 Blackpulp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>


typedef NS_OPTIONS(NSUInteger, MLogFlag) {
    MLogFlagFatal       = (1 << 0),
    MLogFlagError       = (1 << 1),
    MLogFlagWarning     = (1 << 2),
    MLogFlagInfo        = (1 << 3),
    MLogFlagDebug       = (1 << 4),
    
    MLogFlagHidden      = (1 << 5), // 0...00001
    MLogFlagRender      = (1 << 6), // 0...00010
    MLogFlagMemory      = (1 << 7), // 0...00100
};


@interface MysticLogger : NSObject <DDLogFormatter> {
    int loggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}
+ (void) setupLogger;

@end