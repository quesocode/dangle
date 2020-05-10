//
//  DangleLog.m
//  Dangle
//
//  Created by Me on 5/12/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#import "DangleLog.h"
#import "NSString+Mystic.h"

NSString * const mkLine = @"|-";
NSString * const mkLineMed = @"|-+";
NSString * const mkLineFat = @"|-++";
NSString * const mkLineThin= @"|--";
NSString * const mkLBlock= @"|&";
NSString * const mkLDouble= @"|=";
NSString * const mkLDots= @"|..";
NSString * const mkLStar= @"|*";


NSString * const mkLineKey = @"|-";
NSString * const mkLineMedKey = @"|-+";
NSString * const mkLineFatKey = @"|-++";
NSString * const mkLineThinKey= @"|--";
NSString * const mkLBlockKey= @"|&";
NSString * const mkLDoubleKey= @"|=";
NSString * const mkLDotsKey= @"|..";
NSString * const mkLStarKey= @"|*";


NSString * const mkLineIndent = @":-";
NSString * const mkLineMedIndent = @":-+";
NSString * const mkLineFatIndent = @":-++";
NSString * const mkLineThinIndent= @":--";
NSString * const mkLBlockIndent= @":&";
NSString * const mkLDoubleIndent= @":=";
NSString * const mkLDotsIndent= @":..";
NSString * const mkLStarIndent= @":*";

NSString * const mkLineFull = @" - ";
NSString * const mkLineMedFull = @" -+ ";
NSString * const mkLineFatFull = @" -++ ";
NSString * const mkLineThinFull= @" -- ";
NSString * const mkLBlockFull= @" & ";
NSString * const mkLDoubleFull= @" = ";
NSString * const mkLDotsFull= @" .. ";
NSString * const mkLStarFull= @" * ";

NSString * const mkLineSpaceNone= @"-";
NSString * const mkLineMedSpaceNone= @"-+";
NSString * const mkLineFatSpaceNone= @"-++";
NSString * const mkLineThinSpaceNone= @"--";
NSString * const mkLBlockSpaceNone= @"&";
NSString * const mkLDoubleSpaceNone= @"=";
NSString * const mkLDotsSpaceNone= @"..";
NSString * const mkLStarSpaceNone= @"*";

NSString* const mkLineSpaceAfter=@"- ";
NSString* const mkLineMedSpaceAfter=@"-+ ";
NSString* const mkLineFatSpaceAfter=@"-++ ";
NSString* const mkLineThinSpaceAfter=@"-- ";
NSString* const mkLBlockSpaceAfter=@"& ";
NSString* const mkLDoubleSpaceAfter=@"= ";
NSString* const mkLDotsSpaceAfter=@".. ";
NSString* const mkLStarSpaceAfter=@"* ";

NSString* const mkLineSpaceBefore=@" -";
NSString* const mkLineMedSpaceBefore=@" -+";
NSString* const mkLineFatSpaceBefore=@" -++";
NSString* const mkLineThinSpaceBefore=@" --";
NSString* const mkLBlockSpaceBefore=@" &";
NSString* const mkLDoubleSpaceBefore=@" =";
NSString* const mkLDotsSpaceBefore=@" ..";
NSString* const mkLStarSpaceBefore=@" *";



static NSString *indentStr = @"    ";

