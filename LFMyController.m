//
//  LFMyController.m
//  Localizable App
//
//  Created by Hu Chin-Hao on 2/4/09.
//  Copyright 2009 Lithoglyph Inc. All rights reserved.
//

#import "LFMyController.h"
#import "LFMyController+TableViewDelegate.h"

@implementation LFMyController
- (id) init
{
    if ((self = [super init])) {
		_userDefaults = [NSUserDefaults standardUserDefaults];
		_backgroundList = [NSMutableArray new];
		_displaylist = [NSMutableArray new];
		_langArray = [NSMutableArray new];
		_notMatchStringList = [NSMutableArray new];
		_selectedLang = [NSMutableString new];
		_selectedDirectory = [NSMutableString new];
		_lastComment = [NSMutableString new];
		_currentDir = [NSString new];
		_localizedArray = [NSMutableArray new];
		_lprojParser = [LFLprojParser new];
		_selectedDirectory = @"~/";
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
	[_notMatchStringList release];
	[_selectedLang release];
	[_selectedDirectory release];
	[_localizedArray release];
	[_lprojParser release];
	[_lastComment release];
	[super dealloc];
}

- (void)panelSelectionDidChange:(id)sender
{
	//Find all lproj directory
	_currentDir = [sender filename];
	[_userDefaults setObject:_currentDir forKey:@"OpenPath"];
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
	//[_lprojDict release];
	
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
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm createDirectoryAtPath:_selectedFile attributes:nil];
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
	[self addObjectWithName:LFLSTR(@"Select Project Directory First")];
	NSOpenPanel *_panel= [NSOpenPanel openPanel];
	[_panel setDelegate:self];
	[_panel setCanChooseDirectories:YES];
	[_panel setCanChooseFiles:NO];
	[_panel setAccessoryView:_openFileView];
	if ([_userDefaults objectForKey:@"OpenPath"]) {
		[_panel setDirectory:[_userDefaults objectForKey:@"OpenPath"]];
		_currentDir = [_userDefaults objectForKey:@"OpenPath"];
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
	}
	else {
		[_panel setDirectory:@"~/"];
	}
	int result = [_panel runModal];
	
	if (result == NSOKButton){
		_selectedDirectory = [NSMutableString stringWithString:[_panel filename]];
		//Parse source code: Read LFLSTR & LFLSTR2 to arrays
		_sourceCodeParser = [LFSourceCodeParser new];
		[_sourceCodeParser parse:_selectedDirectory];
		id x, y;
		id l = _displaylist;
		_displaylist = [[_sourceCodeParser Displaylist] retain];
		[l release];
		//
		l = _backgroundList;
		_backgroundList = [[_sourceCodeParser Displaylist] retain];
		[l release];
		//[_view reloadData];
		//
		//_fileDict = [NSMutableDictionary dictionary];
//		for (x in _backgroundList) {
//			NSString *str = [x objectAtIndex:3];
//			[_fileDict setObject:str forKey:str];
//		}
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
		for (x in _displaylist) {
			//
			for (y in _stringList) {
				if ([[x objectAtIndex:0] isEqualToString:[y objectAtIndex:0]]) {
					[_localizedArray addObject:yes];
					//Modify _displaylist objAtIndex:1
					[x replaceObjectAtIndex:1 withObject:[y objectAtIndex:1]];
					checked = YES;
					break;
				}
			}
			if (!checked) {
				[x replaceObjectAtIndex:1 withObject:@""];
				[_localizedArray addObject:no];
			}
			checked = NO;
		}		
		//Add to _notMatchStringList
		for (x in _stringList) {
			checked = NO;
			for (y in _displaylist) {
				if ([[x objectAtIndex:0] isEqualToString:[y objectAtIndex:0]]) {
					checked = YES;
					break;
				}
			}
			if (!checked) {
				[_notMatchStringList addObject:x];
				NSMutableArray *col = [NSMutableArray new];
				[col addObject:[x objectAtIndex:0]];
				[col addObject:[x objectAtIndex:1]];
				[col addObject:@""];
				[col addObject:@"Not exist"];
				[col addObject:@"notRepeat"];
				NSLog(@"%@",col);
				[_displaylist addObject:col];
				[_localizedArray addObject:no];
			}
		}
		[_view reloadData];
		[lprojPath release];
		[_localizableStringsParser release];
	}
	[_selectedDirectory retain]; //must retain, otherwise it'll release at saveFile
	[self showWindow:self];
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
		NSMutableString *lastFileName = [NSMutableString new];
		for (id x in _displaylist) {
			if (![lastFileName isEqualToString:[x objectAtIndex:3]]) {
				lastFileName = [x objectAtIndex:3];
				[writer appendString:@"\n"];
				[writer appendString:@"/* "];
				[writer appendString:[x objectAtIndex:3]];
				[writer appendString:@" */"];
				[writer appendString:@"\n"];
			}
			if ([[x objectAtIndex:4] isEqualToString:@"isRepeat"]) {
				[writer appendString:@"/*"];
				[writer appendString:@"\\\""];
				[writer appendString:[x objectAtIndex:0]];
				[writer appendString:@"\\\""];
				[writer appendString:@" = "];
				[writer appendString:@"\\\""];
				[writer appendString:[x objectAtIndex:1]];
				[writer appendString:@"\\\";"];
				[writer appendString:@"*/"];
			}
			else {
				[writer appendString:@"\""];
				[writer appendString:[x objectAtIndex:0]];
				[writer appendString:@"\""];
				[writer appendString:@" = "];
				[writer appendString:@"\""];
				[writer appendString:[x objectAtIndex:1]];
				[writer appendString:@"\";"];
			}
			if (![[x objectAtIndex:2] isEqualToString:@""]) {
				[writer appendString:@" /* Comment: "];
				[writer appendString:[x objectAtIndex:2]];
				[writer appendString:@" */"];
			}
			[writer appendString:@"\n"];
		}
		[writer appendString:@"\n"];
		//notMatchStringList
		
		if ([_notMatchStringList count] > 0) {
			[writer appendString:@"/* The strings which is not found in all of the source code */\n"];
			for (id x in _notMatchStringList) {
				if (![[x objectAtIndex:2] isEqualToString:_lastComment]) {
					_lastComment = [x objectAtIndex:2];
					[writer appendString:@"\n/*"];
					[writer appendString:_lastComment];
					[writer appendString:@"*/\n"];
				}
				[writer appendString:@"\""];
				[writer appendString:[x objectAtIndex:0]];
				[writer appendString:@"\""];
				[writer appendString:@" = "];
				[writer appendString:@"\""];
				[writer appendString:[x objectAtIndex:1]];
				[writer appendString:@"\";"];
				[writer appendString:@"\n"];
			}
		}
		[writer writeToFile:_selectedFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
		NSAlert *_alert = [NSAlert alertWithMessageText:LFLSTR(@"Done") defaultButton:LFLSTR(@"OK") alternateButton:nil otherButton:nil informativeTextWithFormat:LFLSTR(@"File saved!")];;
		[_alert runModal];
	}
	else {
		NSAlert *_alert = [NSAlert alertWithMessageText:LFLSTR(@"Error") defaultButton:LFLSTR(@"OK") alternateButton:nil otherButton:nil informativeTextWithFormat:LFLSTR(@"Please open a directory first.")];;
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

NSString *LFLSTR(NSString *key)
{
	static NSBundle *LFLSCachedMainBundle = nil;
    if (!LFLSCachedMainBundle) {
        LFLSCachedMainBundle = [NSBundle mainBundle];
    }
    
    return [LFLSCachedMainBundle localizedStringForKey:key value:nil table:nil];
}