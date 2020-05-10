//
//  DangleSession.m
//  Dangle
//
//  Created by Me on 5/18/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import "DangleSession.h"

@implementation DangleSession

+ (instancetype)sessionWithAuthenticationToken:(NSString *)authenticationToken user:(DangleUser *)user
{
    NSParameterAssert(authenticationToken);
    NSParameterAssert(user);
    return [[self alloc] initWithAuthenticationToken:authenticationToken user:user];
}

- (id)initWithAuthenticationToken:(NSString *)authenticationToken user:(DangleUser *)user
{
    self = [super init];
    if (self) {
        _authenticationToken = authenticationToken;
        _user = user;
    }
    return self;
}

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Failed to call designated initializer." userInfo:nil];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    NSString *authenticationToken = [decoder decodeObjectForKey:NSStringFromSelector(@selector(authenticationToken))];
    DangleUser *user = [decoder decodeObjectForKey:NSStringFromSelector(@selector(user))];
    return [self initWithAuthenticationToken:authenticationToken user:user];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.authenticationToken forKey:NSStringFromSelector(@selector(authenticationToken))];
    [encoder encodeObject:self.user forKey:NSStringFromSelector(@selector(user))];
}

#pragma mark - NSObject

- (NSUInteger)hash
{
    return self.authenticationToken.hash ^ self.user.participantIdentifier.hash;
}

- (BOOL)isEqual:(id)object
{
    if (!object) return NO;
    if (![object isKindOfClass:[DangleSession class]]) return NO;
    DangleSession *otherSession = object;
    if (![self.authenticationToken isEqualToString:otherSession.authenticationToken]) return NO;
    if (![self.user isEqual:otherSession.user]) return NO;
    return YES;
}


@end
