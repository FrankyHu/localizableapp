//
//  LFLocalizableStringsParser.h
//  Localizable App
//
//  Created by Hu Chin-Hao on 2/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*!
 @class
 @abstract    LFLocalizableStringsParser
 @discussion  
 */
@interface LFLocalizableStringsParser : NSObject {
	NSMutableArray *_stringList;
}

/*!
 @method     
 @abstract   filePath
 @discussion 
 */
- (void)parse:(NSString *)filePath;

/*!
 @method     
 @abstract   stringList
 @discussion Return stringList
 */
- (NSMutableArray *)stringList;

@end
