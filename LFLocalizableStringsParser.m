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
	//BOOL isComment = NO;
	int i = 0, j = 0;
	//int k = 0;
	NSString *s= [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	//Scan the comment on the top of the file, if not then break
//	for (i = 0; i < [s length]; i++) {
//		if ([s characterAtIndex:i] == '"') {
//			break;
//		}
//		if ([[s substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"/*"]) {
//			for (j = i + 2; j < [s length]; j++) {
//				if ([[s substringWithRange:NSMakeRange(j, 2)] isEqualToString:@"*/"]) {
//					break;
//				}
//			}
//		}
//		break;
//	}
	//Scan the Localizabile pair
	for (i = i + j + 1; i < [s length]; i++) {
		NSMutableArray *array = [NSMutableArray new];
		NSMutableString *param1 = [NSMutableString string];
		NSMutableString *param2 = [NSMutableString string];
//		NSMutableString *param3 = [NSMutableString string];
		if ([s characterAtIndex:i] == '"' && [s characterAtIndex:i-1] != '\\') {
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
			//Search for comment
//			for (j = i + 1; j < [s length]; j++) {
//				if (j + 2 < [s length]) {
//					if ([[s substringWithRange:NSMakeRange(j, 2)] isEqualToString:@"/*"]) {
//						isComment = YES;
//						for (k = j + 2; k < [s length]; k++) {
//							if (k + 2 < [s length]) {
//								if ([[s substringWithRange:NSMakeRange(k, 2)] isEqualToString:@"*/"]) {
//									i = j + 2;
//									break;
//								}
//								[param3 appendFormat:@"%C",[s characterAtIndex:k]];
//							}
//						}
//					}	
//				}
//				
//				break;
//			}
//			if (!isComment) {
//				//no comment
//				[param3 appendString:@""];
//			}
			[array addObject:param1];
			[array addObject:param2];
//			[array addObject:param3];
			[_stringList addObject:array];
		}
	}
}

- (NSMutableArray *)stringList
{
	return [[_stringList retain] autorelease];
}

@end
