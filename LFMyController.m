//
//  LFMyController.m
//  firstApp
//
//  Created by Hu Chin-Hao on 2/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LFMyController.h"
#import "LFMyController+TableViewDelegate.h"


@implementation LFMyController
- (id) init
{
    if ((self = [super init])) {
		_backgroundList = [NSMutableArray new];
		_displaylist = [NSMutableArray new];
		_langArray = [NSMutableArray new];
		_selectedLang = [NSMutableString new];
		_selectedDirectory = [NSMutableString new];
		_currentDir = [NSString new];
		_localizedArray = [NSMutableArray new];
		//_selectedLang = @"English";
		_selectedDirectory = @"~/";
		//[_selectedLang retain];
		[_selectedDirectory retain];
        /* class-specific initialization goes here */
    }
    return self;
}

- (void)dealloc
{
	[_currentDir release];
	[_langArray release];
	[_displaylist release];
	[_backgroundList release];
	[_selectedLang release];
	[_selectedDirectory release];
	[_localizedArray release];
	[super dealloc];
}

- (void)panelSelectionDidChange:(id)sender
{
	//Find all lproj directory
	_currentDir = [sender filename];
	_lprojParser = [LFLprojParser new];
	if ([_lprojParser parse:_currentDir]) {
		_lprojDict = [NSMutableDictionary dictionary];
		_lprojDict = [_lprojParser directoryList];
		NSEnumerator *e = [_lprojDict keyEnumerator];
		[_arrayController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [[_arrayController arrangedObjects] count])]];
		for (id x in e) {
			[self addObjectWithName:[[_lprojParser directoryList] objectForKey:x]];
			[_langArray addObject:[[_lprojParser directoryList] objectForKey:x]];
		}
		[_addLprojButton setEnabled:YES];
	}
	else {
		[_addLprojButton setEnabled:NO];
	}
	[_currentDir retain];
	[_lprojDict release];
	[_lprojParser release];
}

- (IBAction)addLproj:(id)sender
{
	//Create dir
	NSString *lprojName = [_addLprojText stringValue];
	NSMutableString *_selectedFile = [NSMutableString new];
	[_selectedFile appendString:_currentDir] ;
	[_selectedFile appendString:@"/"];
	[_selectedFile appendString:lprojName];
	[_selectedFile appendString:@".lproj"];
	//NSMutableString *writer = [NSMutableString stringWithString:@""];
	//NSLog(@"%@",writer);
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm createDirectoryAtPath:_selectedFile attributes:nil];
	//[writer writeToFile:_selectedFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
	//NSAlert *alert = [NSAlert alertWithMessageText:@"Done" defaultButton:@"OK"alternateButton:nil otherButton:nil informativeTextWithFormat:@"Directory %@.lproj created.",lprojName];
	//[alert runModal];
	[self addObjectWithName:lprojName];
	[_langArray addObject:lprojName];
	[_selectedFile release];
	//[writer release];
}

- (IBAction)openFile:(id)sender
{
	[_addLprojButton setEnabled:NO];
	//Open file dialog
	[_arrayController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [[_arrayController arrangedObjects] count])]];
	[self addObjectWithName:@"Select Project Directory First"];
	NSOpenPanel *_panel= [NSOpenPanel openPanel];
	[_panel setDelegate:self];
	[_panel setCanChooseDirectories:YES];
	[_panel setCanChooseFiles:NO];
	[_panel setAccessoryView:_openFileView];
	int result = [_panel runModal];
	if (result == NSOKButton){
		_selectedDirectory = [NSMutableString stringWithString:[_panel filename]];
		//Parse source code: Read LFLSTR & LFLSTR2 to arrays
		_sourceCodeParser = [LFSourceCodeParser new];
		[_sourceCodeParser parse:_selectedDirectory];
		id l = _displaylist;
		_displaylist = [[_sourceCodeParser Displaylist] retain];
		[l release];
//		l = _backgroundList;
//		_backgroundList = [[_sourceCodeParser Displaylist] retain];
//		[l release];
		[_view reloadData];
		//
		_fileDict = [NSMutableDictionary dictionary];
		for (id x in _backgroundList) {
			NSString *str = [x objectAtIndex:3];
			[_fileDict setObject:str forKey:str];
		}
		[_sourceCodeParser release];
		//Parse Localizabe.strings
		NSMutableString *lprojPath = [NSMutableString new];
		[lprojPath appendString:_selectedDirectory];
		[lprojPath appendString:@"/"];
		[lprojPath appendString:[_langArray objectAtIndex:[_langPopUp indexOfSelectedItem]]];
		[lprojPath appendString:@".lproj/Localizable.strings"];
		
		_localizableStringsParser = [LFLocalizableStringsParser new];
		[_localizableStringsParser parse:lprojPath];
		l = _stringList;
		_stringList = [_localizableStringsParser stringList];
		[l release];
		//Compare _displaylist and _stringList
		BOOL checked = NO;
		NSString *yes = [NSString stringWithString:@"YES"];
		NSString *no = [NSString stringWithString:@"NO"];
		for (id x in _displaylist) {
			//
			for (id y in _stringList) {
				if ([[x objectAtIndex:0] isEqualToString:[y objectAtIndex:0]]) {
					[_localizedArray addObject:yes];
					checked = YES;
				}
			}
			if (!checked) {
				[_localizedArray addObject:no];	
			}
			checked = NO;
		}
		//
		[lprojPath release];
		[_localizableStringsParser release];
	}
	[_selectedDirectory retain]; //must retain, otherwise it'll release at saveFile
}

