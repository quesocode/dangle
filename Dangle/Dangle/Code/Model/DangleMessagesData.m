//
//  DangleMessagesData.m
//  Dangle
//
//  Created by Me on 5/15/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import "DangleMessagesData.h"
@interface DangleMessagesData ()
{
    
}
@property (strong, nonatomic) NSDictionary *bubbleColors;
@property (strong, nonatomic) NSMutableDictionary *bubbles;

@end
@implementation DangleMessagesData

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        if ([NSUserDefaults emptyMessagesSetting]) {
            self.messages = [NSMutableArray new];
        }
        else {
            [self loadMessages];
        }
        
        
        /**
         *  Create avatar images once.
         *
         *  Be sure to create your avatars one time and reuse them for good performance.
         *
         *  If you are not using avatars, ignore this.
         */

        JSQMessagesAvatarImage *dangleImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"dangle_avatar"]
                                                                                       diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        

        
        JSQMessagesAvatarImage *user1Image = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"user_avatar"]
                                                                                       diameter:kJSQMessagesCollectionViewAvatarSizeDefault];

//        JSQMessagesAvatarImage *user2Image = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"U2"
//                                                                                        backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
//                                                                                              textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
//                                                                                                   font:[UIFont systemFontOfSize:14.0f]
//                                                                                               diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        JSQMessagesAvatarImage *user2Image = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"U2"
                                                                                        backgroundColor:[UIColor hex:@"8e6296"]
                                                                                              textColor:[UIColor colorWithWhite:1.0f alpha:1.0f]
                                                                                                   font:[UIFont fontWithName:@"AvenirNext-Bold" size:10]
                                                                                               diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        
        JSQMessagesAvatarImage *user3Image = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"U3"
                                                                                      backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                                                            textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                                                 font:[UIFont systemFontOfSize:14.0f]
                                                                                             diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        self.bubbles = [NSMutableDictionary dictionary];
        self.avatars = @{ [DangleUser user].userID : dangleImage,
                          kDAUserId1 : user1Image,
                          kDAUserId2 : user2Image,
                          kDAUserId3 : user3Image };
        
        
        self.users = @{kDAUserId1 : kDAUserDisplayName1,
                       kDAUserId2 : kDAUserDisplayName2,
                        kDAUserId3 : kDAUserDisplayName3,
                        [DangleUser user].userID : [DangleUser user].displayName };
        
        
        /**
         *  Create message bubble images objects.
         *
         *  Be sure to create your bubble images one time and reuse them for good performance.
         *
         */
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor defaultOutgoingBubbleColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor defaultBubbleColor]];
        
        self.bubbleColors = @{
                              kDAUserId1 : [UIColor hex:@"e15379"],
                               };
        
        for (NSString *userID in [self.bubbleColors allKeys]) {
            [self bubbleForUserID:userID outgoing:[[DangleUser user].userID isEqualToString:userID]];
        }
        
    }
    
    return self;
}

