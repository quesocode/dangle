//
//  DangleChatViewController.h
//  Dangle
//
//  Created by Me on 5/12/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import "Dangle.h"
#import <JSQMessagesViewController/JSQMessages.h>

@interface DangleChatViewController : JSQMessagesViewController <UIActionSheetDelegate>

@property (nonatomic, retain) DangleMessagesData *data;
@property (nonatomic, strong) LYRConversation *conversation;

- (void) connect:(void(^)( BOOL success , NSError *error ))completion;

@end
