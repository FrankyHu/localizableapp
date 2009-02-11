//
//  LFMyController.h
//  firstApp
//
//  Created by Hu Chin-Hao on 2/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SynthesizeSingleton.h"
#import "LFSourceCodeParser.h"
#import "LFLanguageViewController.h"
#import "LFFileViewController.h"
/*!
    @class
    @abstract    LFMyController is the main class of LocalizableApp
    @discussion  none
*/
@interface LFMyController : NSPersistentDocument
{
	IBOutlet NSTableView *_view;
	IBOutlet NSPopUpButton *_popUp;
	IBOutlet NSBox *_box;
	NSMutableArray *_viewControllers;
	NSMutableArray *_backgroundList;
	NSMutableArray *_displaylist;
	NSMutableArray *_langArray;
	NSMutableString *_selectedDirectory;
	LFSourceCodeParser *_parser;	
}

/*!
 @method     
 @abstract   setFileToDisplay
 @discussion none
 */
+ (void)setFileToDisplay:(NSString *)fileName;

/*!
 @method     
 @abstract   setLang
 @discussion none
 */
+ (void)setLang:(NSString *)name;

/*!
 @method     
 @abstract   getFileDict
 @discussion none
 */
+ (NSMutableDictionary *)getFileDict;

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
 @abstract   changeViewController
 @discussion none
 */
- (IBAction)changeViewController:(id)sender;

/*!
 @method     
 @abstract   reloadView
 @discussion none
 */
- (IBAction)reloadView:(id)sender;
@end
