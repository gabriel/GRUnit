//
//  GRUnitIOSTestViewController.m
//  GRUnit
//
//  Created by Gabriel Handford on 2/20/09.
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

#import "GRUnitIOSTestViewController.h"

#import "GRUnitIOSTestView.h"

@interface GRUnitIOSTestViewController ()
@property GRUnitIOSTestView *testView;
@property GRTestNode *testNode;
@end

@implementation GRUnitIOSTestViewController

- (id)init {
  if ((self = [super init])) {
    UIBarButtonItem *runButton = [[UIBarButtonItem alloc] initWithTitle:@"Re-run" style:UIBarButtonItemStyleDone
                                                 target:self action:@selector(_runTest)];
    self.navigationItem.rightBarButtonItem = runButton;
  }
  return self;
}


- (void)loadView {
  _testView = [[GRUnitIOSTestView alloc] init];
  self.view = _testView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

- (BOOL)shouldAutorotate {
  return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskAll;
}

- (void)_runTest {
  id<GRTest> testCopy = [_testNode.test copyWithZone:NULL];
  NSLog(@"Re-running: %@", testCopy);
  [_testView setText:@"Running..."];
  GRTestRunner *runner = [GRTestRunner runnerForTest:testCopy];
  runner.delegate = _runnerDelegate;
  GHUWeakSelf blockSelf = self;
  [runner run:^(id<GRTest> test) {
    [blockSelf setTest:test runnerDelegate:blockSelf.runnerDelegate];
  }];
}

- (NSString *)updateTestView {
  NSMutableString *text = [NSMutableString stringWithCapacity:200];
  [text appendFormat:@"%@ %@\n", [_testNode identifier], [_testNode statusString]];
  NSString *log = [_testNode log];
  if (log) [text appendFormat:@"\nLog:\n%@\n", log];
  NSString *stackTrace = [_testNode stackTrace];
  if (stackTrace) [text appendFormat:@"\n%@\n", stackTrace];
  [_testView setText:text];
  return text;
}

- (void)setTest:(id<GRTest>)test runnerDelegate:(id<GRTestRunnerDelegate>)runnerDelegate {
  _runnerDelegate = runnerDelegate;
  
  [self view];
  self.title = [test name];

  _testNode = [GRTestNode nodeWithTest:test children:nil source:nil];
  NSString *text = [self updateTestView];
  NSLog(@"%@", text);
}

@end
