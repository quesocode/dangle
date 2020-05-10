//
//  DangleAPI.m
//  Dangle
//
//  Created by Me on 5/12/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import "DangleAPI.h"
#import "NSString+Mystic.h"
#import "DangleHTTPResponseSerializer.h"
#import "DangleErrors.h"
#import "DanglePersistenceManager.h"
#import "DangleSession.h"

NSString *const DangleUserDidAuthenticateNotification = @"DangleUserDidAuthenticateNotification";
NSString *const DangleUserDidDeauthenticateNotification = @"DangleUserDidDeauthenticateNotification";
NSString *const DangleApplicationDidSynchronizeParticipants = @"DangleApplicationDidSynchronizeParticipants";

NSString *const DangleAtlasIdentityKey = @"atlas_identity";
NSString *const DangleAtlasIdentitiesKey = @"atlas_identities";
NSString *const DangleAtlasIdentityTokenKey = @"identity_token";

NSString *const DangleAtlasUserIdentifierKey = @"id";
NSString *const DangleAtlasUserNameKey = @"name";

NSString *const DangleDidReceiveLayerAppID = @"DangleDidRecieveLayerAppID";


@implementation DangleAPI

+ (instancetype)managerWithBaseURL:(NSURL *)baseURL layerClient:(DangleClient *)layerClient
{
    NSParameterAssert(baseURL);
    NSParameterAssert(layerClient);
    return [[self alloc] initWithBaseURL:baseURL layerClient:layerClient];
}

- (id)initWithBaseURL:(NSURL *)baseURL layerClient:(DangleClient *)layerClient
{
    self = [super init];
    if (self) {
        _baseURL = baseURL;
        _client = layerClient;
        _URLSession = [self defaultURLSession];
    }
    return self;
}

+ (DangleAPI *) sharedInstance;
{
    static DangleAPI *_sharedObj = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        _sharedObj = [[[self class] alloc] init];
    });
    return _sharedObj;
}
+ (void) connect:(void ( ^ ) ( BOOL success , NSError *error ))completion;
{
    [[[self class] sharedInstance] connect:completion];
}


- (id) init;
{
    self = [super init];
    if(self)
    {
        NSUUID *appID = [[NSUUID alloc] initWithUUIDString:DANGLE_LAYER_APP_ID];
        self.client = [DangleClient clientWithAppID:appID];
        _baseURL = [NSURL URLWithString:@"http://dangle.io"];
    }
    return self;
}

- (void) connect:(void ( ^ ) ( BOOL success , NSError *error ))completion;
{
    [self.client connectWithCompletion:^(BOOL success, NSError *error) {
        
        if(success)
        {
            
            [DangleUser user:^(DangleUser *user, BOOL firstTime, NSError *error) {
                
               if(user)
               {
                   
                   [self authenticateLayerWithUserID:user.userID completion:completion];
               }
                else
                {
                    completion(NO, error);
                }
            }];
        }
        else
        {
            completion(success, error);

        }
    }];
}


- (void)authenticateLayerWithUserID:(NSString *)userID completion:(void (^)(BOOL success, NSError * error))completion
{
    // Check to see if the client is already authenticated.
    if (self.client.authenticatedUserID) {
        // If the client is authenticated with the requested userID, complete the authentication process.
        if ([self.client.authenticatedUserID isEqualToString:userID]){
//            NSLog(@"Layer Authenticated as User %@", self.client.authenticatedUserID);
            if (completion) completion(YES, nil);
            return;
        } else {
            //If the authenticated userID is different, then deauthenticate the current client and re-authenticate with the new userID.
            [self.client deauthenticateWithCompletion:^(BOOL success, NSError *error) {
                if (!error){
                    [self authenticationTokenWithUserId:userID completion:^(BOOL success, NSError *error) {
                        if (completion){
                            completion(success, error);
                        }
                    }];
                } else {
                    if (completion){
                        completion(NO, error);
                    }
                }
            }];
        }
    } else {
        // If the client isn't already authenticated, then authenticate.
        [self authenticationTokenWithUserId:userID completion:^(BOOL success, NSError *error) {
            if (completion){
                completion(success, error);
            }
        }];
    }
}

