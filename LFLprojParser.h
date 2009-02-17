//
//  LFLprojParser.h
//  Localizable App
//
//  Created by Hu Chin-Hao on 2/12/09.
//  Copyright 2009 Lithoglyph Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*!
 @class
 @abstract    LFLprojParser
 @discussion  Find the lproj directory under current directory
 */
@interface LFLprojParser : NSObject {
	NSMutableDictionary *_directoryList;
}

/*!
 @method     
 @abstract   filePath
 @discussion 
 */
- (BOOL)parse:(NSString *)filePath;

/*!
 @method     
 @abstract   directoryList
 @discussion Return directoryList
 */
- (NSMutableDictionary *)directoryList;
@end
