//
//  LFLocalizableStringsParser.m
//  Localizable App
//
//  Created by Hu Chin-Hao on 2/12/09.
//  Copyright 2009 Lithoglyph Inc. All rights reserved.
//

#import "LFLocalizableStringsParser.h"


@implementation LFLocalizableStringsParser
- (void)parse:(NSString *)filePath
{
	_stringList = [NSMutableArray new];
	BOOL isComment = NO;
	int i = 0, j = 0;
	int k = 0;
	NSString *s= [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	//Scan the Localizabile pair
	NSMutableString *lastComment = [NSMutableString new];
	for (i = 0; i < [s length]; i++) {
		NSLog(@"%d",i);
		NSMutableArray *array = [NSMutableArray new];
		NSMutableString *param1 = [NSMutableString string];
		NSMutableString *param2 = [NSMutableString string];
		//Search for comment
		for (j = i; j < [s length]; j++) {
			if (j + 2 < [s length]) {
				if ([[s substringWithRange:NSMakeRange(j, 2)] isEqualToString:@"/*"]) {
					isComment = YES;
					lastComment = [NSMutableString new];
					for (k = j + 2; k < [s length]; k++) {
						if (k + 2 < [s length]) {
							if ([[s substringWithRange:NSMakeRange(k, 2)] isEqualToString:@"*/"]) {
								isComment = NO;
								i = k + 2;
								break;
							}
							[lastComment appendFormat:@"%C",[s characterAtIndex:k]];
						}
					}
				}	
			}
			break;
		}
		NSLog(@"%d",i);
		if ([s characterAtIndex:i] == '"' && [s characterAtIndex:i-1] != '\\' && !isComment) {
			//First param
			for (j = i + 1; j < [s length]; j++) {
				if ([s characterAtIndex:j] == '"' && [s characterAtIndex:j-1] != '\\') {
					i = j;
					break;
				}
				[param1 appendFormat:@"%C",[s characterAtIndex:j]];
			}
			//2nd param
			for (j = i + 1; j < [s length]; j++) {
				if ([s characterAtIndex:j] == '"' && [s characterAtIndex:j-1] != '\\') {
					i = j;
					break;
				}
			}
			for (j = i + 1; j < [s length]; j++) {
				if ([s characterAtIndex:j] == '"' && [s characterAtIndex:j-1] != '\\') {
					i = j;
					break;
				}
				[param2 appendFormat:@"%C",[s characterAtIndex:j]];
			}
			[array addObject:param1];
			[array addObject:param2];
			[array addObject:lastComment];
			NSLog(@"%@",array);
			[_stringList addObject:array];
		}
	}
}

- (NSMutableArray *)stringList
{
	return [[_stringList retain] autorelease];
}

@end