NSString * LLogStr(id __objs)
{
#ifdef DEBUG
    NSArray *_mobjs = __objs;
    NSString *d = indentStr;
    NSString *tab = @"   ";
    if([__objs isKindOfClass:[NSDictionary class]])
    {
        NSMutableArray *newObjs = [NSMutableArray array];
        NSArray *aKeys = [(NSDictionary *)__objs allKeys];
        NSArray *sortedKeys = [aKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        for (id k in sortedKeys) {
            [newObjs addObject:k];
            [newObjs addObject:[(NSDictionary *)__objs objectForKey:k]];
        }
        _mobjs = newObjs;
        
        
    }
    NSMutableArray *objs = [NSMutableArray array];
    [objs addObject:@" "];
    
    [objs addObjectsFromArray:_mobjs];
    [objs addObject:@" "];
    
    
    int longestKey = 0;
    NSString *longestKeyTxt = @"";
    NSMutableArray *_objs = [NSMutableArray array];
    for (int i = 0; i < objs.count; i++) {
        id key = [objs objectAtIndex:i];
        BOOL hasNextIndex = objs.count > i+1;
        //        id value = hasNextIndex ? [objs objectAtIndex:i+1] : nil;
        NSString *sKey = nil;
        if([key isKindOfClass:[NSString class]])
        {
            sKey = [key stringByReplacingOccurrencesOfString:@" " withString:@""];
            sKey = [sKey stringByReplacingOccurrencesOfString:@"|" withString:@""];
            sKey = [sKey stringByReplacingOccurrencesOfString:@":" withString:@""];
        }
        NSString *kPre = nil;
        NSString *kSuf = nil;
        NSString *_kPre = nil;
        NSString *_kSuf = nil;
        if(sKey && sKey.length < 6 && sKey.length > 0)
        {
            
            NSRange sKr = [key rangeOfString:sKey];
            
            
            if(sKr.location > 0)
            {
                
                _kPre = [key substringWithRange:NSMakeRange(0, sKr.location)];
                
            }
            
            if([(NSString *)key length] > sKr.location + sKr.length)
            {
                _kSuf = [key substringWithRange:NSMakeRange(sKr.location+sKr.length, [(NSString *)key length] - (sKr.location+sKr.length))];
                
                
                
            }
            //            DLog(@"Key: '%@'       sKey: '%@'         Prefix: '%@'      Suffix: '%@'", key, sKey, _kPre, _kSuf);
            
            
            
            if(_kPre && _kPre.length > 0)
            {
                
                NSMutableString *kPres = [NSMutableString stringWithString:@""];
                for (int x = 0; x < _kPre.length; x++) {
                    NSRange kRan = NSMakeRange(x, 1);
                    if(kRan.location == NSNotFound) break;
                    NSString *kc = [_kPre substringWithRange:kRan];
                    if(kc && [kc isEqualToString:@" "])
                    {
                        [kPres appendString:@"\n \n"];
                    }
                    if(kc && [kc isEqualToString:@"|"])
                    {
                        [kPres appendString:@"#|"];
                    }
                    if(kc && [kc isEqualToString:@":"])
                    {
                        [kPres appendString:@"#:"];
                    }
                }
                if(kPres.length > 0)
                {
                    kPre = [NSString stringWithString:kPres];
                }
            }
            
            if(_kSuf && _kSuf.length > 0)
            {
                NSMutableString *kSufs = [NSMutableString stringWithString:@""];
                for (int x = 0; x < _kSuf.length; x++) {
                    NSRange kRan = NSMakeRange(x, 1);
                    if(kRan.location == NSNotFound) break;
                    NSString *kc = [_kSuf substringWithRange:kRan];
                    if(kc && [kc isEqualToString:@" "])
                    {
                        [kSufs appendString:@"\n \n"];
                    }
                    if(kc && [kc isEqualToString:@"|"])
                    {
                        [kSufs appendString:@"#|"];
                    }
                }
                if(kSufs.length > 0)
                {
                    kSuf = [NSString stringWithString:kSufs];
                }
            }
            
            
        }
        kPre = kPre ? kPre : @"";
        kSuf = kSuf ? kSuf : @"";
        
        if([key isKindOfClass:[NSString class]] && [key isEqualToString:@" "])
        {
            [_objs addObject:@"#skip"];
            [_objs addObject:@""];
            
            
        }
        else if([key isKindOfClass:[NSString class]] && [key isEqualToString:@"  "])
        {
            [_objs addObject:@"#skip"];
            [_objs addObject:@""];
            [_objs addObject:@"#skip"];
            [_objs addObject:@""];
            
            
        }
        else if([key isKindOfClass:[NSString class]] && [key isEqualToString:@"   "])
        {
            [_objs addObject:@"#skip"];
            [_objs addObject:@""];
            [_objs addObject:@"#skip"];
            [_objs addObject:@""];
            [_objs addObject:@"#skip"];
            [_objs addObject:@""];
            
            
        }
        else if(sKey && ([sKey isEqualToString:mkLBlockSpaceNone]))
        {
            [_objs addObject:@"#skip"];
            [_objs addObject:[NSString stringWithFormat:@"%@#BLOCK#%@", kPre, kSuf]];
            
            
        }
        
        else if(sKey && ([sKey isEqualToString:mkLineMedSpaceNone]))
        {
            [_objs addObject:@"#skip"];
            [_objs addObject:[NSString stringWithFormat:@"%@#THICK#%@", kPre, kSuf]];
            
            
            
        }
        else if(sKey && ([sKey isEqualToString:mkLineFatSpaceNone]))
        {
            [_objs addObject:@"#skip"];
            [_objs addObject:[NSString stringWithFormat:@"%@#THICKER#%@", kPre, kSuf]];
            
            
            
        }
        
        else if(sKey && ([sKey isEqualToString:mkLineSpaceNone]))
        {
            [_objs addObject:@"#skip"];
            [_objs addObject:[NSString stringWithFormat:@"%@#LINE#%@", kPre, kSuf]];
            
            
        }
        
        
        else if(sKey && ([sKey isEqualToString:mkLineThinSpaceNone]))
        {
            [_objs addObject:@"#skip"];
            [_objs addObject:[NSString stringWithFormat:@"%@#THIN#%@", kPre, kSuf]];
            
            
        }
        
        
        else if(sKey && [sKey isEqualToString:mkLDotsSpaceNone])
        {
            [_objs addObject:@"#skip"];
            [_objs addObject:[NSString stringWithFormat:@"%@#DOTS#%@", kPre, kSuf]];
            
            
        }
        
        
        else if(sKey && [sKey isEqualToString:mkLStarSpaceNone])
        {
            [_objs addObject:@"#skip"];
            [_objs addObject:[NSString stringWithFormat:@"%@#STAR#%@", kPre, kSuf]];
            
            
        }
        
        
        else if(sKey && [sKey isEqualToString:mkLDoubleSpaceNone])
        {
            [_objs addObject:@"#skip"];
            [_objs addObject:[NSString stringWithFormat:@"%@#DLINE#%@", kPre, kSuf]];
            
            
        }
        
        else
        {
            id value = hasNextIndex ? [objs objectAtIndex:i+1] : nil;
            id newKey = key;
            if([newKey isKindOfClass:[NSString class]] && [newKey rangeOfString:@"%"].length != 0)
            {
                NSString *k = newKey;
                NSRange r = [k rangeOfString:@"%"];
                NSString *keyFormat = [k substringFromIndex:r.location];
                
                newKey = [k substringToIndex:r.location];
                
                if([value isKindOfClass:[NSNumber class]])
                {
                    if([keyFormat rangeOfString:@"%@"].length != 0)
                    {
                        value = [NSString stringWithFormat:keyFormat, value];
                        
                    }
                    else if([keyFormat rangeOfString:@"%d"].length != 0)
                    {
                        value = [NSString stringWithFormat:keyFormat, [value integerValue]];
                        
                    }
                    else if([keyFormat rangeOfString:@"f"].length != 0)
                    {
                        value = [NSString stringWithFormat:keyFormat, [value floatValue]];
                        
                    }
                }
            }
            newKey = [newKey stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]];
            [_objs addObject:newKey];
            [_objs addObject:value ? value : @""];
            
            longestKey = (int)MAX(longestKey, (int)[(NSString *)newKey length]);
            if(longestKey == [(NSString *)newKey length])
            {
                longestKeyTxt = newKey;
            }
            i++;
        }
        
    }
    longestKey += 4;
    NSMutableString *s = [NSMutableString stringWithString:@""];
    NSString *longestTxt = nil;
    NSArray *lineBrks = nil;
    int longestLine = 20;
    int longestLineNum = -1;
    
    int lineNum = 1;
    for (int i = 0; i < _objs.count; i++)
    {
        id key = [_objs objectAtIndex:i];
        BOOL hasNextIndex = _objs.count > i+1;
        id value = hasNextIndex ? [_objs objectAtIndex:i+1] : nil;
        if([key isEqualToString:@"#skip"])
        {
            if(value && [value isEqualToString:@""])
            {
                value = nil;
            }
            [s appendFormat:@"%@%@", value ? @"" : @"\n",  value ? value : @" "];
            
        }
        else
        {
            key = hasNextIndex ? [key stringByAppendingString:@""] : key;
            key = [key stringByPaddingToLength:longestKey withString:@" " startingAtIndex:0];
            if([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]])
            {
                value = [value description];
            }
            if(![value isKindOfClass:[NSString class]] && ![value isKindOfClass:[NSNumber class]] )
            {
                value = [value description];
            }
            
            if(value && [value isKindOfClass:[NSString class]])
            {
                value = [value stringByReplacingOccurrencesOfString:@"\n" withString:[NSString stringWithFormat:@"\n%@%@  ", d, [@" " stringByPaddingToLength:longestKey withString:@" " startingAtIndex:0]]];
            }
            NSString *keyValStr = [NSString stringWithFormat:(XCODE_COLORS_ESCAPE LOG_KEY_COLOR @"%@" XCODE_COLORS_RESET_FG   XCODE_COLORS_ESCAPE LOG_VALUE_COLOR "  %@%@" XCODE_COLORS_RESET_FG), key, value ? value : @"", d];
            NSString *kv2 = [NSString stringWithFormat:(@"%@  %@%@"), key, value ? value : @"", d];
            
            if([kv2 containsString:@"\n"])
            {
                lineBrks = [kv2 componentsSeparatedByString:@"\n"];
                for (NSString *brk in lineBrks)
                {
                    kv2 = [brk stringByReplacingOccurrencesOfString:@"\t" withString:tab];
                    longestLine = MAX(longestLine, (int)(kv2.length - d.length));
                    if(kv2.length == longestLine)
                    {
                        longestTxt = kv2; longestLineNum = lineNum;
                    }
                    
                }
            }
            else
            {
                kv2 = [kv2 stringByReplacingOccurrencesOfString:@"\t" withString:tab];
                longestLine = MAX(longestLine, (int)kv2.length);
                if(kv2.length == longestLine)
                {
                    longestTxt = kv2; longestLineNum = lineNum;
                }
            }
            
            [s appendFormat:@"\n%@%@", d, keyValStr];
            
        }
        
        i++;
        lineNum++;
        
    }
    
    longestLine = MAX(20, longestLine);
    
    
    //
