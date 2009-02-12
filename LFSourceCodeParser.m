//
//  LFSourceCodeParser.m
//  firstApp
//
//  Created by Hu Chin-Hao on 2/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LFSourceCodeParser.h"


@implementation LFSourceCodeParser

- (void)parse:(NSString *)filePath
{
	_displaylist = [NSMutableArray new];
	NSMutableArray * array = [NSMutableArray new];
	NSString *file;
	NSString *path;
	NSString *aStr;
	NSString *searchForLFLSTR = @"LFLSTR";
	NSString *searchForLFLSTR2 = @"LFLSTR2";
	const NSString *s;
	int i, j;
	BOOL end = NO;
	//Scan for macro LFLSTR in project directory
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:filePath];
	while (file = [dirEnum nextObject]) {
		if ([[file pathExtension] isEqualToString: @"m"]) {
			path = [filePath stringByAppendingPathComponent:file];
			aStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
			NSRange rangeForLFLSTR = [aStr rangeOfString : searchForLFLSTR];
			NSRange rangeForLFLSTR2 = [aStr rangeOfString : searchForLFLSTR2];
			if ( (rangeForLFLSTR.location != NSNotFound) || (rangeForLFLSTR2.location != NSNotFound) ) {
				[array addObject:path];
				s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
				//Looking for LFLSTR
				for (i = 0 ;i < [s length] ;i++ ) {
					if ([s characterAtIndex:i] == 'L') {
						if((i + 6) < [s length] && [[s substringWithRange:NSMakeRange(i, 9)] isEqualToString:@"LFLSTR(@\""]) {
							NSMutableString *param = [NSMutableString string];
							i += 9;
							end = NO;
							for (j = 0; !end; j++){
								if (i + j >= [s length]) {
									break;
								}
								if ([s characterAtIndex:(i+j)] == '"' && [s characterAtIndex:(i+j-1)] != '\\' ) {
									end = YES;
									continue;
								}
								[param appendFormat:@"%C",[s characterAtIndex:(i+j)]];
							}
							i += j;
							NSMutableArray *col = [NSMutableArray new];
							[col addObject:param];
							[col addObject:param];
							[col addObject:@""];
							[col addObject:file];
							[_displaylist addObject:col];
						}
					}
				}
				//Looking for LFLSTR2
				for (i = 0 ;i < [s length] ;i++ ) {
					if ([s characterAtIndex:i] == 'L'){
						if((i + 7) < [s length] && [[s substringWithRange:NSMakeRange(i, 10)] isEqualToString:@"LFLSTR2(@\""]) {
							NSMutableString *param1 = [NSMutableString string];
							NSMutableString *param2 = [NSMutableString string];
							i += 10;
							end = NO;
							for (j = 0; !end; j++){
								if (i + j >= [s length]) {
									break;
								}
								if ([s characterAtIndex:(i+j)] == '"' && [s characterAtIndex:(i+j-1)] != '\\' ) {
									end = YES;
									continue;
								}
								[param1 appendFormat:@"%C",[s characterAtIndex:(i+j)]];
							}
							i = i + j + 3;
							end = NO;
							//',' '@' '"'
							for (j = 0; !end; j++) {
								if (i + j >= [s length]) {
									break;
								}
								if ([s characterAtIndex:(i+j)] == '"' && [s characterAtIndex:(i+j-1)] != '\\' ) {
									end = YES;
									continue;
								}
								[param2 appendFormat:@"%C",[s characterAtIndex:(i+j)]];
							}
							i = i + j;
							NSMutableArray *col = [NSMutableArray new];
							[col addObject:param1];
							[col addObject:param1];
							[col addObject:param2];
							[col addObject:file];
							[_displaylist addObject:col];
						}
					}
				}		
			}
		}
	}
	for (i = 0; i < [_displaylist count]; i++) {
		for (j = 0; j < [_displaylist count]; j++) {
			if (i != j) {
				if ( [[[_displaylist objectAtIndex:i] objectAtIndex:0] isEqualToString:[[_displaylist objectAtIndex:j] objectAtIndex:0]] ) {
					[[_displaylist objectAtIndex:i] addObject:@"isRepeat"];
				}
			} else {
				[[_displaylist objectAtIndex:i] addObject:@"notRepeat"];
			}
		}
	}
	for (i = 0; i < [_displaylist count]; i++) {
		
		if( [[_displaylist objectAtIndex:i] count] == 4 ) {
			[[_displaylist objectAtIndex:i] addObject:@"notRepeat"];
		}
	}
}

- (NSMutableArray *)Displaylist
{
	return [[_displaylist retain] autorelease];
}


@end
