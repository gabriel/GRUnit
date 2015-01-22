//
//  GRTestCase.m
//  GRUnit
//
//  Created by Gabriel Handford on 1/21/09.
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

#import "GRTestCase.h"
#import "GRTesting.h"

@implementation GRTestCase

- (BOOL)shouldRunOnMainThread {
  return NO;
}

- (void)tearDownForTestCase {
  _cancelling = NO;
}

- (BOOL)isCLIDisabled {
  return NO;
}

- (void)log:(NSString *)message {
  [_logWriter log:message testCase:self];
}

- (void)cancel {
  _cancelling = YES;
}

- (void)wait:(NSTimeInterval)timeout {
  NSArray *runLoopModes = @[NSDefaultRunLoopMode, NSRunLoopCommonModes];
  
  if (timeout == 0) timeout = 60; // Default timeout seconds
  
  NSTimeInterval checkEveryInterval = 0.01; // TODO: Polling is slow
  
  NSDate *runUntilDate = [NSDate dateWithTimeIntervalSinceNow:timeout];
  BOOL timedOut = NO;
  NSUInteger runIndex = 0;
  
  while (!GRTestStatusEnded(_currentTest.status)) {
    NSString *mode = runLoopModes[runIndex++ % runLoopModes.count];
    
    @autoreleasepool {
      if (!mode || ![NSRunLoop.currentRunLoop runMode:mode beforeDate:[NSDate dateWithTimeIntervalSinceNow:checkEveryInterval]]) {
        // If there were no run loop sources or timers then we should sleep for the interval
        [NSThread sleepForTimeInterval:checkEveryInterval];
      }
    }
    
    // If current date is after the run until date
    if ([runUntilDate compare:[NSDate date]] == NSOrderedAscending) {
      timedOut = YES;
      break;
    }
  }
  
  if (timedOut) {
    NSException *e = [NSException exceptionWithName:GRUnitTimeoutException reason:@"Timed out" userInfo:@{}];
    [e raise];
  }
}


@end
