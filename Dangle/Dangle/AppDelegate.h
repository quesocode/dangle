//
//  AppDelegate.h
//  Dangle
//
//  Created by Travis Weerts on 5/7/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Dangle.h"
#import "DangleApplicationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, DangleDeviceDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) DangleApplicationController *applicationController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

