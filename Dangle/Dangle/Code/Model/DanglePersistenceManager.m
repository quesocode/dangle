//
//  DanglePersistenceManager.m
//  Dangle
//
//  Created by Me on 5/18/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import "DangleUtilities.h"
#import "DanglePersistenceManager.h"

#define DangleMustBeImplementedBySubclass() @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must be implemented by concrete subclass." userInfo:nil]

static NSString *const DangleOnDiskPersistenceManagerUsersFileName = @"Users.plist";
static NSString *const DangleOnDiskPersistenceManagerSessionFileName = @"Session.plist";

@interface DanglePersistenceManager ()

@property (nonatomic) NSSet *users;
@property (nonatomic) DangleSession *session;

@end

@interface DangleInMemoryPersistenceManager : DanglePersistenceManager

@end

@interface DangleOnDiskPersistenceManager : DanglePersistenceManager

@property (nonatomic, readonly) NSString *path;

- (id)initWithPath:(NSString *)path;

@end

@implementation DanglePersistenceManager

+ (instancetype)defaultManager
{
    if (DangleIsRunningTests()) {
        return [DanglePersistenceManager persistenceManagerWithInMemoryStore];
    }
    return [DanglePersistenceManager persistenceManagerWithStoreAtPath:[DangleApplicationDataDirectory() stringByAppendingPathComponent:@"PersistentObjects"]];
}

+ (instancetype)persistenceManagerWithInMemoryStore
{
    return [DangleInMemoryPersistenceManager new];
}

+ (instancetype)persistenceManagerWithStoreAtPath:(NSString *)path
{
    return [[DangleOnDiskPersistenceManager alloc] initWithPath:path];
}

- (id)init
{
    if ([self isMemberOfClass:[DanglePersistenceManager class]]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Failed to call designated initializer." userInfo:nil];
    } else {
        return [super init];
    }
}

- (BOOL)persistUsers:(NSSet *)users error:(NSError **)error
{
    DangleMustBeImplementedBySubclass();
}

- (NSSet *)persistedUsersWithError:(NSError **)error
{
    DangleMustBeImplementedBySubclass();
}

- (BOOL)deleteAllObjects:(NSError **)error
{
    DangleMustBeImplementedBySubclass();
}

- (BOOL)persistSession:(DangleSession *)session error:(NSError **)error
{
    DangleMustBeImplementedBySubclass();
}

- (DangleSession *)persistedSessionWithError:(NSError **)error
{
    DangleMustBeImplementedBySubclass();
}

- (void)performUserSearchWithString:(NSString *)searchString completion:(void (^)(NSArray *users, NSError *error))completion
{
    NSError *error;
    NSSet *users = [self persistedUsersWithError:&error];
    if (error) {
        completion(nil, error);
    } else {
        NSPredicate *searchPredicate = [self predicateForUsersWithSearchString:searchString];
        completion([users filteredSetUsingPredicate:searchPredicate].allObjects, nil);
    }
}

- (NSSet *)usersForIdentifiers:(NSSet *)identifiers;
{
    NSError *error;
    NSSet *allUsers = [self persistedUsersWithError:&error];
    if (error) return nil;
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF.userID IN %@", identifiers];
    NSSet *users = [allUsers filteredSetUsingPredicate:searchPredicate];
    return users;
}

- (DangleUser *)userForIdentifier:(NSString *)identifier
{
    NSError *error;
    NSSet *allUsers = [self persistedUsersWithError:&error];
    if (error) return nil;
    
    for (DangleUser *user in allUsers) {
        if ([user.userID isEqualToString:identifier]) {
            return user;
        }
    }
    return nil;
}

#pragma mark - Helpers

- (NSPredicate *)predicateForUsersWithSearchString:(NSString *)searchString
{
    NSString *escapedSearchString = [NSRegularExpression escapedPatternForString:searchString];
    NSString *searchPattern = [NSString stringWithFormat:@".*\\b%@.*", escapedSearchString];
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"fullName MATCHES[cd] %@", searchPattern];
    return searchPredicate;
}



@end



@implementation DangleInMemoryPersistenceManager

- (BOOL)persistUsers:(NSSet *)users error:(NSError **)error
{
    NSParameterAssert(users);
    self.users = users;
    return YES;
}

- (NSSet *)persistedUsersWithError:(NSError **)error
{
    return self.users;
}

- (BOOL)persistSession:(DangleSession *)session error:(NSError **)error
{
    self.session = session;
    return YES;
}

- (DangleSession *)persistedSessionWithError:(NSError **)error
{
    return self.session;
}

- (BOOL)deleteAllObjects:(NSError **)error
{
    self.users = nil;
    self.session = nil;
    return YES;
}

@end

@implementation DangleOnDiskPersistenceManager

- (id)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        _path = path;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDirectory;
        if ([fileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
            if (!isDirectory) {
                [NSException raise:NSInternalInconsistencyException format:@"Failed to initialize persistent store at '%@': specified path is a regular file.", path];
            }
        } else {
            NSError *error;
            BOOL success = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
            if (!success) {
                [NSException raise:NSInternalInconsistencyException format:@"Failed creating persistent store at '%@': %@", path, error];
            }
        }
    }
    return self;
}

- (BOOL)persistUsers:(NSSet *)users error:(NSError **)error
{
    NSString *path = [self usersPath];
    if (![NSKeyedArchiver archiveRootObject:users toFile:path]) return NO;
    self.users = users;
    return YES;
}

- (NSSet *)persistedUsersWithError:(NSError **)error
{
    if (self.users) return self.users;
    
    NSString *path = [self usersPath];
    NSSet *users = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    self.users = users;
    return users;
}

- (BOOL)deleteAllObjects:(NSError **)error
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager removeItemAtPath:[self usersPath] error:error]) return NO;
    self.users = nil;
    
    if (![fileManager removeItemAtPath:[self sessionPath] error:error]) return NO;
    self.session = nil;
    
    return YES;
}

- (BOOL)persistSession:(DangleSession *)session error:(NSError **)error
{
    NSString *path = [self sessionPath];
    self.session = session;
    return [NSKeyedArchiver archiveRootObject:session toFile:path];
}

- (DangleSession *)persistedSessionWithError:(NSError **)error
{
    if (self.session) return self.session;
    
    NSString *path = [self sessionPath];
    DangleSession *session = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    self.session = session;
    return session;
}

#pragma mark - Helpers

- (NSString *)usersPath
{
    return [self.path stringByAppendingPathComponent:DangleOnDiskPersistenceManagerUsersFileName];
}

- (NSString *)sessionPath
{
    return [self.path stringByAppendingPathComponent:DangleOnDiskPersistenceManagerSessionFileName];
}

@end
