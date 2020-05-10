//
//  DangleChatroom.m
//  Dangle
//
//  Created by Me on 5/15/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import "DangleChatroom.h"

@implementation DangleChatroom

+ (instancetype) activeRoom;
{
    static DangleChatroom *_sharedObj = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        _sharedObj = [[[self class] alloc] init];
    });
    return _sharedObj;
}

- (id) init;
{
    self = [super init];
    if(self)
    {
        self.info = @{@"users":@{}};
    }
    return self;
}

- (NSString *) conversationID;
{
    return self.info ? self.info[@"conversation"] : nil;
}
- (NSDictionary *) usersData;
{
    return self.info ? self.info[@"users"] : [NSDictionary dictionary];
}

- (void) setRoomInfo:(NSDictionary *)info;
{
    if(info)
    {
        self.info = info;
    }
    else
    {
        self.info = @{@"users":@{}};
    }
}
@end
