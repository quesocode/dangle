//
//  DangleErrors.h
//  Atlas Messenger
//
//  Created by Kevin Coleman on 9/26/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>

extern NSString *const DangleErrorDomain;

typedef NS_ENUM(NSUInteger, DangleAuthenticationError) {
    DangleErrorUnknownError                            = 7000,
    
    /* Messaging Errors */
    DangleInvalidFirstName                              = 7001,
    DangleInvalidLastName                               = 7002,
    DangleInvalidEmailAddress                           = 7003,
    DangleInvalidPassword                               = 7004,
    DangleInvalidAuthenticationNonce                    = 7005,
    DangleNoAuthenticatedSession                        = 7006,
    DangleRequestInProgress                             = 7007,
    DangleInvalidAppIDString                            = 7008,
    DangleInvalidAppID                                  = 7009,
    DangleInvalidIdentityToken                          = 7010,
    DangleDeviceTypeNotSupported                       = 7011,
};
