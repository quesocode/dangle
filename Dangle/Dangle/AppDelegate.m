//
//  AppDelegate.m
//  Dangle
//
//  Created by Travis Weerts on 5/7/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import "AppDelegate.h"
#import "DangleRegisterController.h"
#import "DangleSplashView.h"
#import <SVProgressHUD/SVProgressHUD.h>

static NSString *const DangleLayerAppID = @"70fb96de-f4d4-11e4-881d-d4f4330152af";


@interface AppDelegate ()

@property (nonatomic) DangleRegisterController *registerController;
@property (nonatomic) UINavigationController *navigationController;
@property (nonatomic) DangleSplashView *splashView;
@property (nonatomic) DangleClient *layerClient;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [[UINavigationBar appearance] setBarTintColor:[UIColor defaultBubbleColor]];

    
    // Standard lumberjack initialization for Custom colored logging
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [MysticLogger setupLogger];
    MysticLogger *mLogger = [[MysticLogger alloc] init];
    [[DDTTYLogger sharedInstance] setLogFormatter:mLogger];
    
    
    self.applicationController = [DangleApplicationController controllerWithPersistenceManager:[DanglePersistenceManager defaultManager]];

    // add app delegate to the dangle shared device (doesnt matter if its plugged in yet)
    [[DangleDevice sharedDevice] addDelegate:self];
    
    // Set up window
    [self configureWindow];
    
    // Setup notifications
    [self registerNotificationObservers];
    
    // Setup Layer
    [self setupLayer];
    
    // Configure Atlas Messenger UI appearance
    [self configureGlobalUserInterfaceAttributes];
    
    
    return YES;
}

#pragma mark - Setup

- (void)configureWindow
{
    self.registerController = [DangleRegisterController new];
    self.registerController.applicationController = self.applicationController;
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.registerController];
    self.navigationController.navigationBarHidden = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    [self addSplashView];
}


- (void)setupLayer;
{
    NSString *appID = DangleLayerAppID ?: [[NSUserDefaults standardUserDefaults] valueForKey:DangleLayerApplicationID];
    if (appID) {
        // Only instantiate one instance of `LYRClient`
        if (!self.layerClient) {
            self.layerClient = [DangleClient clientWithAppID:[[NSUUID alloc] initWithUUIDString:appID]];
            self.layerClient.autodownloadMIMETypes = [NSSet setWithObjects:ATLMIMETypeImageJPEGPreview, ATLMIMETypeTextPlain, nil];
        }
        DangleAPI *manager = [DangleAPI managerWithBaseURL:DangleAPIBaseURL() layerClient:self.layerClient];
        self.applicationController.layerClient = self.layerClient;
        self.applicationController.APIManager = manager;
        [self connectLayerIfNeeded];
        if (![self resumeSession]) {
            [self presentRegistrationViewController];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeSplashView];
            });
        }
    } else {
        [self removeSplashView];
    }
}

- (void)registerNotificationObservers;
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLayerAppID:) name:DangleDidReceiveLayerAppID object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidAuthenticate:) name:DangleUserDidAuthenticateNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(userDidAuthenticateWithLayer:) name:LYRClientDidAuthenticateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidDeauthenticate:) name:DangleUserDidDeauthenticateNotification object:nil];
}

#pragma mark - Session Management

- (BOOL)resumeSession;
{
    if (self.applicationController.layerClient.authenticatedUserID) {
        DangleSession *session = [self.applicationController.persistenceManager persistedSessionWithError:nil];
        if ([self.applicationController.APIManager resumeSession:session error:nil]) {
            [self presentConversationController:nil];
            return YES;
        }
    }
    return NO;
}

- (void)connectLayerIfNeeded;
{
    if (!self.applicationController.layerClient.isConnected && !self.applicationController.layerClient.isConnecting) {
        [self.applicationController.layerClient connectWithCompletion:^(BOOL success, NSError *error) {
            DLog(@"Layer Client Connected");
        }];
    }
}

#pragma mark - Presentation

- (void) presentRegistrationViewController;
{
    
}

- (void) presentConversationController:(LYRConversation *)conversation;
{
    
}

#pragma mark - Push Notifications

- (void)registerForRemoteNotifications:(UIApplication *)application;
{
    // Registers for push on iOS 7 and iOS 8
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:notificationSettings];
        [application registerForRemoteNotifications];
    } else {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
    }
}

