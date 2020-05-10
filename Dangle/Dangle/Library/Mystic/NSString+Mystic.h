//
//  NSString+Mystic.h
//  Mystic
//
//  Created by Travis on 10/13/13.
//  Copyright (c) 2013 Blackpulp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Mystic)

+ (NSString *) md5:(NSString *) input;
- (NSString *) md5;

- (NSString *) debugStringLine:(int)length;
- (NSString *) capitalizedWordsString;
- (NSString *) shorten:(int)max suffix:(NSString *)sf;
- (void) copyToClipboard;
- (NSString *) repeat:(NSUInteger)times;

@end