- (void)loadMessages
{
    /**
     *  Load some fake messages for demo.
     *
     *  You should have a mutable array or orderedSet, or something.
     */
    self.messages = [[NSMutableArray alloc] initWithObjects:
//                     [[JSQMessage alloc] initWithSenderId:[DangleUser user].userID
//                                        senderDisplayName:[DangleUser user].displayName
//                                                     date:[NSDate dateWithTimeIntervalSince1970:1431419713]
//                                                     text:@"Welcome to Dangle!"],
                     
                     [[JSQMessage alloc] initWithSenderId:kDAUserId1
                                        senderDisplayName:kDAUserDisplayName1
                                                     date:[NSDate dateWithTimeIntervalSince1970:1431419713]
                                                     text:@"Hello Dangle! This is message numero uno."],
                     
                     [[JSQMessage alloc] initWithSenderId:[DangleUser user].userID
                                        senderDisplayName:[DangleUser user].displayName
                                                     date:[NSDate dateWithTimeIntervalSince1970:1431420143]
                                                     text:@"Too bad the only person you have to talk to is yourself ;)"],
                     
                     [[JSQMessage alloc] initWithSenderId:kDAUserId2
                                        senderDisplayName:kDAUserDisplayName2
                                                     date:[NSDate dateWithTimeIntervalSince1970:1431522654]
                                                     text:@"That's not true, there's another \"you\" to chat with too! Call me 713-555-3755"],
                     
                     [[JSQMessage alloc] initWithSenderId:kDAUserId1
                                        senderDisplayName:kDAUserDisplayName1
                                                     date:[NSDate dateWithTimeIntervalSince1970:1431531753]
                                                     text:@"You don't count... sigh"],
                     
                     [[JSQMessage alloc] initWithSenderId:[DangleUser user].userID
                                        senderDisplayName:[DangleUser user].displayName
                                                     date:[NSDate dateWithTimeIntervalSince1970:1431522654]
                                                     text:@"umm... just how many personalities do you/we have?"],
                     nil];
    
    [self addPhotoMediaMessage];
    
    /**
     *  Setting to load extra messages for testing/demo
     */
    if ([NSUserDefaults extraMessagesSetting]) {
        NSArray *copyOfMessages = [self.messages copy];
        for (NSUInteger i = 0; i < 4; i++) {
            [self.messages addObjectsFromArray:copyOfMessages];
        }
    }
    
    
    /**
     *  Setting to load REALLY long message for testing/demo
     *  You should see "END" twice
     */
    if ([NSUserDefaults longMessageSetting]) {
        JSQMessage *reallyLongMessage = [JSQMessage messageWithSenderId:[DangleUser user].userID
                                                            displayName:[DangleUser user].displayName
                                                                   text:@"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END"];
        
        [self.messages addObject:reallyLongMessage];
    }
}
- (JSQMessagesBubbleImage *) bubbleForUserID:(NSString *)userID outgoing:(BOOL)isOutgoingMessage;
{
    NSString *colorStr = nil;
    UIColor *bubbleColor = nil;
    if(userID && self.bubbleColors[userID])
    {
        bubbleColor = self.bubbleColors[userID];
    }
    
    colorStr = !bubbleColor ? nil : [bubbleColor.hexString stringByAppendingString:!isOutgoingMessage ? @"_in" : @"_out"];
    
    if(colorStr &&  self.bubbles[colorStr])
    {
        return self.bubbles[colorStr];
    }
    else if(colorStr)
    {
        JSQMessagesBubbleImage *bubble = nil;
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        if(isOutgoingMessage)
        {
            bubble = [bubbleFactory outgoingMessagesBubbleImageWithColor:bubbleColor];
        }
        else
        {
            bubble = [bubbleFactory incomingMessagesBubbleImageWithColor:bubbleColor];
        }
        
        [self.bubbles setObject:bubble forKey:colorStr];
        return bubble;
    }
    
    return !isOutgoingMessage ? self.incomingBubbleImageData : self.outgoingBubbleImageData;
}
- (void)addPhotoMediaMessage
{
    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:[UIImage imageNamed:@"user_image"]];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:[DangleUser user].userID
                                                   displayName:[DangleUser user].displayName
                                                         media:photoItem];
    [self.messages addObject:photoMessage];
}

- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion
{
    CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:37.795313 longitude:-122.393757];
    
    JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
    [locationItem setLocation:ferryBuildingInSF withCompletionHandler:completion];
    
    JSQMessage *locationMessage = [JSQMessage messageWithSenderId:[DangleUser user].userID
                                                      displayName:[DangleUser user].displayName
                                                            media:locationItem];
    [self.messages addObject:locationMessage];
}

- (void)addVideoMediaMessage
{
    // don't have a real video, just pretending
    NSURL *videoURL = [NSURL URLWithString:@"file://"];
    
    JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
    JSQMessage *videoMessage = [JSQMessage messageWithSenderId:[DangleUser user].userID
                                                   displayName:[DangleUser user].displayName
                                                         media:videoItem];
    [self.messages addObject:videoMessage];
}
@end
