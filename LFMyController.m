//
//  LFMyController.m
//  firstApp
//
//  Created by Hu Chin-Hao on 2/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LFMyController.h"
#import "LFMyController+TableViewDelegate.h"
#import "LFPopup.h"
#import "LFMyController+ParserDelegate.h"

@implementation LFMyController

- (void)dealloc
{
	[_langArray release];
	[_displaylist release];
	[super dealloc];
}


- (IBAction)openFile:(id)sender
{
	//Open file dialog
	NSOpenPanel *_panel= [NSOpenPanel openPanel];
	[_panel setCanChooseDirectories:YES];
	[_panel setCanChooseFiles:NO];
	int result = [_panel runModal];
	if (result == NSOKButton){
		_selectedDirectory = [NSMutableString new];
		[_selectedDirectory appendString:[_panel filename]];
		//Read LFLSTR & LFLSTR2 to arrays
		[self parse:_selectedDirectory];
	}
}

- (IBAction)saveFile:(id)sender
{
	if (![_selectedDirectory isEqualToString:@"~/"]) {
		NSMutableString *_selectedFile = [NSMutableString new];
		NSFileManager *_manager = [NSFileManager new];
		[_selectedFile appendString:_selectedDirectory] ;
		[_selectedFile appendString:@"/"];
		[_selectedFile appendString:_selectedLang];
		[_selectedFile appendString:@".lproj"];
		[_manager createDirectoryAtPath:_selectedFile withIntermediateDirectories:YES attributes:nil error:nil];
		//NSLog(_selectedFile);
		[_selectedFile appendString:@"/Localizable.strings"];
		//NSLog(_selectedFile);
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
			[writer appendString:@"\""];
			if ([[x objectAtIndex:4] isEqualToString:@"isRepeat"]) {
				[writer appendString:@"*/"];
			}
			if (![[x objectAtIndex:2] isEqualToString:@""]) {
				[writer appendString:@" /* Comment: "];
				[writer appendString:[x objectAtIndex:2]];
				[writer appendString:@" */"];
			}
			[writer appendString:@" /* File name: "];
			[writer appendString:[x objectAtIndex:3]];
			[writer appendString:@" */"];
			[writer appendString:@"\n"];
		}
		[writer writeToFile:_selectedFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
		NSAlert *_alert = [NSAlert alertWithMessageText:@"Done" defaultButton:@"OK"alternateButton:nil otherButton:nil informativeTextWithFormat:@"File saved!"];;
		[_alert runModal];
		_selectedFile = nil;
	}
	else {
		NSAlert *_alert = [NSAlert alertWithMessageText:@"Error" defaultButton:@"OK"alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please open a directory first."];;
		[_alert runModal];
	}
}

- (IBAction)showLang:(id)sender
{
	NSMenuItem *index = [(NSPopUpButton *)sender selectedItem];
	_selectedLang = [NSMutableString new];
	[_selectedLang appendString: [index title]];
	[currentLang setObjectValue:[index title]];
}

- (void)awakeFromNib
{
	[[self window] center];
	[[self window] setDelegate:self];
	_selectedLang = [NSMutableString new];
	_selectedLang = @"English";
	_selectedDirectory = [NSMutableString new];
	_selectedDirectory = @"~/";
	[self addObjectWithName:@"English"];
	[self addObjectWithName:@"zh_TW"];	
	[self addObjectWithName:@"zh_CN"];
	[self addObjectWithName:@"Japanese"];
	[self addObjectWithName:@"German"];
	[self addObjectWithName:@"French"];
	[self addObjectWithName:@"Italian"];
	[self addObjectWithName:@"Spanish"];
	
}

- (void)addObjectWithName:(NSString *)name
{
	[_arrayController addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:name, @"name", nil]];
}


- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	if (self != nil) {
		_langArray = [NSMutableArray new];
	}
	return self;
}

#pragma mark NSWindow

- (void)windowWillClose:(NSNotification *)notification
{
	[[NSApplication sharedApplication] terminate:nil];
}

@end
