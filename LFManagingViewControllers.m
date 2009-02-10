//
//  LFManagedViewController.m
//  firstApp
//
//  Created by Hu Chin-Hao on 2/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LFManagingViewControllers.h"


@implementation LFManagingViewControllers
@synthesize managedObjectContext;
- (void)dealloc
{
	[managedObjectContext release];
	[super dealloc];
}

@end
