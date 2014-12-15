//
//  GRTestApp.m
//  GRUnit
//
//  Created by Gabriel Handford on 1/20/09.
//  Copyright 2009. All rights reserved.
//

#import "GRTestApp.h"

@interface GRTestApp ()
@property NSArray *topLevelObjects;
@property GRTestWindowController *windowController;
@property GRTestSuite *suite;
@end

@implementation GRTestApp

- (id)init {
  if ((self = [super init])) {
    _windowController = [[GRTestWindowController alloc] init];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSArray *topLevelObjects = nil;
    [bundle loadNibNamed:@"GRTestApp" owner:self topLevelObjects:&topLevelObjects];
    _topLevelObjects = topLevelObjects;
  }
  return self;
}

- (id)initWithSuite:(GRTestSuite *)suite {
	// Since init loads XIB we need to set suite early; For backwards compat.
	_suite = suite;
	if ((self = [self init])) { }
	return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:)  name:NSApplicationWillTerminateNotification object:nil];
	_windowController.viewController.suite = _suite;
	[_windowController showWindow:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)runTests {
	[_windowController.viewController runTests];
}

#pragma mark Notifications (NSApplication)

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	[_windowController.viewController saveDefaults];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
