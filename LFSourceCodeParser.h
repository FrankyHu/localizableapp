//
//  LFSourceCodeParser.h
//  Localizable App
//
//  Created by Hu Chin-Hao on 2/10/09.
//  Copyright 2009 Lithoglyph Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*!
 @class
 @abstract    LFSourceCodeParser
 @discussion  Parse the source code, and find LFLSTR and LFLSTR2
 */
@interface LFSourceCodeParser : NSObject {
	NSMutableArray *_displaylist;
}

/*!
 @method     
 @abstract   filePath
 @discussion 
 */
- (void)parse:(NSString *)filePath;

/*!
 @method     
 @abstract   Displaylist
 @discussion Return Displaylist 
 */
- (NSMutableArray *)Displaylist;
@end
