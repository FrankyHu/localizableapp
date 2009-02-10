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

SYNTHESIZE_SINGLETON_FOR_CLASS(LFMyController); //Make this class singleton

- (id) init
{
	[super init];
	_viewControllers = [[NSMutableArray alloc] init];
	LFManagingViewControllers *vc;
	//
	vc = [[LFLanguageViewController alloc] init];
	[vc setManagedObjectContext:[self managedObjectContext]];
	[_viewControllers addObject:vc];
	[vc release];
	//
	vc = [[LFFileViewController alloc] init];
	[vc setManagedObjectContext:[self managedObjectContext]];
	[_viewControllers addObject:vc];
	[vc release];
	return self;
}

- (void)dealloc
{
	[_langArray release];
	[_displaylist release];
	[_viewControllers release];
	[super dealloc];
}

- (void)displayViewController:(LFManagingViewControllers *)vc
{
	//Try to end editing
	NSWindow *w = [_box window];
	BOOL ended = [w makeFirstResponder:w];
	if (!ended) {
		NSBeep();
		return;
	}
	//Put the view in the box
	NSView *v = [vc view];
	[_box setContentView:v];
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
		_parser = [LFSourceCodeParser new];
		[_parser parse:_selectedDirectory];
		_displaylist = [_parser getDisplaylist];
		[_view reloadData];
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

- (IBAction)changeViewController:(id)sender
{
	int i=0;
	NSLog([sender title]);
	if ([[sender title] isEqualToString:@"Language"]) {
		i=0;
	}
	if ([[sender title] isEqualToString:@"File"]) {
		i=1;
	}
	LFManagingViewControllers *vc = [_viewControllers objectAtIndex:i];
	[self displayViewController:vc];
}

- (void)awakeFromNib
{
	_langArray = [NSMutableArray new];
	_selectedLang = [NSMutableString new];
	_selectedLang = @"English";
	_selectedDirectory = [NSMutableString new];
	_selectedDirectory = @"~/";
	//
//	NSMenu *menu = [_popUp menu];
//	int i, itemCount;
//	itemCount = [_viewControllers count];
//	for (i = 0; i < itemCount; i++) {
//		NSViewController *vc = [_viewControllers objectAtIndex:i];
//		NSMenuItem *mi = [[NSMenuItem alloc] initWithTitle:[vc title] action:@selector(changeViewController:) keyEquivalent:@""];
//		[mi setTag:i];
//		[menu addItem:mi];
//		[mi release];
//	}
	//Initially show the first controller
	[self displayViewController:[_viewControllers objectAtIndex:0]];
	[_popUp selectItemAtIndex:0];
}

+ (void)setLang:(NSString *)name
{
	_selectedLang = [NSMutableString new];
	[_selectedLang appendString:name];
}

#pragma mark NSWindow

- (void)windowWillClose:(NSNotification *)notification
{
	[[NSApplication sharedApplication] terminate:nil];
}

@end