- (void)addObjectWithName:(NSString *)name
{
	[_arrayController addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:name, @"name", nil]];
}

- (IBAction)saveFile:(id)sender
{
	//NSLog(@"%@",_selectedDirectory);
	if (![_selectedDirectory isEqualToString:@"~/"]) {
		NSMutableString *_selectedFile = [NSMutableString new];
		NSFileManager *_manager = [NSFileManager new];
		[_selectedFile appendString:_selectedDirectory] ;
		[_selectedFile appendString:@"/"];
		[_selectedFile appendString:[_langArray objectAtIndex:[_langPopUp indexOfSelectedItem]]];
		[_selectedFile appendString:@".lproj"];
		[_manager createDirectoryAtPath:_selectedFile withIntermediateDirectories:YES attributes:nil error:nil];
		[_selectedFile appendString:@"/Localizable.strings"];
		NSMutableString *writer = [NSMutableString new];
		for (id x in _displaylist) {
			if ([[x objectAtIndex:4] isEqualToString:@"isRepeat"]) {
				[writer appendString:@"/*"];
			}
			[writer appendString:@"\""];
			[writer appendString:[x objectAtIndex:0]];
			[writer appendString:@"\""];
			[writer appendString:@" = "];
			[writer appendString:@"\""];
			[writer appendString:[x objectAtIndex:1]];
			[writer appendString:@"\";"];
			if ([[x objectAtIndex:4] isEqualToString:@"isRepeat"]) {
				[writer appendString:@"*/"];
			}
			if (![[x objectAtIndex:2] isEqualToString:@""]) {
				[writer appendString:@" /* Comment: "];
				[writer appendString:[x objectAtIndex:2]];
				[writer appendString:@" File name: "];
				[writer appendString:[x objectAtIndex:3]];
				[writer appendString:@" */"];
				[writer appendString:@"\n"];
			}
			else {
				[writer appendString:@" /* File name: "];
				[writer appendString:[x objectAtIndex:3]];
				[writer appendString:@" */"];
				[writer appendString:@"\n"];
			}
		}
		[writer writeToFile:_selectedFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
		NSAlert *_alert = [NSAlert alertWithMessageText:@"Done" defaultButton:@"OK"alternateButton:nil otherButton:nil informativeTextWithFormat:@"File saved!"];;
		[_alert runModal];
	}
	else {
		NSAlert *_alert = [NSAlert alertWithMessageText:@"Error" defaultButton:@"OK"alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please open a directory first."];;
		[_alert runModal];
	}
}


- (void)awakeFromNib
{
	
}

- (IBAction)reloadView:(id)sender
{
//	_displaylist = [NSMutableArray new];
//	for (id x in _backgroundList) {
//		NSString *str = [x objectAtIndex:3];
//		if ([str isEqualToString:_currentFile]) {
//			[_displaylist addObject:x];
//		}
//	}
	[_view reloadData];
}

#pragma mark NSWindow

- (void)windowWillClose:(NSNotification *)notification
{
	[[NSApplication sharedApplication] terminate:nil];
}

@end
