//
//  DangleSession.h
//  Dangle
//
//  Created by Me on 5/18/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import "Dangle.h"

@class DangleUser;

@interface DangleSession : NSObject <NSCoding>

+ (instancetype)sessionWithAuthenticationToken:(NSString *)authenticationToken user:(DangleUser *)user;

@property (nonatomic, readonly) NSString *authenticationToken;

@property (nonatomic, readonly) DangleUser *user;


@end
