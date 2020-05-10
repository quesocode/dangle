//
//  DangleUtilities.m
//  Dangle
//
//  Created by Me on 5/18/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DanglePersistenceManager.h"
#import "DangleUtilities.h"

BOOL DangleIsRunningTests(void)
{
    return NSClassFromString(@"XCTestCase") != Nil;
}

NSURL *DangleAPIBaseURL(void)
{
    if (DangleIsRunningTests()){
        return [NSURL URLWithString:@"http://dangle.io/api"];
    } else {
        return [NSURL URLWithString:@"http://dangle.io/api"];
    }
}

NSString *DangleApplicationDataDirectory(void)
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths.firstObject;
}

UIAlertView *DangleAlertWithError(NSError *error)
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unexpected Error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    return alertView;
}