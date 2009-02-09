//
//  LFMyController.h
//  firstApp
//
//  Created by Hu Chin-Hao on 2/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
/*!
    @class
    @abstract    LFMyController is the main class of LocalizableApp
    @discussion  none
*/
@interface LFMyController : NSWindowController 
{
	IBOutlet NSTableView *_view;
	IBOutlet NSArrayController *_arrayController;
	IBOutlet NSTextField *currentLang;
	NSMutableArray *_displaylist;
	NSMutableArray *_langArray;
	NSMutableString *_selectedDirectory;
	NSMutableString *_selectedLang;
}

/*!
 @method     
 @abstract   addObjectWithName
 @discussion none
 */
- (void)addObjectWithName:(NSString *)name;

/*!
 @method     
 @abstract   initWithCoder
 @discussion none
 */
- (id)initWithCoder:(NSCoder *)decoder;

/*!
 @method     
 @abstract   openFile, select the directory
 @discussion This method will call parse
 */
- (IBAction)openFile:(id)sender;

/*!
 @method     
 @abstract   saveFile, save the file to Localizable.strings
 @discussion none
 */
- (IBAction)saveFile:(id)sender;

/*!
 @method     
 @abstract   showLang
 @discussion none
 */
- (IBAction)showLang:(id)sender;

@end
