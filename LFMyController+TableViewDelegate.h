//
//  MyController+TableViewDelegate.h
//  Localizable App
//
//  Created by Hu Chin-Hao on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LFMyController.h"

@interface LFMyController(TableViewDelegate)
/*!
 @method     
 @abstract   numberOfRowsInTableView
 @discussion Return number of rows in table view
 */
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;

/*!
 @method     
 @abstract   objectValueForTableColumn
 @discussion Return the object value for table column
 */
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;

/*!
 @method     
 @abstract   willDisplayCell
 @discussion Return the color of each cell
 */
- (void)tableView: (NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)TC row:(int)row;

/*!
 @method     
 @abstract   setObjectValue
 @discussion Set the object value if the value of cell changed
 */
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;


@end
