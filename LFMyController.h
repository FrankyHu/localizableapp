//
//  LFMyController.h
//  firstApp
//
//  Created by Hu Chin-Hao on 2/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LFMyController : NSWindowController {
	IBOutlet NSTableView *_view;
	NSMutableArray *_LFLSTRlist;
	NSMutableArray *_LFLSTR2list;
	NSMutableArray *_Displaylist;
}
- (void)parse:(NSString *)filePath;
- (IBAction)openFile:(id)sender;
- (IBAction)saveFile:(id)sender;

@end
