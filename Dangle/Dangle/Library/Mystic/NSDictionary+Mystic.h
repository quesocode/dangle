//
//  NSDictionary+Merge.h
//  Mystic
//
//  Created by travis weerts on 3/29/13.
//  Copyright (c) 2013 Blackpulp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Mystic)

+ (NSDictionary *) dictionaryByMerging: (NSDictionary *) dict1 with: (NSDictionary *) dict2;
- (NSDictionary *) dictionaryByMergingWith: (NSDictionary *) dict;
-(NSString*) urlEncodedString;

@end