//
//  LFFileViewController.m
//  firstApp
//
//  Created by Hu Chin-Hao on 2/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LFFileViewController.h"


@implementation LFFileViewController
- (id)init
{
	if (![super initWithNibName:@"LFFileView" bundle:nil]) {
		return nil;
	}
	[self setTitle:@"File"];
	return self;
}
@end
