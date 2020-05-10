//
//  DangleApplicationController.h
//  Dangle
//
//  Created by Me on 5/18/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <LayerKit/LayerKit.h>
#import "DangleAPI.h"
#import "DangleClient.h"

extern NSString *const DangleLayerApplicationID;

extern NSString *const DangleConversationMetadataDidChangeNotification;
extern NSString *const DangleConversationParticipantsDidChangeNotification;
extern NSString *const DangleConversationDeletedNotification;

/**
 @abstract The `LSApplicationController` manages global resources needed by multiple view controller classes in the Atlas Messenger App.
 It also implement the `LYRClientDelegate` protocol. Only one instance should be instantiated and it should be passed to
 controllers that require it.
 */
@interface DangleApplicationController : NSObject <LYRClientDelegate>

///--------------------------------
/// @name Initializing a Controller
///--------------------------------

+ (instancetype)controllerWithPersistenceManager:(DanglePersistenceManager *)persistenceManager;

///--------------------------------
/// @name Global Resources
///--------------------------------

/**
 @abstract The `LYRClient` object for the application.
 */
@property (nonatomic) DangleClient *layerClient;

/**
 @abstract The `LSAPIManager` object for the application.
 */
@property (nonatomic) DangleAPI *APIManager;

/**
 @abstract The `LSPersistenceManager` object for the application.
 */
@property (nonatomic) DanglePersistenceManager *persistenceManager;

@end