//    NSString *nd = @"";
//    NSString *ns = [NSString stringWithString:s];
//    NSRange rr = NSMakeRange(0, s.length);
    
    
    NSString *k = [@" " repeat:longestKey];
    int a = MIN(350, longestLine);
    int b = a;
    int c = a - (longestKey+2) ;
    
    
    
    
    NSString *f = (@"\n%@%@  " XCODE_COLORS_ESCAPE LINE_COLOR @"%@\n" XCODE_COLORS_RESET_FG);
    [s replaceOccurrencesOfString:@"#:#BLOCK#" withString:[NSString stringWithFormat:f,d,k,[@"█" repeat:c]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#:#DLINE#" withString:[NSString stringWithFormat:f,d,k,[@"=" repeat:c]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#:#LINE#" withString:[NSString stringWithFormat:f,d,k,[@"─" repeat:c]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#:#THIN#" withString:[NSString stringWithFormat:f,d,k,[@"-" repeat:c]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#:#THICK#" withString:[NSString stringWithFormat:f,d,k,[@"█" repeat:c]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#:#THICKER#" withString:[NSString stringWithFormat:f,d,k,[@"█" repeat:c/2]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#:#DOTS#" withString:[NSString stringWithFormat:f,d,k,[@"∙" repeat:c]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#:#STAR#" withString:[NSString stringWithFormat:f,d,k,[@"x" repeat:c]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    
    f = (@"\n%@" XCODE_COLORS_ESCAPE LINE_COLOR @"%@" XCODE_COLORS_RESET_FG @"\n"); b+=2;
    [s replaceOccurrencesOfString:@"#|#BLOCK#" withString:[NSString stringWithFormat:f,d,[@"█" repeat:b]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#|#DLINE#" withString:[NSString stringWithFormat:f,d,[@"=" repeat:b]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#|#LINE#" withString:[NSString stringWithFormat:f,d,[@"─" repeat:b]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#|#THIN#" withString:[NSString stringWithFormat:f,d,[@"-" repeat:b]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#|#THICK#" withString:[NSString stringWithFormat:f,d,[@"█" repeat:b]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#|#THICKER#" withString:[NSString stringWithFormat:f,d,[@"█" repeat:b]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#|#DOTS#" withString:[NSString stringWithFormat:f,d,[@"∙" repeat:b]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#|#STAR#" withString:[NSString stringWithFormat:f,d,[@"x" repeat:b]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    
    f = (@"\n" XCODE_COLORS_ESCAPE LINE_COLOR @"%@" XCODE_COLORS_RESET_FG); int e= a + (int)d.length;
    [s replaceOccurrencesOfString:@"#BLOCK#" withString:[NSString stringWithFormat:f,[@"█" repeat:e]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#DLINE#" withString:[NSString stringWithFormat:f,[@"=" repeat:e]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#LINE#" withString:[NSString stringWithFormat:f,[@"─" repeat:e]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#THIN#" withString:[NSString stringWithFormat:f,[@"-" repeat:e]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#THICK#" withString:[NSString stringWithFormat:f,[@"█" repeat:e]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#THICKER#" withString:[NSString stringWithFormat:f,[@"█" repeat:e]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#DOTS#" withString:[NSString stringWithFormat:f,[@"∙" repeat:e]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#STAR#" withString:[NSString stringWithFormat:f,[@"x" repeat:e]] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    [s replaceOccurrencesOfString:@"#|" withString:d options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
    
    NSMutableString *s2 = s;
    if([s containsString:@"\n"])
    {
        s2 = [[NSMutableString alloc] initWithString:@""];
        NSArray *lineBrks = [s componentsSeparatedByString:@"\n"];
        int i = 1;
        int x = 0;
        NSMutableArray *ar = [NSMutableArray array];
        for (NSString *_line in lineBrks)
        {
            NSString *line = _line;
            if(line.length > 0 && ![line isEqualToString:@" "])
            {
                line = [line stringByReplacingOccurrencesOfString:@"\t" withString:tab];
                NSString *l2 = [line stringByReplacingOccurrencesOfString:(XCODE_COLORS_RESET_FG) withString:@""];
                l2 = [l2 stringByReplacingOccurrencesOfString:(LINE_COLOR) withString:@""];
                l2 = [l2 stringByReplacingOccurrencesOfString:(LOG_KEY_COLOR) withString:@""];
                l2 = [l2 stringByReplacingOccurrencesOfString:(LOG_VALUE_COLOR) withString:@""];
                l2 = [l2 stringByReplacingOccurrencesOfString:(XCODE_COLORS_RESET_BG) withString:@""];
                l2 = [l2 stringByReplacingOccurrencesOfString:(XCODE_COLORS_RESET) withString:@""];
                l2 = [l2 stringByReplacingOccurrencesOfString:(XCODE_COLORS_ESCAPE) withString:@""];
                
                
                //                NSLog(@"Line #%d: %d  |  '%@'", i, (int)l2.length, [l2 stringByReplacingOccurrencesOfString:@"[" withString:@"^"]);
                
                x = MAX(x, (int)l2.length);
                
                [ar addObject:@{@"string": line, @"length": @(l2.length), @"line": @(i)}];
                
                
            }
            else if([line isEqualToString:@" "])
            {
                [ar addObject:@{@"string": line, @"length": @(1), @"line": @(i)}];
                
            }
            //            NSLog(@"Line %d:   %d '%@'", i,(int) line.length, line);
            
            i++;
            
        }
        for (NSDictionary *o in ar)
        {
            NSString *line = o[@"string"];
            int l = (int)[o[@"length"] integerValue];
            int diff0 = (x - l);
            int diff = diff0;
            if(diff == 0 || diff > 1)
            {
                diff += 3;
            }
            else if(diff == 1)
            {
                diff = 2;
            }
            
            NSString *newLine = [line stringByAppendingString:[@" " repeat:diff0]];
            
            
            //            [s2 appendFormat:(@"\n" XCODE_COLORS_ESCAPE LOG_BG_COLOR @"%@" XCODE_COLORS_RESET_BG @"   |  Max: %d  |  L: %d  |  Diff: %d  |  New: %d"), newLine,  x, l, diff0, (int)newLine.length  ];
            [s2 appendFormat:(@"\n" XCODE_COLORS_ESCAPE LOG_BG_COLOR @"%@" XCODE_COLORS_RESET_BG), newLine];
            
            
        }
        s = nil;
    }
    
    
    return s2;
#else
    return nil;
#endif
}
NSString *ALLogStrf(NSString *format, id objs) {
    NSString *l = LLogStr(objs);
    NSString *l2 = [NSString stringWithFormat:@"%@ \n%@\n\n", format, l];
    return l2;
}

NSString *ALLogStr(id objs) {
    NSString *l = LLogStr(objs);
    return l;
}
void ALog(NSString *format, id objs) {
    
#ifdef DEBUG
    
    NSString *l = LLogStr(objs);
    
    NSString *tabStr = [NSString stringWithFormat:(XCODE_COLORS_ESCAPE LOG_HEADER_BG_COLOR @"%@" XCODE_COLORS_RESET_BG), [@" " repeat:(format.length + (indentStr.length*2))]];
    format = [NSString stringWithFormat:@"%@\n" XCODE_COLORS_RESET_FG XCODE_COLORS_ESCAPE LOG_HEADER_FG_COLOR XCODE_COLORS_ESCAPE LOG_HEADER_BG_COLOR "%@%@%@" XCODE_COLORS_RESET_BG XCODE_COLORS_RESET_FG  @"\n%@", tabStr, indentStr, [format uppercaseString], indentStr,  tabStr];
    DLog( @"\n%@" @"%@%@", format, [l hasPrefix:@"\n"] ? @"" : @"\n", l);
#endif
}
void LLog(NSString *format, id objs) {
    NSMutableString *newContentString = [NSMutableString stringWithString:format];
    
    for (NSString *key in [objs allKeys]) {
        [newContentString appendFormat:@" \n\t %@:  %@", key, [objs objectForKey:key] ];
    }
    
    DLog(@"%@", newContentString);
    
}