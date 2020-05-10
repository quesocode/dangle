
//

#import "DangleApplicationController.h"
//#import "DangleUtilities.h"
#import <SVProgressHUD/SVProgressHUD.h>

NSString *const DangleLayerApplicationID = @"LAYER_APP_ID";

NSString *const DangleConversationMetadataDidChangeNotification = @"LSConversationMetadataDidChangeNotification";
NSString *const DangleConversationParticipantsDidChangeNotification = @"LSConversationParticipantsDidChangeNotification";
NSString *const DangleConversationDeletedNotification = @"LSConversationDeletedNotification";

@interface DangleApplicationController ()

@end

@implementation DangleApplicationController

+ (instancetype)controllerWithPersistenceManager:(DanglePersistenceManager *)persistenceManager
{
    NSParameterAssert(persistenceManager);
    return [[self alloc] initWithPersistenceManager:persistenceManager];
}

- (id)initWithPersistenceManager:(DanglePersistenceManager *)persistenceManager
{
    self = [super init];
    if (self) {
        _persistenceManager = persistenceManager;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setLayerClient:(DangleClient *)layerClient
{
    _layerClient = layerClient;
    _layerClient.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLayerClientWillBeginSynchronizationNotification:) name:LYRClientWillBeginSynchronizationNotification object:layerClient];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLayerClientDidFinishSynchronizationNotification:) name:LYRClientDidFinishSynchronizationNotification object:layerClient];
}

- (void)setAPIManager:(DangleAPI *)APIManager
{
    _APIManager = APIManager;
    _APIManager.persistenceManager = self.persistenceManager;
}

#pragma mark - LYRClientDelegate

- (void)layerClient:(LYRClient *)client didReceiveAuthenticationChallengeWithNonce:(NSString *)nonce
{
    NSLog(@"Layer Client did recieve authentication challenge with nonce: %@", nonce);
    DangleUser *user = self.APIManager.authenticatedSession.user;
    if (!user) return;
    //TODO - Handle Auth Challenge;
}

- (void)layerClient:(LYRClient *)client didAuthenticateAsUserID:(NSString *)userID
{
    NSLog(@"Layer Client did recieve authentication nonce");
}

- (void)layerClientDidDeauthenticate:(LYRClient *)client
{
    [self.APIManager deauthenticate];
    NSLog(@"Layer Client did deauthenticate");
}

- (void)layerClient:(LYRClient *)client objectsDidChange:(NSArray *)changes
{
    for (NSDictionary *change in changes) {
        id changedObject = change[LYRObjectChangeObjectKey];
        if (![changedObject isKindOfClass:[LYRConversation class]]) continue;
        
        LYRObjectChangeType changeType = [change[LYRObjectChangeTypeKey] integerValue];
        NSString *changedProperty = change[LYRObjectChangePropertyKey];
        
        if (changeType == LYRObjectChangeTypeUpdate && [changedProperty isEqualToString:@"metadata"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DangleConversationMetadataDidChangeNotification object:changedObject];
        }
        
        if (changeType == LYRObjectChangeTypeUpdate && [changedProperty isEqualToString:@"participants"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DangleConversationParticipantsDidChangeNotification object:changedObject];
        }
        
        if (changeType == LYRObjectChangeTypeDelete) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DangleConversationDeletedNotification object:changedObject];
        }
    }
}

- (void)layerClient:(LYRClient *)client didFailOperationWithError:(NSError *)error
{
    NSLog(@"Layer Client did fail operation with error: %@", error);
}

- (void)layerClient:(LYRClient *)client willAttemptToConnect:(NSUInteger)attemptNumber afterDelay:(NSTimeInterval)delayInterval maximumNumberOfAttempts:(NSUInteger)attemptLimit
{
    if (attemptNumber == 1) {
        [SVProgressHUD showWithStatus:@"Connecting to Layer"];
    } else {
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"Connecting to Layer in %lus (%lu of %lu)", (unsigned long)ceil(delayInterval), (unsigned long)attemptNumber, (unsigned long)attemptLimit]];
    }
}

- (void)layerClientDidConnect:(LYRClient *)client
{
    [SVProgressHUD showSuccessWithStatus:@"Connected to Layer"];
}

- (void)layerClient:(LYRClient *)client didLoseConnectionWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Lost Connection: %@", error.localizedDescription]];
}

- (void)layerClientDidDisconnect:(LYRClient *)client
{
    [SVProgressHUD showSuccessWithStatus:@"Disconnected from Layer"];
}

#pragma mark - Notification Handlers

- (void)didReceiveLayerClientWillBeginSynchronizationNotification:(NSNotification *)notification;
{
    [self.APIManager loadContacts];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didReceiveLayerClientDidFinishSynchronizationNotification:(NSNotification *)notification
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end