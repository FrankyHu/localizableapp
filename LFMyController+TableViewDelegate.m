//
//  MyController+TableViewDelegate.m
//  Localizable App
//
//  Created by Hu Chin-Hao on 2/8/09.
//  Copyright 2009 Lithoglyph Inc. All rights reserved.
//

#import "LFMyController+TableViewDelegate.h"
#import "LFMyController.h"

@implementation LFMyController(TableViewDelegate)

#pragma mark NSTableDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return ([_displaylist count]);
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	NSString *columnName = [aTableColumn identifier];
	if ( [columnName isEqualToString:@"Original"] ) {
		return [[_displaylist objectAtIndex:rowIndex] objectAtIndex:0];
	}
	else if ( [columnName isEqualToString:@"Translate"] ) {
		return [[_displaylist objectAtIndex:rowIndex] objectAtIndex:1];
	}
	else if ( [columnName isEqualToString:@"Comment"] ) {
		return [[_displaylist objectAtIndex:rowIndex] objectAtIndex:2];
	}
	else if ( [columnName isEqualToString:@"FileName"] ) {
		return [[_displaylist objectAtIndex:rowIndex] objectAtIndex:3];
	}
	else if ( [columnName isEqualToString:@"Status"] ) {
		if ([[[_displaylist objectAtIndex:rowIndex] objectAtIndex:4]isEqualToString:@"isRepeat"]) {
			return LFLSTR(@"Duplicate");
		}
		else {
			return LFLSTR(@"Not Duplicate");
		}
	}
	return nil;
}

- (void)tableView: (NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)TC row:(int)row
{
	if ([[_localizedArray objectAtIndex:row] isEqualToString:@"NO"]) {
		[aCell setDrawsBackground: YES];
		[aCell setBackgroundColor:
		 [NSColor colorWithCalibratedRed: 0.9 green: 0.9 blue:1 alpha: 
		  1.0]];
	}
	else {
		[aCell setDrawsBackground: NO];
		[aCell setBackgroundColor: [NSColor whiteColor]];
	}
}


- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	NSString *columnName = [aTableColumn identifier];
	if ( [columnName isEqualToString:@"Original"] ) {
		[[_displaylist objectAtIndex:rowIndex] replaceObjectAtIndex:0 withObject:anObject];
	}
	else if ( [columnName isEqualToString:@"Translate"] ) {
		[[_displaylist objectAtIndex:rowIndex] replaceObjectAtIndex:1 withObject:anObject];
	}
	else if ( [columnName isEqualToString:@"Comment"] ) {
		[[_displaylist objectAtIndex:rowIndex] replaceObjectAtIndex:2 withObject:anObject];
	}
}

@end
