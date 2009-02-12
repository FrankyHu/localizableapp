//
//  LFLocalizableStringsParser.h
//  Localizable App
//
//  Created by Hu Chin-Hao on 2/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LFLocalizableStringsParser : NSObject {
	NSMutableArray *_stringList;
}
- (void)parse:(NSString *)filePath;
- (NSMutableArray *)stringList;

@end