- (void)authenticationTokenWithUserId:(NSString *)userID completion:(void (^)(BOOL success, NSError* error))completion{
    
    /*
     * 1. Request an authentication Nonce from Layer
     */
    [self.client requestAuthenticationNonceWithCompletion:^(NSString *nonce, NSError *error) {
        if (!nonce) {
            if (completion) {
                completion(NO, error);
            }
            return;
        }
        
        /*
         * 2. Acquire identity Token from Layer Identity Service
         */
        [self requestIdentityTokenForUserID:userID appID:[self.client.appID UUIDString] nonce:nonce completion:^(NSString *identityToken, NSError *error) {
            if (!identityToken) {
                if (completion) {
                    completion(NO, error);
                }
                return;
            }
            
            /*
             * 3. Submit identity token to Layer for validation
             */
            [self.client authenticateWithIdentityToken:identityToken completion:^(NSString *authenticatedUserID, NSError *error) {
                if (authenticatedUserID) {
                    if (completion) {
                        completion(YES, nil);
                    }
//                    NSLog(@"Layer Authenticated as User: %@", authenticatedUserID);
                } else {
                    completion(NO, error);
                }
            }];
        }];
    }];
}

- (void)requestIdentityTokenForUserID:(NSString *)userID appID:(NSString *)appID nonce:(NSString *)nonce completion:(void(^)(NSString *identityToken, NSError *error))completion
{
    NSParameterAssert(userID);
    NSParameterAssert(appID);
    NSParameterAssert(nonce);
    NSParameterAssert(completion);
    
    NSURL *identityTokenURL = [NSURL URLWithString:@"https://layer-identity-provider.herokuapp.com/identity_tokens"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:identityTokenURL];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDictionary *parameters = @{ @"app_id": appID, @"user_id": userID, @"nonce": nonce };
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    request.HTTPBody = requestBody;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        // Deserialize the response
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if(![responseObject valueForKey:@"error"])
        {
            NSString *identityToken = responseObject[@"identity_token"];
            completion(identityToken, nil);
        }
        else
        {
            NSString *domain = @"layer-identity-provider.herokuapp.com";
            NSInteger code = [responseObject[@"status"] integerValue];
            NSDictionary *userInfo =
            @{
              NSLocalizedDescriptionKey: @"Layer Identity Provider Returned an Error.",
              NSLocalizedRecoverySuggestionErrorKey: @"There may be a problem with your APPID."
              };
            
            NSError *error = [[NSError alloc] initWithDomain:domain code:code userInfo:userInfo];
            completion(nil, error);
        }
        
    }] resume];
}

#pragma mark - Register User

+ (void) registerUser:(void (^)(NSDictionary *response, NSError *error))completion;
{
    NSURL *identityTokenURL = [NSURL URLWithString:@"http://dangle.io/api/user/setup"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:identityTokenURL];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"xmlhttprequest" forHTTPHeaderField:@"X_REQUESTED_WITH"];
    NSString *udid = [DangleUser deviceID];
    
    NSDictionary *parameters = @{ @"udid": udid };
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    request.HTTPBody = requestBody;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
//        DLog(@"resonse data: %@", [NSString stringWithUTF8String:[data bytes]]);
//        return;
        // Deserialize the response
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        DLog(@"response obj: %@", responseObject);
       
        //ALog(@"DangleAPI Response", responseObject);
        if(![responseObject valueForKey:@"error"])
        {
            
            completion(responseObject[@"response"] ? responseObject[@"response"] : responseObject, nil);
        }
        else
        {
            NSString *domain = @"dangle.io";
            NSInteger code = [responseObject[@"status"] integerValue];
            NSDictionary *userInfo =
            @{
              NSLocalizedDescriptionKey: @"Dangle API Returned an Error.",
              NSLocalizedRecoverySuggestionErrorKey: @"There may be a problem with the API."
              };
            
            NSError *error = [[NSError alloc] initWithDomain:domain code:code userInfo:userInfo];
            completion(nil, error);
        }
        
    }] resume];
}



