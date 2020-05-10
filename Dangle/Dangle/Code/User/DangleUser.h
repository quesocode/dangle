//
//  DangleUser.h
//  Dangle
//
//  Created by Me on 5/12/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DangleDefinitions.h"
#import "Atlas.h"

@interface DangleUser : NSObject <NSCoding, ATLParticipant>

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *initials;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *conversationID;
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) NSURL *thumbnailURL;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, readonly) BOOL isReady;
@property (nonatomic) NSString *participantIdentifier;
@property (nonatomic) NSString *avatarInitials;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *fullName;




+ (DangleUser *) user;
+ (NSString *) deviceID;
+ (void) user:(void ( ^ ) ( DangleUser *user , BOOL firstTime, NSError *error))completion;
+ (instancetype)userFromDictionaryRepresentation:(NSDictionary *)representation;

@end
