//
//  GRTestViewController.m
//  GHKit
//
//  Created by Gabriel Handford on 1/17/09.
//  Copyright 2009. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "GRTestViewController.h"

#import "GRTesting.h"

@interface GRTestViewController ()
- (void)_updateTest:(id<GRTest>)test;
- (NSString *)_prefix;
- (void)_setPrefix:(NSString *)prefix;
- (void)_updateDetailForTest:(id<GRTest>)test prefix:(NSString *)prefix;
@end

@implementation GRTestViewController

@synthesize suite=suite_, status=status_, statusProgress=statusProgress_, 
wrapInTextView=wrapInTextView_, runLabel=runLabel_, dataSource=dataSource_,
running=running_, exceptionFilename=exceptionFilename_, exceptionLineNumber=exceptionLineNumber_;

- (id)init {
	if ((self = [super initWithNibName:@"GRTestView" bundle:[NSBundle bundleForClass:[GRTestViewController class]]])) { 
		suite_ = [GRTestSuite suiteFromEnv];
    
    NSString *identifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    if (!identifier) identifier = @"Tests";
    
		dataSource_ = [[GRTestOutlineViewModel alloc] initWithIdentifier:identifier suite:suite_];
		dataSource_.delegate = self;
    [dataSource_ loadDefaults];
		[self view]; // Force nib awaken
	}
	return self;
}

- (void)dealloc {
	dataSource_.delegate = nil;
}

- (void)awakeFromNib {
	_outlineView.delegate = dataSource_;
	_outlineView.dataSource = dataSource_;
  
   // If we remove from superview, need to keep it retained
	
	[_textView setTextColor:[NSColor whiteColor]];
	[_textView setFont:[NSFont fontWithName:@"Monaco" size:10.0]];
	[_textView setString:@""];
  _textSegmentedControl.selectedSegment = [[NSUserDefaults standardUserDefaults] integerForKey:@"TextSelectedSegment"];
  
  _splitView.delegate = self;
  
  NSString *prefix = [self _prefix];
  if (prefix) {
    [_searchField setStringValue:prefix];
    [self updateSearchFilter:nil];
  }
  
	self.wrapInTextView = NO;
	self.runLabel = @"Run";
}

- (NSString *)_prefix {
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"Prefix"];
}

