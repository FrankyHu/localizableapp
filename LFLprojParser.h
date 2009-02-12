//
//  LFLprojParser.h
//  Localizable App
//
//  Created by Hu Chin-Hao on 2/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LFLprojParser : NSObject {
	NSMutableDictionary *_directoryList;
}
- (BOOL)parse:(NSString *)filePath;
- (NSMutableDictionary *)directoryList;
@end
