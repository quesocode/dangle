//
//  DanglePersistenceManager.h
//  Dangle
//
//  Created by Me on 5/18/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dangle.h"
#import "DangleSession.h"
@class DangleSession, DangleUser;

@interface DanglePersistenceManager : NSObject

///---------------------------------------
/// @name Initializing a Manager
///---------------------------------------

/**
 @abstract Returns the default persistence manager for the application.
 @discussion When running within XCTest, returns a transient in-memory persistence manager. When running in a normal application environment, returns a persistence manager that persists objects to disk.
 */
+ (instancetype)defaultManager;

///---------------------------------------
/// @name Persisting
///---------------------------------------

/**
 @abstract Persists an `NSSet` of `DangleUser` objects to the specified path.
 @param users The `NSSet` of `DangleUser` objects to be persisted.
 @param error A reference to an `NSError` object that will contain error information in case the action was not successful.
 @return A boolean value indicating if the operation was successful.
 */
- (BOOL)persistUsers:(NSSet *)users error:(NSError **)error;

/**
 @abstract Persists an `DangleSession` object for the currently authenticated user.
 @param session The `DangleSession` object to be persisted.
 @param error A reference to an `NSError` object that will contain error information in case the action was not successful.
 @return A boolean value indicating if the operation was successful.
 */
- (BOOL)persistSession:(DangleSession *)session error:(NSError **)error;

///---------------------------------------
/// @name Fetching
///---------------------------------------

/**
 @abstract Returns the persisted `NSSet` of all `DangleUser` objects.
 @param error A reference to an `NSError` object that will contain error information in case the action was not successful.
 */
- (NSSet *)persistedUsersWithError:(NSError **)error;

/**
 @abstract Returns the persisted `DangleSession` object.
 @param error A reference to an `NSError` object that will contain error information in case the action was not successful.
 */
- (DangleSession *)persistedSessionWithError:(NSError **)error;

/**
 @abstract Returns an `NSSet` of `DangleUser` objects whose `userID` properties match those supplied in an `NSSet` of identifiers.
 @param identifiers An `NSSet` of `NSString` objects representing user identifiers.
 @return An `NSSet` of `DangleUser` objects.
 */
- (NSSet *)usersForIdentifiers:(NSSet *)identifiers;

/**
 @abstract Returns a `DangleUser` object whose `userID` property matches the supplied identifier.
 @param identifier An `NSString` representing a user identifier.
 @return A `DangleUser` object or nil if a user was not found with the supplied identifier.
 */
- (DangleUser *)userForIdentifier:(NSString *)identifier;

/**
 @abstract Performs a search across the `fullName` property on all persisted `DangleUser` objects for the supplied string.
 @param searchString The string object for which the search is performed.
 @param completion The completion block called when search completes.
 */
- (void)performUserSearchWithString:(NSString *)searchString completion:(void(^)(NSArray *users, NSError *error))completion;

///---------------------------------------
/// @name Deletion
///---------------------------------------

/**
 @abstract Deletes all objects currently persisted in the persistence manager.
 @param error A reference to an `NSError` object that will contain error information in case the action was not successful.
 @return A boolean value indicating if the operation was successful.
 */
- (BOOL)deleteAllObjects:(NSError **)error;
@end
