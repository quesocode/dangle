//
//  DangleMessagesData.h
//  Dangle
//
//  Created by Me on 5/15/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSQMessagesViewController/JSQMessages.h>
#import "Dangle.h"


static NSString * const kDAUserDisplayName1 = @"Travis";
static NSString * const kDAUserDisplayName2 = @"User 2";
static NSString * const kDAUserDisplayName3 = @"User 3";

static NSString * const kDAUserId1 = @"EdRbko";
static NSString * const kDAUserId2 = @"qxAPdD";
static NSString * const kDAUserId3 = @"TGtDVc";


@interface DangleMessagesData : NSObject


@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (strong, nonatomic) NSDictionary *users;

- (void)addPhotoMediaMessage;
- (JSQMessagesBubbleImage *) bubbleForUserID:(NSString *)userID outgoing:(BOOL)forRightSide;

- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion;

- (void)addVideoMediaMessage;


@end
