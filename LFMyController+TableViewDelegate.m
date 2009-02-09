//
//  MyController+TableViewDelegate.m
//  firstApp
//
//  Created by Hu Chin-Hao on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
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
	if ( [columnName isEqualToString:@"col1"] ) {
		return [[_displaylist objectAtIndex:rowIndex] objectAtIndex:0];
	}
	else if ( [columnName isEqualToString:@"col2"] ) {
		return [[_displaylist objectAtIndex:rowIndex] objectAtIndex:1];
	}
	else if ( [columnName isEqualToString:@"col3"] ) {
		return [[_displaylist objectAtIndex:rowIndex] objectAtIndex:2];
	}
	else if ( [columnName isEqualToString:@"col4"] ) {
		return [[_displaylist objectAtIndex:rowIndex] objectAtIndex:3];
	}
	else if ( [columnName isEqualToString:@"col5"] ) {
		if ([[[_displaylist objectAtIndex:rowIndex] objectAtIndex:4]isEqualToString:@"isRepeat"]) {
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
		[[_displaylist objectAtIndex:rowIndex] replaceObjectAtIndex:0 withObject:anObject];
	}else if ( [columnName isEqualToString:@"col2"] ) {
		[[_displaylist objectAtIndex:rowIndex] replaceObjectAtIndex:1 withObject:anObject];
	}else if ( [columnName isEqualToString:@"col3"] ) {
		[[_displaylist objectAtIndex:rowIndex] replaceObjectAtIndex:2 withObject:anObject];
	}
}

@end
