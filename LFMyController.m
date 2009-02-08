//
//  LFMyController.m
//  firstApp
//
//  Created by Hu Chin-Hao on 2/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LFMyController.h"
#import "MyController+TableViewDelegate.h"

@implementation LFMyController

- (void) dealloc
{
	[_LFLSTRlist release];
	[_LFLSTR2list release];
	[_Displaylist release];
	[super dealloc];
}

-(void) parse:(NSString *)filePath
{
	_LFLSTRlist = [NSMutableArray new];
	_LFLSTR2list = [NSMutableArray new];
	_Displaylist = [NSMutableArray new];
	NSMutableArray * array = [NSMutableArray new];
	NSString *file;
	NSString *path;
	NSString *aStr;
	NSString *searchForLFLSTR = @"LFLSTR";
	NSString *searchForLFLSTR2 = @"LFLSTR2";
	const NSString *s;
	int i, j;
	BOOL end = NO;
	//Pass 1: Scan for macro LFLSTR in project directory
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:filePath];
	while (file = [dirEnum nextObject]) {
		if ([[file pathExtension] isEqualToString: @"m"]) {
			path = [filePath stringByAppendingPathComponent:file];
			aStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
			NSRange rangeForLFLSTR = [aStr rangeOfString : searchForLFLSTR];
			NSRange rangeForLFLSTR2 = [aStr rangeOfString : searchForLFLSTR2];
			if ( (rangeForLFLSTR.location != NSNotFound) || (rangeForLFLSTR2.location != NSNotFound) ) {
				[array addObject:path];
				//insert here
				s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
				//Looking for LFLSTR
				for (i = 0 ;i < [s length] ;i++ ) {
					if ([s characterAtIndex:i] == 'L') {
						if((i + 6) < [s length] && [[s substringWithRange:NSMakeRange(i, 9)] isEqualToString:@"LFLSTR(@\""]) {
							NSMutableString *param = [NSMutableString string];
							i += 9;
							end = NO;
							for (j = 0; !end; j++){
								if (i + j >= [s length]) {
									break;
								}
								if ([s characterAtIndex:(i+j)] == '"' && [s characterAtIndex:(i+j-1)] != '\\' ) {
									end = YES;
									continue;
								}
								[param appendFormat:@"%C",[s characterAtIndex:(i+j)]];
							}
							i += j;
							NSMutableArray *COL = [NSMutableArray new];
							[COL addObject:param];
							[COL addObject:param];
							[COL addObject:@""];
							[COL addObject:file];
							[_Displaylist addObject:COL];
						}
					}
				}
				//Looking for LFLSTR2
				for (i = 0 ;i < [s length] ;i++ ) {
					if ([s characterAtIndex:i] == 'L'){
						if((i + 7) < [s length] && [[s substringWithRange:NSMakeRange(i, 10)] isEqualToString:@"LFLSTR2(@\""]) {
							NSMutableString *param1 = [NSMutableString string];
							NSMutableString *param2 = [NSMutableString string];
							i += 10;
							end = NO;
							for (j = 0; !end; j++){
								if (i + j >= [s length]) {
									break;
								}
								if ([s characterAtIndex:(i+j)] == '"' && [s characterAtIndex:(i+j-1)] != '\\' ) {
									end = YES;
									continue;
								}
								[param1 appendFormat:@"%C",[s characterAtIndex:(i+j)]];
							}
							i = i + j + 3;
							end = NO;
							//',' '@' '"'
							for (j = 0; !end; j++) {
								if (i + j >= [s length]) {
									break;
								}
								if ([s characterAtIndex:(i+j)] == '"' && [s characterAtIndex:(i+j-1)] != '\\' ) {
									end = YES;
									continue;
								}
								[param2 appendFormat:@"%C",[s characterAtIndex:(i+j)]];
							}
							i = i + j;
							NSMutableArray *COL = [NSMutableArray new];
							[COL addObject:param1];
							[COL addObject:param1];
							[COL addObject:param2];
							[COL addObject:file];
							[_Displaylist addObject:COL];
							
						}
					}
				}				
				//end
			}
		}
	}
	for (i = 0; i < [_Displaylist count]; i++) {
		for (j = 0; j < [_Displaylist count]; j++) {
			if (i != j) {
				if ( [[[_Displaylist objectAtIndex:i] objectAtIndex:0] isEqualToString:[[_Displaylist objectAtIndex:j] objectAtIndex:0]] ) {
					[[_Displaylist objectAtIndex:i] addObject:@"isRepeat"];
				}
			} else {
				[[_Displaylist objectAtIndex:i] addObject:@"notRepeat"];
			}
		}
	}
	for (i = 0; i < [_Displaylist count]; i++) {
		
		if( [[_Displaylist objectAtIndex:i] count] == 4 ) {
			[[_Displaylist objectAtIndex:i] addObject:@"notRepeat"];
		}
	}
	
	[_view reloadData];
}

