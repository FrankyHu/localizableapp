//
//  LFLprojParser.m
//  Localizable App
//
//  Created by Hu Chin-Hao on 2/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LFLprojParser.h"


@implementation LFLprojParser
- (BOOL)parse:(NSString *)filePath
{
	BOOL found = NO;
	_directoryList = [NSMutableDictionary new];
	NSString *file;
	//Scan for macro LFLSTR in project directory
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:filePath];
	while (file = [dirEnum nextObject]) {
		NSRange rangeForLproj = [file rangeOfString : @"lproj"];
		NSRange rangeForBuild = [file rangeOfString : @"build"];
		if ((rangeForLproj.location != NSNotFound) && (rangeForBuild.location == NSNotFound)) {
			found = YES;
			NSString *lproj = [NSString stringWithString:[file substringWithRange:NSMakeRange(0, (rangeForLproj.location - 1))]];
			[_directoryList setObject:lproj forKey:lproj];
		}
	}
	return found;
}
- (NSMutableDictionary *)directoryList
{
	return [[_directoryList retain] autorelease];
}
@end
