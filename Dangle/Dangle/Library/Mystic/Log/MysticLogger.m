//
//  MysticLogger.m
//  Mystic
//
//  Created by Me on 3/26/15.
//  Copyright (c) 2015 Blackpulp. All rights reserved.
//

#import "MysticLogger.h"

@implementation MysticLogger

+ (void) setupLogger;
{
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithRed:0.37 green:0.35 blue:0.33 alpha:1] backgroundColor:nil forFlag:DDLogFlagInfo];
}
- (id)init {
    if((self = [super init])) {
        threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
//        [threadUnsafeDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
        [threadUnsafeDateFormatter setDateFormat:@"hh:mm:ss:SSS"];

    }
    return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *dateColor = LOG_HIDDEN_COLOR;
    NSString *msgColor;
    NSString *bgColor = nil;
    NSString *logMsg = logMessage->_message;
    NSString *prefix=@"";
    NSString *suffix = @"";
    switch ((NSUInteger)logMessage->_flag) {
        case MLogFlagError : { msgColor = (LOG_RED_COLOR); dateColor=msgColor; break; }
        case MLogFlagWarning  : { msgColor = (LOG_YELLOW_COLOR); dateColor=msgColor; break; }
        case MLogFlagInfo  : { msgColor = @"fg241,234,224;"; break; }
        case MLogFlagDebug : { msgColor = (LOG_BLUE_COLOR); dateColor=msgColor; break; }
        case MLogFlagHidden : { msgColor = LOG_HIDDEN_COLOR /*@"fg81,81,80;"*/; break; }
        case MLogFlagRender : { msgColor = (LOG_PURPLE_COLOR); break; }
        case MLogFlagMemory : { msgColor = @"fg255,255,255;"; dateColor=@"fg212,116,116;"; bgColor=@"bg172,55,55;";
            logMsg = [logMsg stringByAppendingString:@"    "];
//            prefix = @"\n\n"; suffix=prefix;
            break; }
        default             : { msgColor = @"fg145,143,141;"; break; }
    }
    
    NSString *dateAndTime = [threadUnsafeDateFormatter stringFromDate:(logMessage->_timestamp)];
    BOOL hasBreaks = [logMsg containsString:@"\n"];
    if(hasBreaks)
    {
        logMsg = [logMsg stringByReplacingOccurrencesOfString:@"\n" withString:[NSString stringWithFormat:(XCODE_COLORS_RESET_FG @"\n" XCODE_COLORS_ESCAPE @"%@              █    " XCODE_COLORS_RESET_FG XCODE_COLORS_ESCAPE @"%@"), dateColor, msgColor]];
        logMsg = [logMsg stringByAppendingString:@"\n\n\n"];
    }
    logMsg = [logMsg stringByReplacingOccurrencesOfString:@"NO" withString:[NSString stringWithFormat:(XCODE_COLORS_RESET_FG XCODE_COLORS_ESCAPE LOG_RED_COLOR @"NO" XCODE_COLORS_RESET_FG XCODE_COLORS_ESCAPE @"%@"), msgColor]];
    logMsg = [logMsg stringByReplacingOccurrencesOfString:@"YES" withString:[NSString stringWithFormat:(XCODE_COLORS_RESET_FG XCODE_COLORS_ESCAPE LOG_GREEN_COLOR @"YES" XCODE_COLORS_RESET_FG XCODE_COLORS_ESCAPE @"%@"), msgColor]];


    if(bgColor)
    {
        return [NSString stringWithFormat:(XCODE_COLORS_ESCAPE @"%@"   @"%@" XCODE_COLORS_ESCAPE "%@ %@ █" XCODE_COLORS_RESET_FG XCODE_COLORS_ESCAPE @"%@    %@" XCODE_COLORS_RESET @"%@"), prefix, bgColor, dateColor, dateAndTime, msgColor, logMsg, suffix];

    }
    return [NSString stringWithFormat:(XCODE_COLORS_ESCAPE @"%@"  @"%@ %@ █" XCODE_COLORS_RESET XCODE_COLORS_ESCAPE @"%@    %@" XCODE_COLORS_RESET @"%@" ), prefix, dateColor, dateAndTime, msgColor, logMsg, suffix];
}

- (void)didAddToLogger:(id <DDLogger>)logger {
    loggerCount++;
    NSAssert(loggerCount <= 1, @"This logger isn't thread-safe");
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger {
    loggerCount--;
}



@end
