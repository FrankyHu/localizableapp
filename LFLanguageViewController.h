//
//  LFLanguageViewController.h
//  firstApp
//
//  Created by Hu Chin-Hao on 2/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LFManagingViewControllers.h"

@interface LFLanguageViewController : LFManagingViewControllers 
{
	IBOutlet NSTableView *_langView;
	IBOutlet NSArrayController *_arrayController;
	NSMutableArray *_langArray;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;
- (void)addObjectWithName:(NSString *)name;
- (IBAction)selectLang:(id)sender;
@end
