//
//  DangleUtilities.h
//  Dangle
//
//  Created by Me on 5/18/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#ifndef Dangle_DangleUtilities_h
#define Dangle_DangleUtilities_h

#import "Dangle.h"
#import "DanglePersistenceManager.h"

BOOL DangleIsRunningTests();

NSURL *DangleAPIBaseURL();

NSString *DangleApplicationDataDirectory();

UIAlertView *DangleAlertWithError(NSError *error);

#endif
