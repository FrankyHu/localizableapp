//
//  LFLanguageViewController.m
//  firstApp
//
//  Created by Hu Chin-Hao on 2/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LFLanguageViewController.h"
#import "LFMyController.h"


@implementation LFLanguageViewController
- (id)init
{
	if (![super initWithNibName:@"LFLanguageView" bundle:nil]) {
		return nil;
	}
	[self setTitle:@"Language"];
	return self;
}

- (void)addObjectWithName:(NSString *)name
{
	[_arrayController addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:name, @"name", nil]];
	[_langArray addObject:name];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return ([_langArray count]);
}

- (void)awakeFromNib
{
	_langArray = [NSMutableArray new];
	[self addObjectWithName:@"English"];
	[self addObjectWithName:@"zh_TW"];	
	[self addObjectWithName:@"zh_CN"];
	[self addObjectWithName:@"Japanese"];
	[self addObjectWithName:@"German"];
	[self addObjectWithName:@"French"];
	[self addObjectWithName:@"Italian"];
	[self addObjectWithName:@"Spanish"];
}

- (IBAction)selectLang:(id)sender
{
	if ([sender clickedRow] < [_langArray count]) {
		[LFMyController setLang:[_langArray objectAtIndex:[sender clickedRow]]];
	}
}

@end
