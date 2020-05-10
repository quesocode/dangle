//
//  NSString+Mystic.m
//  Mystic
//
//  Created by Travis on 10/13/13.
//  Copyright (c) 2013 Blackpulp. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>

#import "NSString+Mystic.h"


@implementation NSString (Mystic)

+ (NSString *) md5:(NSString *) input;
{
    return [input md5];
}
- (NSString *) md5;
{
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
- (NSString *) debugStringLine:(int)length;
{
    return [self stringByPaddingToLength:length withString:@"." startingAtIndex:0];
}

- (NSString *) shorten:(int)max suffix:(NSString *)sf;
{
    
    if(self.length <= max) return self;
    sf = sf ? sf : @"...";
    return [[self substringToIndex:max-sf.length] stringByAppendingString:sf];
}

- (void) copyToClipboard;
{
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:self];
}

- (NSString *) capitalizedWordsString;
{
    __block NSMutableString *result = [self mutableCopy] ;
    __block int l = (int)[result length];
    [result enumerateSubstringsInRange:NSMakeRange(0, l)
                               options:NSStringEnumerationByWords
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                [result replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                      withString:[[substring substringToIndex:1] uppercaseString]];
                                
                                if(enclosingRange.location + enclosingRange.length >= l)
                                {
                                    *stop = YES;
                                }
                                
                                
                                
                            }];
    return result;
}

- (NSString *)repeat:(NSUInteger)times {
    return [@"" stringByPaddingToLength:times * [self length] withString:self startingAtIndex:0];
}

@end