- (void)_setPrefix:(NSString *)prefix {
  [[NSUserDefaults standardUserDefaults] setObject:prefix forKey:@"Prefix"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark Running

- (IBAction)runTests:(id)sender {
	[self runTests];
}

- (void)runTests {
	if (dataSource_.isRunning) {
		self.status = @"Cancelling...";
		[dataSource_ cancel];
	} else {
		NSAssert(suite_, @"Must set test suite");
		[self loadTestSuite];
		self.status = @"Starting tests...";
		self.runLabel = @"Cancel";
		BOOL inParallel = self.runInParallel;
		[dataSource_ run:self inParallel:inParallel];
	}
}

- (void)loadTestSuite {
	self.status = @"Loading tests...";
  [self reload];
	self.status = @"Select 'Run' to start tests";
}

- (void)reload {
  [_outlineView reloadData];
	[_outlineView reloadItem:nil reloadChildren:YES];
	[_outlineView expandItem:nil expandChildren:YES];
}

#pragma mark -

- (void)setWrapInTextView:(BOOL)wrapInTextView {
	wrapInTextView_ = wrapInTextView;
	if (wrapInTextView_) {
		// No horizontal scroll, word wrapping
		[[_textView enclosingScrollView] setHasHorizontalScroller:NO];		
		[_textView setHorizontallyResizable:NO];
		NSSize size = [[_textView enclosingScrollView] frame].size;
		[[_textView textContainer] setContainerSize:NSMakeSize(size.width, FLT_MAX)];	
		[[_textView textContainer] setWidthTracksTextView:YES];
		NSRect frame = [_textView frame];
		frame.size.width = size.width;
		[_textView setFrame:frame];
	} else {
		// So we have horizontal scroll
		[[_textView enclosingScrollView] setHasHorizontalScroller:YES];		
		[_textView setHorizontallyResizable:YES];
		[[_textView textContainer] setContainerSize:NSMakeSize(FLT_MAX, FLT_MAX)];	
		[[_textView textContainer] setWidthTracksTextView:NO];		
	}
	[_textView setNeedsDisplay:YES];
}

- (IBAction)updateMode:(id)sender {
  switch(_segmentedControl.selectedSegment) {
    case 0: {
      dataSource_.editing = NO;
      [dataSource_.root setFilter:GRTestNodeFilterNone]; 
      break;
    }
    case 1: {
      dataSource_.editing = NO;
      [dataSource_.root setFilter:GRTestNodeFilterFailed]; 
      break;
    }
    case 2: {      
      dataSource_.editing = YES;      
      [dataSource_.root setFilter:GRTestNodeFilterNone];
      break;
    }
  }
  [dataSource_ saveDefaults];
  [self reload];
}

- (IBAction)updateSearchFilter:(id)sender {
  NSString *prefix = [_searchField stringValue];
  [dataSource_.root setTextFilter:prefix];
  [self _setPrefix:prefix];
  [self reload];
}

- (IBAction)copy:(id)sender {
	[_textView copy:sender];
}

- (IBAction)openExceptionFilename:(id)sender {
  if (self.exceptionFilename) {
    NSString *path = [self.exceptionFilename stringByExpandingTildeInPath];
    [[NSWorkspace sharedWorkspace] openFile:path];
  }
}

- (IBAction)rerunTest:(id)sender {
//  id<GRTest> test = [[self selectedTest] copyWithZone:NULL];
//  [self _updateDetailForTest:nil prefix:@"Re-running test."];
//  [test run:^(id<GRTest> test) {
//    [self _updateDetailForTest:test prefix:@"Re-ran test."];
//  }];
}

- (BOOL)isShowingDetails {
  return ![[NSUserDefaults standardUserDefaults] boolForKey:@"ViewCollapsed"];
}

- (void)setShowingDetails:(BOOL)showingDetails {
  [[NSUserDefaults standardUserDefaults] setBool:(!showingDetails) forKey:@"ViewCollapsed"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setReraiseExceptions:(BOOL)reraiseExceptions {
  [[NSUserDefaults standardUserDefaults] setBool:reraiseExceptions forKey:@"ReraiseExceptions"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)reraiseExceptions {
  return [[NSUserDefaults standardUserDefaults] boolForKey:@"ReraiseExceptions"];  
}

- (void)setRunInParallel:(BOOL)runInParallel {
  [[NSUserDefaults standardUserDefaults] setBool:runInParallel forKey:@"RunInParallel"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)runInParallel {
  return [[NSUserDefaults standardUserDefaults] boolForKey:@"RunInParallel"];  
}

- (void)hideDetails {
  [_detailsView removeFromSuperview];
  [_detailsToggleButton setState:NSOffState];
  [self setShowingDetails:NO];
}

- (void)showDetails {
  CGFloat windowWidth = self.view.window.frame.size.width;
  CGFloat minWindowWidth = MIN_WINDOW_WIDTH;
  if (windowWidth < minWindowWidth) {
    NSRect frame = self.view.window.frame;
    frame.size.width = minWindowWidth;
    [self.view.window setFrame:frame display:YES animate:YES];
  }
  [_splitView addSubview:_detailsView];
  [_detailsToggleButton setState:NSOnState];
  [self setShowingDetails:YES];
}

- (IBAction)toggleDetails:(id)sender {	
	if ([self isShowingDetails]) {
    [self hideDetails];
	} else {
    [self showDetails];
  }
}

- (void)loadDefaults {
	if (![self isShowingDetails]) {
    [self hideDetails];
	}
}

- (void)saveDefaults {
	[dataSource_ saveDefaults];
  [[NSUserDefaults standardUserDefaults] setInteger:_textSegmentedControl.selectedSegment forKey:@"TextSelectedSegment"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)_formatText:(NSString *)text {
	if (text) return [NSString stringWithFormat:@"%@\n", text]; // Newline important for when we append streaming text
  return @"";
}

- (NSString *)stackTraceForSelectedRow:(id<GRTest>)test {
  if (![test exception]) return @"";
  NSString *text = [GRTesting descriptionForException:[test exception]];
  return [self _formatText:text];
}

- (NSString *)logForSelectedRow:(id<GRTest>)test {
  NSString *text = [[test log] componentsJoinedByString:@"\n"]; // TODO(gabe): This isn't very performant
  return [self _formatText:text];
}

- (NSString *)textForSegment:(NSInteger)segment test:(id<GRTest>)test {
  if (!test) return @"";
  switch(segment) {
		case 0: return [self stackTraceForSelectedRow:test];
		case 1: return [self logForSelectedRow:test];
	}
  return nil;
}

- (void)_updateDetailForTest:(id<GRTest>)test prefix:(NSString *)prefix {
  NSMutableString *text = [NSMutableString string];
  if (prefix) [text appendFormat:@"\n\t%@\n\n", prefix];
  NSString *testDetail = [self textForSegment:[_textSegmentedControl selectedSegment] test:test];
  if (testDetail) [text appendString:testDetail];
  [_textView setString:text];
  self.exceptionFilename = [GRTesting exceptionFilenameForTest:test];  
  self.exceptionLineNumber = [GRTesting exceptionLineNumberForTest:test];
}

- (IBAction)updateTextSegment:(id)sender {
  [self _updateDetailForTest:[self selectedTest] prefix:nil];
}

- (GRTestNode *)selectedNode {
  NSInteger row = [_outlineView selectedRow];
	if (row < 0) return nil;
  return [_outlineView itemAtRow:row];  
}

- (id<GRTest>)selectedTest {
	return [self selectedNode].test;
}

- (void)selectFirstFailure {
	GRTestNode *failedNode = [dataSource_ findFailure];
	NSInteger row = [_outlineView rowForItem:failedNode];
	if (row >= 0) {		
    [self selectRow:row];
	}
}

- (void)selectRow:(NSInteger)row {
  if (row >= 0)
    [_outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
  
  [_textView setString:@""];
  
	[self updateTextSegment:_textSegmentedControl];
  
  self.exceptionFilename = [[self selectedNode] exceptionFilename];  
  self.exceptionLineNumber = [[self selectedNode] exceptionLineNumber];
  
}

- (void)_updateTest:(id<GRTest>)test {
	GRTestNode *testNode = [dataSource_ findTestNodeForTest:test];
	[_outlineView reloadItem:testNode];	

	NSInteger runCount = [suite_ stats].succeedCount + [suite_ stats].failureCount;
	NSInteger totalRunCount = [suite_ stats].testCount - ([suite_ disabledCount]);
	if (dataSource_.isRunning)
		self.statusProgress = ((double)runCount/(double)totalRunCount) * 100.0;
	self.status = [dataSource_ statusString:@"Status: "];
}

#pragma mark Delegates (GRTestOutlineViewModel)

- (void)testOutlineViewModelDidChangeSelection:(GRTestOutlineViewModel *)testOutlineViewModel {
  [self selectRow:-1];
}

#pragma mark Delegates (GRTestRunner)

- (void)testRunner:(GRTestRunner *)runner didLog:(NSString *)message {
	
}

- (void)testRunner:(GRTestRunner *)runner test:(id<GRTest>)test didLog:(NSString *)message {
	id<GRTest> selectedTest = self.selectedTest;
	if ([_textSegmentedControl selectedSegment] == 1 && [selectedTest isEqual:test]) {
		[_textView replaceCharactersInRange:NSMakeRange([[_textView string] length], 0) 
														 withString:[NSString stringWithFormat:@"%@\n", message]];
		// TODO(gabe): Scroll
	}	
}

- (void)testRunner:(GRTestRunner *)runner didStartTest:(id<GRTest>)test {
	[self _updateTest:test];
}

- (void)testRunner:(GRTestRunner *)runner didUpdateTest:(id<GRTest>)test {
	[self _updateTest:test];
}

- (void)testRunner:(GRTestRunner *)runner didEndTest:(id<GRTest>)test {
	[self _updateTest:test];
  [self updateTextSegment:nil]; // In case test is selected before it ran
}

- (void)testRunnerDidStart:(GRTestRunner *)runner { 	
  self.running = YES;
	[self _updateTest:runner.test];  
}

- (void)testRunnerDidEnd:(GRTestRunner *)runner {
	[self _updateTest:runner.test];
	self.status = [dataSource_ statusString:@"Status: "];
	//[self selectFirstFailure];
  // TODO(gabe): This should be unnecessary
  self.statusProgress = 100.0;
	self.runLabel = @"Run";
  [dataSource_ saveDefaults];
  self.running = NO;
  
  if (getenv("GHUNIT_AUTOEXIT")) {
    NSLog(@"Exiting (GHUNIT_AUTOEXIT)");
    exit((int)runner.test.stats.failureCount);
    [NSApp terminate:self];
  }  
}

- (void)testRunnerDidCancel:(GRTestRunner *)runner {
	self.runLabel = @"Run";
	self.status = [dataSource_ statusString:@"Cancelled... "];
	self.statusProgress = 0;
  self.running = NO;
}

#pragma mark Delegates (NSSplitView)

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)dividerIndex {
  return 300;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)dividerIndex {
  return [self view].frame.size.width - 335;
}

@end
