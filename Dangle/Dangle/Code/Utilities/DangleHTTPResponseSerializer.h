//
//  DangleHTTPResponseSerializer.h
//  Atlas Messenger
//
//  Created by Blake Watters on 6/28/14.
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

extern NSString *const DangleHTTPResponseErrorDomain;

typedef NS_ENUM(NSUInteger, DangleHTTPResponseError) {
    DangleHTTPResponseErrorInvalidContentType,
    DangleHTTPResponseErrorUnexpectedStatusCode,
    DangleHTTPResponseErrorClientError,
    DangleHTTPResponseErrorServerError
};

/**
 @abstract The `DangleHTTPResponseSerializer` provides a simple interface for deserializing HTTP responses created in the `DangleAPIManager`.
 */
@interface DangleHTTPResponseSerializer : NSObject

/**
 @abstract Deserializes an HTTP response.
 @param object A reference to an object that will contain the deserialized response data.
 @param data The serialized HTTP response data received from an operation's request.
 @param response The HTTP response object received from an operation's request.
 @param error A reference to an `NSError` object that will contain error information in case the action was not successful.
 @return A boolean value indicating if the operation was successful.
 */
+ (BOOL)responseObject:(id *)object withData:(NSData *)data response:(NSHTTPURLResponse *)response error:(NSError **)error;

@end
