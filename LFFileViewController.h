//
//  LFFileViewController.h
//  firstApp
//
//  Created by Hu Chin-Hao on 2/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LFManagingViewControllers.h"

@interface LFFileViewController : LFManagingViewControllers {
	IBOutlet NSTableView *_fileView;
	IBOutlet NSArrayController *_arrayController;
	NSMutableDictionary *_fileDict;
	NSMutableArray *_fileArray;
}
- (void)refreshFileList;
- (void)addObjectWithName:(NSString *)name;
- (IBAction)selectFile:(id)sender;

@end