- (NSURLSession *)defaultURLSession
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{ @"Accept": @"application/json", @"X_LAYER_APP_ID": self.client.appID.UUIDString };
    return [NSURLSession sessionWithConfiguration:configuration];
}

- (BOOL)resumeSession:(DangleSession *)session error:(NSError *__autoreleasing *)error
{
    if (!session) return NO;
    return [self configureWithSession:session error:error];
}

- (void)deauthenticate
{
    if (!self.authenticatedSession) return;
    
    self.authenticatedSession = nil;
    
    [self.URLSession invalidateAndCancel];
    self.URLSession = [self defaultURLSession];
    [[NSNotificationCenter defaultCenter] postNotificationName:DangleUserDidDeauthenticateNotification object:nil];
}

#pragma mark - Registration

- (void)registerUserWithName:(NSString*)name nonce:(NSString *)nonce completion:(void (^)(NSString *identityToken, NSError *error))completion
{
    NSParameterAssert(name);
    NSParameterAssert(nonce);
    NSParameterAssert(completion);
    
    NSURL *identityTokenURL = [NSURL URLWithString:@"http://dangle.io/api/user/setup"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:identityTokenURL];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"xmlhttprequest" forHTTPHeaderField:@"X_REQUESTED_WITH"];
    NSString *udid = [DangleUser deviceID];
    
    NSDictionary *parameters = @{ @"name": name, @"nonce" : nonce, @"udid": udid };
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    request.HTTPBody = requestBody;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
//        DLog(@"resonse data: %@", [NSString stringWithUTF8String:[data bytes]]);
        //        return;
        // Deserialize the response
//        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSError *serializationError;
        NSDictionary *userDetails = nil;
        BOOL success = [DangleHTTPResponseSerializer responseObject:&userDetails withData:data response:(NSHTTPURLResponse *)response error:&serializationError];
        if (success) {
            NSError *error;
            NSArray *userData = [userDetails[@"chat"][@"users"] allValues];
            BOOL success = [self persistUserData:userData error:&error];
            if (!success) {
                completion(nil, error);
            }

//            DLog(@"register user: %@", userDetails);

            DangleUser *user = [DangleUser userFromDictionaryRepresentation:userDetails[@"user"]];
            DangleSession *session = [DangleSession sessionWithAuthenticationToken:@"atlas_auth_token" user:user];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *sessionConfigurationError;
                BOOL success = [self configureWithSession:session error:&sessionConfigurationError];
                if (!success) {
                    completion(nil, sessionConfigurationError);
                    return;
                }
                [self requestIdentityTokenForUserID:userDetails[@"user"][@"userID"] appID:[self.client.appID UUIDString] nonce:nonce completion:^(NSString *identityToken, NSError *error) {
                    if (!success) {
                        completion(nil, error);
                        return;
                    }
                    completion(identityToken, nil);
                }];

            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, serializationError);
            });
        }
        
//        DLog(@"response obj: %@", responseObject);
//        ALog(@"response serialed", @[@"success", MBOOL(success),
//                                     @"user details", MObj(userDetails)]);
        
    }] resume];
     return;
