//
//  NSArray+Mystic.m
//  Mystic
//
//  Created by travis weerts on 1/24/13.
//  Copyright (c) 2013 Blackpulp. All rights reserved.
//
#include <stdlib.h>
#import "NSArray+Mystic.h"

@implementation NSArray (Mystic)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

- (NSDictionary *) objectAtRandomIndexExcept:(NSInteger)i;
{
    int r = 0;
    int c = (int)self.count;
    
    if(!(i == 0 && c == 1))
    {

//        r = c+1;
        r = (int)i;
        while(r == i)
        {
            if (&arc4random_uniform != NULL)
            {
                r = arc4random_uniform (c);
            }
//            else
//            {
//                r = (arc4random() % c);
//            }
            r = MIN((int)self.count - 1, r);
            r = MAX(0, r);
            
            
       

        }
    }
    int r2 = MIN((int)self.count - 1, r);
    r2 = MAX(0, r2);
 
    
    return @{@"index":@(r2), @"value": self.count > r2 ?  [self objectAtIndex:r2] : [NSNull null]};
}
- (id) objectAtRandomIndex;
{
    int r = 0;
    int c = (int)self.count;
    if (&arc4random_uniform != NULL)
        r = arc4random_uniform (c);
//    else
//        r = (arc4random() % c);
    
    return [self objectAtIndex:r];
}

- (NSString *) enumerateDescription:(MysticBlockArrayString)block;
{
    NSMutableString *str = [NSMutableString stringWithString:@""];
    
    for (id obj in self) {
        NSString *s = block(obj);
        [str appendFormat:@"\n%@", s ? s : @"---"];
    }
    
    return str;
}

- (NSArray *)shuffledArray;
{
    NSMutableArray *shuffledArray = [self mutableCopy] ;
    NSUInteger arrayCount = [shuffledArray count];
    
    for (NSUInteger i = arrayCount - 1; i > 0; i--) {
        NSUInteger n = arc4random_uniform((u_int32_t)(i + 1));
        [shuffledArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return shuffledArray ;
}

- (NSArray *)shuffledArrayWithItemLimit:(NSUInteger)itemLimit;
{
    if (!itemLimit) return [self shuffledArray];
    
    NSMutableArray *shuffledArray = [self mutableCopy] ;
    NSUInteger arrayCount = [shuffledArray count];
    
    NSUInteger loopCounter = 0;
    for (NSUInteger i = arrayCount - 1; i > 0 && loopCounter < itemLimit; i--) {
        NSUInteger n = arc4random_uniform((u_int32_t)(i + 1));
        [shuffledArray exchangeObjectAtIndex:i withObjectAtIndex:n];
        loopCounter++;
    }
    
    NSArray *arrayWithLimit;
    if (arrayCount > itemLimit) {
        NSRange arraySlice = NSMakeRange(arrayCount - loopCounter, loopCounter);
        arrayWithLimit = [shuffledArray subarrayWithRange:arraySlice];
    } else
        arrayWithLimit = [shuffledArray copy] ;
    
    return arrayWithLimit;
}


@end

@implementation NSMutableArray (Mystic)

- (void)reverse {
    if ([self count] == 0)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

@end
