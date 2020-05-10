//
//  DangleAPI.h
//  Dangle
//
//  Created by Me on 5/12/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import "Dangle.h"
#import "DangleUser.h"
#import "DanglePersistenceManager.h"
#import "DangleUser.h"
#import "DangleSession.h"



@class DanglePersistenceManager;

//#import "DangleHTTPResponseSerializer.h"
//#import "DangleErrors.h"
extern NSString *const DangleDidReceiveLayerAppID;
extern NSString *const DangleUserDidAuthenticateNotification;
extern NSString *const DangleUserDidDeauthenticateNotification;
extern NSString *const DangleApplicationDidSynchronizeParticipants;

@class DangleClient;

@interface DangleAPI : NSObject

+ (DangleAPI *) sharedInstance;
+ (instancetype)managerWithBaseURL:(NSURL *)baseURL layerClient:(DangleClient *)layerClient;

+ (void) connect:(void ( ^ ) ( BOOL success , NSError *error ))completion;
+ (void) registerUser:(void (^)(NSDictionary *response, NSError *error))completion;
@property (nonatomic, strong) DangleClient *client;
@property (nonatomic) NSURL *baseURL;

/**
 @abstract The persistence manager responsible for persisting user information.
 */
@property (nonatomic) DanglePersistenceManager *persistenceManager;

/**
 @abstract The current authenticated session or `nil` if not yet authenticated.
 */
@property (nonatomic) DangleSession *authenticatedSession;

/**
 @abstract The baseURL used to initialize the receiver.
 */

/**
 @abstract The currently configured URL session.
 */
@property (nonatomic) NSURLSession *URLSession;

/**
 @param error A reference to an `NSError` object that will contain error information in case the action was not successful.
 @return A boolean value that indicates if the manager has a valid session.
 */
- (BOOL)resumeSession:(DangleSession *)session error:(NSError **)error;

/**
 @abstract Registers and authenticates an Atlas Messenger user.
 @param name An `NSString` object representing the name of the user attempting to register.
 @param nonce A nonce value obtained via a call to `requestAuthenticationNonceWithCompletion:` on `LYRClient`.
 @param completion completion The block to execute upon completion of the asynchronous user registration operation. The block has no return value and accepts two arguments: An identity token that was obtained upon successful registration (or nil in the event of a failure) and an `NSError` object that describes why the operation failed (or nil if the operation was successful).
 */
- (void)registerUserWithName:(NSString*)name nonce:(NSString *)nonce completion:(void (^)(NSString *identityToken, NSError *error))completion;

/**
 @abstract Synchronizes the local participant store with the Layer identity provider.
 */
- (void)loadContacts;

/**
 @abstract Deauthenticates the Atlas Messenger app by discarding its `DangleSession` object.
 */
- (void)deauthenticate;



- (void) connect:(void ( ^ ) ( BOOL success , NSError *error ))completion;
@end