//    
//    NSString *udid = [DangleUser deviceID];
//    NSString *urlString = [NSString stringWithFormat:@"user/setup?app=%@", [self.client.appID UUIDString]];
//    NSURL *URL = [NSURL URLWithString:urlString relativeToURL:self.baseURL];
//    NSDictionary *parameters = @{ @"name": name, @"nonce" : nonce, @"udid": udid };
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
//    request.HTTPMethod = @"POST";
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"xmlhttprequest" forHTTPHeaderField:@"X_REQUESTED_WITH"];
//    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
//
//    
//    
//    [[self.URLSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (!response && error) {
//            NSLog(@"Failed with error: %@", error);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                completion(nil, error);
//            });
//            return;
//        }
//        
//        NSError *serializationError;
//        NSDictionary *userDetails;
//        BOOL success = [DangleHTTPResponseSerializer responseObject:&userDetails withData:data response:(NSHTTPURLResponse *)response error:&serializationError];
//        if (success) {
//            NSError *error;
//            NSArray *userData = userDetails[DangleAtlasIdentitiesKey];
//            BOOL success = [self persistUserData:userData error:&error];
//            if (!success) {
//                completion(nil, error);
//            }
//            
//            DLog(@"register user: %@", userDetails);
//            return;
//            
//            DangleUser *user = [DangleUser userFromDictionaryRepresentation:userDetails[DangleAtlasIdentityKey]];
//            DangleSession *session = [DangleSession sessionWithAuthenticationToken:@"atlas_auth_token" user:user];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSError *sessionConfigurationError;
//                BOOL success = [self configureWithSession:session error:&sessionConfigurationError];
//                if (!success) {
//                    completion(nil, sessionConfigurationError);
//                    return;
//                }
//                NSString *identityToken = userDetails[DangleAtlasIdentityTokenKey];
//                completion(identityToken, nil);
//            });
//        } else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                completion(nil, serializationError);
//            });
//        }
//    }] resume];
}

- (void)loadContacts;
{
    
    NSURL *identityTokenURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://dangle.io/api/user/setup?udid=%@", [DangleUser deviceID]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:identityTokenURL];
    request.HTTPMethod = @"GET";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"xmlhttprequest" forHTTPHeaderField:@"X_REQUESTED_WITH"];
//
//    NSString *urlString = [NSString stringWithFormat:@"apps/%@/atlas_identities", [self.client.appID UUIDString]];
//    NSURL *URL = [NSURL URLWithString:urlString relativeToURL:self.baseURL];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
//    request.HTTPMethod = @"GET";
    
    [[self.URLSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!response && error) {
            NSLog(@"Failed synchronizing participants with error: %@", error);
            return;
        }
        
        NSError *serializationError;
        NSDictionary *userDetails;
        BOOL success = [DangleHTTPResponseSerializer responseObject:&userDetails withData:data response:(NSHTTPURLResponse *)response error:&serializationError];
        if (success) {
            NSError *error;
            
            NSArray *userData = (NSArray *)[userDetails[@"chat"][@"users"] allValues];
            DLog(@"loadContacts response: %@", userData);
//            return;
            
            BOOL success = [self persistUserData:userData error:&error];
            if (!success) {
                NSLog(@"Failed synchronizing participants with error: %@", error);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:DangleApplicationDidSynchronizeParticipants object:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Failed synchronizing participants with error: %@", serializationError);
            });
        }
    }] resume];
}

- (BOOL)configureWithSession:(DangleSession *)session error:(NSError **)error
{
    if (self.authenticatedSession) return YES;
    if (!session) {
        if (error) {
            *error = [NSError errorWithDomain:DangleErrorDomain code:DangleNoAuthenticatedSession userInfo:@{NSLocalizedDescriptionKey: @"No authenticated session."}];
            return NO;
        }
    }
    self.authenticatedSession = session;
    BOOL success = [self.persistenceManager persistSession:session error:nil];
    if (!success) {
        *error = [NSError errorWithDomain:DangleErrorDomain code:DangleNoAuthenticatedSession userInfo:@{NSLocalizedDescriptionKey: @"There was an error persisting the session."}];
        return NO;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:DangleUserDidAuthenticateNotification object:session.user];
    return YES;
}

- (BOOL)persistUserData:(NSArray *)userData error:(NSError **)error
{
    BOOL success = [self.persistenceManager persistUsers:[self usersFromResponseData:userData] error:error];
    if (success) {
        return YES;
    } else {
        return NO;
    }
}

- (NSSet *)usersFromResponseData:(NSArray *)responseData
{
    NSMutableSet *users = [NSMutableSet new];
    for (NSDictionary *dictionary in responseData) {
        DangleUser *user = [DangleUser userFromDictionaryRepresentation:dictionary];
        [users addObject:user];
    }
    return users;
}


@end
