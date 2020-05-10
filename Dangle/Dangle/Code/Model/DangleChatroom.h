//
//  DangleChatroom.h
//  Dangle
//
//  Created by Me on 5/15/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DangleChatroom : NSObject
+ (instancetype) activeRoom;

@property (nonatomic, retain) NSDictionary *info;
@property (nonatomic, readonly) NSString *conversationID;
@property (nonatomic, readonly) NSDictionary *usersData;

- (void) setRoomInfo:(NSDictionary *)info;

@end
