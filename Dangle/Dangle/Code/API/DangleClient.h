//
//  DangleClient.h
//  Dangle
//
//  Created by Me on 5/12/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import "Dangle.h"

@interface DangleClient : LYRClient


/**
 @abstract Queries LayerKit for the total count of `LYRMessage` objects whose `isUnread` property is true.
 */
- (NSUInteger)countOfUnreadMessages;

/**
 @abstract Queries LayerKit for the total count of `LYRMessage` objects.
 */
- (NSUInteger)countOfMessages;

/**
 @abstract Queries LayerKit for the total count of `LYRConversation` objects.
 */
- (NSUInteger)countOfConversations;

/**
 @abstract Queries LayerKit for an existing message whose `identifier` property matches the supplied identifier.
 @param identifier An NSURL representing the `identifier` property of an `LYRMessage` object for which the query will be performed.
 @retrun An `LYRMessage` object or `nil` if none is found.
 */
- (LYRMessage *)messageForIdentifier:(NSURL *)identifier;

/**
 @abstract Queries LayerKit for an existing conversation whose `identifier` property matches the supplied identifier.
 @param identifier An NSURL representing the `identifier` property of an `LYRConversation` object for which the query will be performed.
 @retrun An `LYRConversation` object or `nil` if none is found.
 */
- (LYRConversation *)existingConversationForIdentifier:(NSURL *)identifier;

/**
 @abstract Queries LayerKit for an existing conversation whose `participants` property matches the supplied set.
 @param participants An `NSSet` of participant identifier strings for which the query will be performed.
 @retrun An `LYRConversation` object or `nil` if none is found.
 */
- (LYRConversation *)existingConversationForParticipants:(NSSet *)participants;



@end
