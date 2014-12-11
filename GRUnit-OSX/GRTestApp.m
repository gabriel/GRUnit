//
//  GRTestApp.m
//  GHUnit
//
//  Created by Gabriel Handford on 1/20/09.
//  Copyright 2009. All rights reserved.
//

#import "GRTestApp.h"

@implementation GRTestApp

- (id)init {
	if ((self = [super init])) {
		windowController_ = [[GRTestWindowController alloc] init];
		NSBundle *bundle = [NSBundle bundleForClass:[self class]];	
		topLevelObjects_ = [[NSMutableArray alloc] init]; 
		NSDictionary *externalNameTable = [NSDictionary dictionaryWithObjectsAndKeys:self, @"NSOwner", topLevelObjects_, @"NSTopLevelObjects", nil]; 
		[bundle loadNibFile:@"GRTestApp" externalNameTable:externalNameTable withZone:nil];			
	}
	return self;
}

- (id)initWithSuite:(GRTestSuite *)suite {
	// Since init loads XIB we need to set suite early; For backwards compat.
	suite_ = suite;
	if ((self = [self init])) { }
	return self;
}

- (void)awakeFromNib { 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) 
																							 name:NSApplicationWillTerminateNotification object:nil];
	windowController_.viewController.suite = suite_;
	[windowController_ showWindow:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)runTests {
	[windowController_.viewController runTests];
}


#pragma mark Notifications (NSApplication)

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	[windowController_.viewController saveDefaults];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
