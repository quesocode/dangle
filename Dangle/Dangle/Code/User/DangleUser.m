//
//  DangleUser.m
//  Dangle
//
//  Created by Me on 5/12/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import "DangleUser.h"
#import "DangleAPI.h"
#import "NSString+Mystic.h"

@implementation DangleUser

+ (DangleUser *) user;
{
    static DangleUser *_sharedObj = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        _sharedObj = [[[self class] alloc] init];
    });
    return _sharedObj;
}
+ (NSString *) deviceID;
{
#if !(TARGET_IPHONE_SIMULATOR)
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString].md5;
#else
    return [@"dangle-simulator-UDID" md5];
#endif
}

+ (instancetype)userFromDictionaryRepresentation:(NSDictionary *)representation
{
    DangleUser *user = [DangleUser new];
    user.userID =  representation[@"id"];
    user.firstName = representation[@"first_name"];
    if (!user.firstName) user.firstName = representation[@"name"];
    user.lastName = representation[@"last_name"];
    user.email = representation[@"email"];
    user.info = representation;
    return user;
}


+ (void) user:(void ( ^ ) ( DangleUser *user , BOOL firstTime, NSError *error))completion;
{
    if([DangleUser user].isReady)
    {
        completion([DangleUser user], NO, nil);
    }
    else
    {
        [DangleAPI registerUser:^(NSDictionary *response, NSError *error)
        {
            if(response)
            {
                DangleUser *user = [[self class] user];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDAUserFirstTime];
                [user setInfo:response[@"user"]];
                
                [[DangleChatroom activeRoom] setRoomInfo:response[@"chat"]];
                
                completion(user, YES, nil);
            }
            else
            {
                completion(nil, YES, error);
            }
        }];
    }
}
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.userID = [decoder decodeObjectForKey:NSStringFromSelector(@selector(userID))];
    self.name = [decoder decodeObjectForKey:NSStringFromSelector(@selector(name))];
    self.displayName = [decoder decodeObjectForKey:NSStringFromSelector(@selector(displayName))];
    self.email = [decoder decodeObjectForKey:NSStringFromSelector(@selector(email))];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.userID forKey:NSStringFromSelector(@selector(userID))];
    [encoder encodeObject:self.name forKey:NSStringFromSelector(@selector(name))];
    [encoder encodeObject:self.displayName forKey:NSStringFromSelector(@selector(displayName))];
    [encoder encodeObject:self.email forKey:NSStringFromSelector(@selector(email))];
}


- (id) init;
{
    self = [super init];
    if(self)
    {
#if !(TARGET_IPHONE_SIMULATOR)
        
#else
        self.userID = @"cJinsP"; // simulator ID
        self.name = @"Dangle App";
        self.displayName = @"Dangle";
        self.initials = @"D";
        self.email = @"app@dangle.io";
        
#endif
    }
    return self;
}
- (NSString *)participantIdentifier
{
    return self.userID;
}
- (NSString *)firstName
{
    return self.displayName;
}
- (NSString *)lastName
{
    return self.displayName;
}
- (NSString *)fullName
{
    return self.name;
}
- (UIImage *)avatarImage
{
    return self.thumbnail;
}
- (NSURL *)avatarImageURL
{
    return self.thumbnailURL;
}
- (NSUInteger)hash
{
    return self.userID.hash;
}
- (NSString *)avatarInitials;
{
    if(self.initials) return self.initials;
    NSMutableString *initials = [NSMutableString new];
    NSString *nameComponents = [self.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *names = [nameComponents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (names.count > 2) {
        NSString *firstName = names.firstObject;
        NSString *lastName = names.lastObject;
        names = @[firstName, lastName];
    }
    for (NSString *name in names) {
        [initials appendString:[name substringToIndex:1]];
    }
    return initials;
}
- (void) setInfo:(NSDictionary *)info;
{
    if(!info || ![info isKindOfClass:[NSDictionary class]]) return;
    if(info[kDAAPIUserID]) self.userID = info[kDAAPIUserID];
    if(info[kDAAPIUserName]) self.name = info[kDAAPIUserName];
    if(info[kDAAPIUserDisplayName]) self.displayName = info[kDAAPIUserDisplayName];
    if(info[kDAAPIUserInitials]) self.initials = info[kDAAPIUserInitials];
    if(info[kDAAPIUserEmail]) self.email = info[kDAAPIUserEmail];
    if(info[kDAAPIUserConversation]) self.conversationID = info[kDAAPIUserConversation];
    if(info[kDAAPIUserPhoto]) self.photoURL = [NSURL URLWithString:info[kDAAPIUserPhoto]];
    if(info[kDAAPIUserThumbnail]) self.thumbnailURL = [NSURL URLWithString:info[kDAAPIUserThumbnail]];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) setUserID:(NSString *)value;
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kDAUserID];
}
- (void) setConversationID:(NSString *)value;
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kDAUserConversation];
}
- (void) setName:(NSString *)value;
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kDAUserName];
}
- (void) setEmail:(NSString *)value;
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kDAUserEmail];
}
- (void) setInitials:(NSString *)value;
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kDAUserInitials];
}
- (void) setDisplayName:(NSString *)value;
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kDAUserDisplayName];
}
- (void) setPhotoURL:(NSURL *)value;
{
    [[NSUserDefaults standardUserDefaults] setObject:value.absoluteString forKey:kDAUserPhotoURL];
}
- (void) setThumbnailURL:(NSURL *)value;
{
    [[NSUserDefaults standardUserDefaults] setObject:value.absoluteString forKey:kDAUserThumbnailURL];
}
- (NSString *) userID;
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kDAUserID];
}
- (NSString *) conversationID;
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kDAUserConversation];
}
- (NSString *) name;
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kDAUserName];
}
- (NSString *) displayName;
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kDAUserDisplayName];
}
- (NSString *) initials;
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kDAUserInitials];
}
- (NSString *) email;
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kDAUserEmail];
}
- (NSURL *) thumbnailURL;
{
    return ![[NSUserDefaults standardUserDefaults] objectForKey:kDAUserThumbnailURL] ? nil : [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:kDAUserThumbnailURL]];

}
- (NSURL *) photoURL;
{
    return ![[NSUserDefaults standardUserDefaults] objectForKey:kDAUserPhotoURL] ? nil : [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:kDAUserPhotoURL]];
    
}

- (BOOL) isReady;
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kDAUserFirstTime] ? YES : NO;
//
//#if !(TARGET_IPHONE_SIMULATOR)
//    return [[NSUserDefaults standardUserDefaults] boolForKey:kDAUserFirstTime] ? YES : NO;
//#else
//    return YES;
//#endif
    
}

- (NSString *) description;
{
    return [NSString stringWithFormat:@"User: %@  <userID: %@>", self.name, self.userID];
}

- (NSString *) debugDescription;
{
    return [NSString stringWithFormat:@"User: %@  <userID: %@> %@", self.name, self.userID, @{@"email": self.email,
                                                                                              @"initials": self.initials,
                                                                                              @"displayName": self.displayName}];
}



@end