- (IBAction)openFile:(id)sender
{
	//Open file dialog
	NSOpenPanel *_panel= [NSOpenPanel openPanel];
	[_panel setCanChooseDirectories:YES];
	[_panel setCanChooseFiles:NO];
	int result = [_panel runModal];
	if (result == NSOKButton){
		NSString *_selectedFile = [_panel filename];
		//Read LFLSTR & LFLSTR2 to arrays
		[self parse:_selectedFile];
	}
}

- (IBAction)saveFile:(id)sender
{
	NSSavePanel *save = [NSSavePanel savePanel];
	//Optional : Add Code here to change NSSavePanel basic configuration
	int result = [save runModal];
	if (result == NSOKButton){
		NSString *_selectedFile = [save filename];
		NSMutableString *writer = [NSMutableString new];
		for (id x in _Displaylist) {
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
	}
}

- (void)awakeFromNib
{
	[[self window] center];
	[[self window] setDelegate:self];
}

#pragma mark NSTableDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return ([_Displaylist count]);
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	NSString *columnName = [aTableColumn identifier];
	if ( [columnName isEqualToString:@"col1"] ) {
		return [[_Displaylist objectAtIndex:rowIndex] objectAtIndex:0];
	}
	else if ( [columnName isEqualToString:@"col2"] ) {
		return [[_Displaylist objectAtIndex:rowIndex] objectAtIndex:1];
	}
	else if ( [columnName isEqualToString:@"col3"] ) {
		return [[_Displaylist objectAtIndex:rowIndex] objectAtIndex:2];
	}
	else if ( [columnName isEqualToString:@"col4"] ) {
		return [[_Displaylist objectAtIndex:rowIndex] objectAtIndex:3];
	}
	else if ( [columnName isEqualToString:@"col5"] ) {
		if ([[[_Displaylist objectAtIndex:rowIndex] objectAtIndex:4]isEqualToString:@"isRepeat"]) {
			return @"Repeat";
		}
		else {
			return @"Not repeat";
		}
		
	}
	return nil;
}


- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	NSString *columnName = [aTableColumn identifier];
	if ( [columnName isEqualToString:@"col1"] ) {
		[[_Displaylist objectAtIndex:rowIndex] replaceObjectAtIndex:0 withObject:anObject];
	}else if ( [columnName isEqualToString:@"col2"] ) {
		[[_Displaylist objectAtIndex:rowIndex] replaceObjectAtIndex:1 withObject:anObject];
	}else if ( [columnName isEqualToString:@"col3"] ) {
		[[_Displaylist objectAtIndex:rowIndex] replaceObjectAtIndex:2 withObject:anObject];
	}
}

#pragma mark NSWindow

- (void)windowWillClose:(NSNotification *)notification
{
	[[NSApplication sharedApplication] terminate:nil];
}

@end
