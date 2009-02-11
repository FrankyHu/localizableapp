//
//  LFFileViewController.m
//  firstApp
//
//  Created by Hu Chin-Hao on 2/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LFFileViewController.h"
#import "LFMyController.h"

@implementation LFFileViewController

- (id)init
{
	
	if (![super initWithNibName:@"LFFileView" bundle:nil]) {
		return nil;
	}
	[self setTitle:@"File"];
	return self;
}

- (void)addObjectWithName:(NSString *)name
{
	[_arrayController addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:name, @"name", nil]];
}

- (void)awakeFromNib
{
	[self refreshFileList];
}

- (IBAction)selectFile:(id)sender
{
	if ([sender clickedRow] < [_fileDict count]) {
		//Display select file
		[LFMyController  setFileToDisplay:[_fileArray objectAtIndex:[sender clickedRow]]];
	}
}

- (void)refreshFileList
{
	[_arrayController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [[_arrayController arrangedObjects] count])]];
	_fileArray = [NSMutableArray new];
	_fileDict = [NSMutableDictionary dictionary];
	_fileDict = [LFMyController getFileDict];
	NSEnumerator *e = [_fileDict keyEnumerator];
	for (id x in e) {
		[self addObjectWithName:[_fileDict objectForKey:x]];
		[_fileArray addObject:[_fileDict objectForKey:x]];
	}
	[_fileView reloadData];
}
@end