- (void)unregisterForRemoteNotifications:(UIApplication *)application
{
    [application unregisterForRemoteNotifications];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Application failed to register for remote notifications with error %@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
{
    NSError *error;
    BOOL success = [self.applicationController.layerClient updateRemoteNotificationDeviceToken:deviceToken error:&error];
    if (success) {
        NSLog(@"Application did register for remote notifications");
    } else {
        NSLog(@"Error updating Layer device token for push:%@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
{
    NSLog(@"User Info: %@", userInfo);
    BOOL userTappedRemoteNotification = application.applicationState == UIApplicationStateInactive;
    __block LYRConversation *conversation = [self conversationFromRemoteNotification:userInfo];
    if (userTappedRemoteNotification && conversation) {
        [self presentConversationController:conversation];
    } else if (userTappedRemoteNotification) {
        [SVProgressHUD showWithStatus:@"Loading Conversation" maskType:SVProgressHUDMaskTypeBlack];
    }
    
    BOOL success = [self.applicationController.layerClient synchronizeWithRemoteNotification:userInfo completion:^(NSArray *changes, NSError *error) {
        if (changes.count) {
            completionHandler(UIBackgroundFetchResultNewData);
        } else {
            completionHandler(error ? UIBackgroundFetchResultFailed : UIBackgroundFetchResultNoData);
        }
        
        // Try navigating once the synchronization completed
        if (userTappedRemoteNotification && !conversation) {
            [SVProgressHUD dismiss];
            conversation = [self conversationFromRemoteNotification:userInfo];
            [self presentConversationController:conversation];
        }
    }];
    
    if (!success) {
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
{
    return YES;
}

- (LYRConversation *)conversationFromRemoteNotification:(NSDictionary *)remoteNotification;
{
    NSURL *conversationIdentifier = [NSURL URLWithString:[remoteNotification valueForKeyPath:@"layer.conversation_identifier"]];
    return [self.applicationController.layerClient existingConversationForIdentifier:conversationIdentifier];
}



- (void)applicationWillResignActive:(UIApplication *)application; {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application; {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application; {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application; {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application; {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory; {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "io.dangle.Dangle" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel; {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Dangle" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator; {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Dangle.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext; {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext; {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - DangleDeviceDelegate

- (void) dangleDevicePluggedIn:(DangleDevice *)device;
{
//    NSLog(@"dangle device delegate plugged in");
//    ALog(@"Dangle Device Plugged In", @[@"Device", device.name,
//                                        @"Device ID", device.deviceID,
//                                        @"Plugged", MBOOL(device.isPluggedIn),
//                                        @""]);
    
}
- (void) dangleDeviceUnplugged:(DangleDevice *)device;
{
//    NSLog(@"dangle device delegate unplugged");
//    ALog(@"Dangle Device Unplugged", @[@"Device", device.name,
//                                        @"Device ID", device.deviceID,
//                                        @"Plugged", MBOOL(device.isPluggedIn),
//                                        @""]);
    
}



#pragma mark - Splash View

- (void)addSplashView;
{
    if (!self.splashView) {
        self.splashView = [[DangleSplashView alloc] initWithFrame:self.window.bounds];
    }
    [self.window addSubview:self.splashView];
}

- (void)removeSplashView;
{
    [UIView animateWithDuration:0.5 animations:^{
        self.splashView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.splashView removeFromSuperview];
        self.splashView = nil;
    }];
}

#pragma mark - Authentication Notification Handlers

- (void)didReceiveLayerAppID:(NSNotification *)notification;
{
    [self setupLayer];
}

- (void)userDidAuthenticateWithLayer:(NSNotification *)notification;
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self userDidAuthenticateWithLayer:notification];
        });
        return;
    }
    [self presentConversationController:nil];
}

- (void)userDidAuthenticate:(NSNotification *)notification;
{
    NSError *error;
    DangleSession *session = self.applicationController.APIManager.authenticatedSession;
    BOOL success = [self.applicationController.persistenceManager persistSession:session error:&error];
    if (success) {
        NSLog(@"Persisted authenticated user session: %@", session);
    } else {
        NSLog(@"Failed persisting authenticated user: %@. Error: %@", session, error);
    }
    [self registerForRemoteNotifications:[UIApplication sharedApplication]];
}

- (void)userDidDeauthenticate:(NSNotification *)notification;
{
    NSError *error;
    BOOL success = [self.applicationController.persistenceManager persistSession:nil error:&error];
    if (success) {
        NSLog(@"Cleared persisted user session");
    } else {
        NSLog(@"Failed clearing persistent user session: %@", error);
        //TODO - Handle Error
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self setupLayer];
    }];
    
    [self unregisterForRemoteNotifications:[UIApplication sharedApplication]];
}


#pragma mark - UI Config

- (void)configureGlobalUserInterfaceAttributes;
{

    [[UINavigationBar appearance] setTintColor:ATLBlueColor()];
    [[UINavigationBar appearance] setBarTintColor:ATLLightGrayColor()];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:ATLBlueColor()];
    
    [[UINavigationBar appearance] setTintColor:[UIColor hex:@"618FD0"]];

}

#pragma mark - Application Badge Setter

- (void)setApplicationBadgeNumber;
{
    NSUInteger countOfUnreadMessages = [self.applicationController.layerClient countOfUnreadMessages];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:countOfUnreadMessages];
}

@end
