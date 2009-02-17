//
//  LFMyController.h
//  Localizable App
//
//  Created by Hu Chin-Hao on 2/4/09.
//  Copyright 2009 Lithoglyph Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LFLocalizableStringsParser.h"
#import "LFSourceCodeParser.h"
#import "LFLprojParser.h"

/*!
    @class
    @abstract    LFMyController is the main class of Localizable App
    @discussion  This is the main controller in the project
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
	NSMutableArray *_notMatchStringList;
	NSMutableDictionary *_fileDict;
	NSMutableDictionary *_lprojDict;
	NSMutableString *_selectedLang;
	NSMutableString *_selectedDirectory;
	NSMutableString *_lastComment;
	NSUserDefaults *_userDefaults;
	NSString *_currentFile;
	NSString *_currentDir;
	LFLocalizableStringsParser *_localizableStringsParser;
	LFSourceCodeParser *_sourceCodeParser;
	LFLprojParser *_lprojParser;
}


/*!
 @method     
 @abstract   panelSelectionDidChange
 @discussion This method will be call if the direcpory path change in open file panel
 */
- (void)panelSelectionDidChange:(id)sender;

/*!
 @method     
 @abstract   addObjectWithName
 @discussion Add the object to array controller and show in pop up button
 */
- (void)addObjectWithName:(NSString *)name;

/*!
 @method     
 @abstract   addLproj
 @discussion Add language button in open panel
 */
- (IBAction)addLproj:(id)sender;

/*!
 @method     
 @abstract   openFile, select the directory
 @discussion This method will call parse and show in table view
 */
- (IBAction)openFile:(id)sender;

/*!
 @method     
 @abstract   saveFile, save the file to Localizable.strings
 @discussion Save to Localizable.strings
 */
- (IBAction)saveFile:(id)sender;

/*!
 @method     
 @abstract   reloadView
 @discussion Reload the table view
 */
- (IBAction)reloadView:(id)sender;

@end

NSString *LFLSTR(NSString *key);
