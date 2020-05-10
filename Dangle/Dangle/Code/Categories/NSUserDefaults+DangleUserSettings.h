//
//  NSUserDefaults+DangleUserSettings.h
//  Dangle
//
//  Created by Me on 5/15/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (DangleUserSettings)

+ (void)saveExtraMessagesSetting:(BOOL)value;
+ (BOOL)extraMessagesSetting;

+ (void)saveLongMessageSetting:(BOOL)value;
+ (BOOL)longMessageSetting;

+ (void)saveEmptyMessagesSetting:(BOOL)value;
+ (BOOL)emptyMessagesSetting;

+ (void)saveSpringinessSetting:(BOOL)value;
+ (BOOL)springinessSetting;

+ (void)saveOutgoingAvatarSetting:(BOOL)value;
+ (BOOL)outgoingAvatarSetting;

+ (void)saveIncomingAvatarSetting:(BOOL)value;
+ (BOOL)incomingAvatarSetting;


@end
