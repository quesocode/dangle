//
//  DangleLog.h
//  Dangle
//
//  Created by Me on 5/12/15.
//  Copyright (c) 2015 Dangle. All rights reserved.
//

#ifndef Dangle_DangleLog_h
#define Dangle_DangleLog_h

#import <Foundation/Foundation.h>
#import "MysticFunctions.h"


extern NSString * const mkLine;
extern NSString * const mkLineMed;
extern NSString * const mkLineFat;
extern NSString * const mkLineThin;
extern NSString * const mkLBlock;
extern NSString * const mkLDouble;
extern NSString * const mkLDots;
extern NSString * const mkLStar;

extern NSString * const mkLineKey;
extern NSString * const mkLineMedKey;
extern NSString * const mkLineFatKey;
extern NSString * const mkLineThinKey;
extern NSString * const mkLBlockKey;
extern NSString * const mkLDoubleKey;
extern NSString * const mkLDotsKey;
extern NSString * const mkLStarKey;

extern NSString * const mkLineIndent;
extern NSString * const mkLineMedIndent;
extern NSString * const mkLineFatIndent;
extern NSString * const mkLineThinIndent;
extern NSString * const mkLBlockIndent;
extern NSString * const mkLDoubleIndent;
extern NSString * const mkLDotsIndent;
extern NSString * const mkLStarIndent;

extern NSString * const mkLineFull;
extern NSString * const mkLineMedFull;
extern NSString * const mkLineFatFull;
extern NSString * const mkLineThinFull;
extern NSString * const mkLBlockFull;
extern NSString * const mkLDoubleFull;
extern NSString * const mkLDotsFull;
extern NSString * const mkLStarFull;

extern NSString * const mkLineSpaceNone;
extern NSString * const mkLineMedSpaceNone;
extern NSString * const mkLineFatSpaceNone;
extern NSString * const mkLineThinSpaceNone;
extern NSString * const mkLBlockSpaceNone;
extern NSString * const mkLDoubleSpaceNone;
extern NSString * const mkLDotsSpaceNone;
extern NSString * const mkLStarSpaceNone;

extern NSString * const mkLineSpaceAfter;
extern NSString * const mkLineMedSpaceAfter;
extern NSString * const mkLineFatSpaceAfter;
extern NSString * const mkLineThinSpaceAfter;
extern NSString * const mkLBlockSpaceAfter;
extern NSString * const mkLDoubleSpaceAfter;
extern NSString * const mkLDotsSpaceAfter;
extern NSString * const mkLStarSpaceAfter;

extern NSString * const mkLineSpaceBefore;
extern NSString * const mkLineMedSpaceBefore;
extern NSString * const mkLineFatSpaceBefore;
extern NSString * const mkLineThinSpaceBefore;
extern NSString * const mkLBlockSpaceBefore;
extern NSString * const mkLDoubleSpaceBefore;
extern NSString * const mkLDotsSpaceBefore;
extern NSString * const mkLStarSpaceBefore;

void LLog(NSString *format, id objs);
NSString * LLogStr(NSArray *objs);
void ALog(NSString *format, id objs);
NSString *ALLogStr(id objs);
NSString *ALLogStrf(NSString *format, id objs);

#endif
