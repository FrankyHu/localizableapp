//
//  LFMyController+ParserDelegate.h
//  firstApp
//
//  Created by Hu Chin-Hao on 2/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "LFMyController.h"

@interface LFMyController(ParserDelegate)
/*!
 @method     
 @abstract   parse the .m files in the directory
 @discussion none
 */
- (void)parse:(NSString *)filePath;
@end