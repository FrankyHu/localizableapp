//
//  LFSourceCodeParser.h
//  firstApp
//
//  Created by Hu Chin-Hao on 2/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LFSourceCodeParser : NSObject {
	NSMutableArray *_displaylist;
}
- (void)parse:(NSString *)filePath;
- (NSMutableArray *)getDisplaylist;
@end