//
//  LFMyController.h
//  firstApp
//
//  Created by Hu Chin-Hao on 2/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LFLocalizableStringsParser.h"
#import "LFSourceCodeParser.h"
#import "LFLprojParser.h"
/*!
    @class
    @abstract    LFMyController is the main class of LocalizableApp
    @discussion  none
*/
@interface LFMyController : NSWindowController
{
	IBOutlet NSTableView *_view;
	IBOutlet NSView *_openFileView;
	IBOutlet NSArrayController *_arrayController;
	IBOutlet NSTextField *_addLprojText;
	IBOutlet NSButton *_addLprojButton;
	IBOutlet NSPopUpButton *_langPopUp;
	NSMutableArray *_localizedArray;
	NSMutableArray *_stringList;
	NSMutableArray *_backgroundList;
	NSMutableArray *_displaylist;
	NSMutableArray *_langArray;
	NSMutableDictionary *_fileDict;
	NSMutableDictionary *_lprojDict;
	NSMutableString *_selectedLang;
	NSMutableString *_selectedDirectory;
	NSString *_currentFile;
	NSString *_currentDir;
	LFLocalizableStringsParser *_localizableStringsParser;
	LFSourceCodeParser *_sourceCodeParser;
	LFLprojParser *_lprojParser;
}
- (void)panelSelectionDidChange:(id)sender;
- (void)addObjectWithName:(NSString *)name;
- (IBAction)addLproj:(id)sender;
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
 @abstract   reloadView
 @discussion none
 */
- (IBAction)reloadView:(id)sender;
@end
