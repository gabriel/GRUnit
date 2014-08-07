//
//  GHTestOnMainThread.m
//  GRnit
//
//  Created by Gabriel Handford on 7/18/09.
//  Copyright 2009. All rights reserved.
//

#import "GRTestCase.h"

@interface GHTestOnMainThread : GRTestCase { }
@end

static BOOL gGHTestOnMainThreadRunning = NO;

@implementation GHTestOnMainThread

- (BOOL)shouldRunOnMainThread {
  return YES;
}

- (void)setUp {
  GRAssertTrue([NSThread isMainThread]);
}

- (void)tearDown {
  GRAssertTrue([NSThread isMainThread]);
}

- (void)setUpClass {
  GRAssertTrue([NSThread isMainThread]);
}

- (void)tearDownClass {
  GRAssertTrue([NSThread isMainThread]);
}

- (void)testFail_EXPECTED {
  GRAssertTrue([NSThread isMainThread]);
  GRFail(@"Test failure");
}

- (void)testSucceedAfterFail {
  GRAssertTrue([NSThread isMainThread]);
}

- (void)testNotConcurrent {
  GRAssertFalse(gGHTestOnMainThreadRunning);
  [NSThread sleepForTimeInterval:1];
  GRAssertFalse(gGHTestOnMainThreadRunning);
}


@end


@interface GHTestOnMainThreadNotConcurrent : GRTestCase { }
@end

@implementation GHTestOnMainThreadNotConcurrent

- (void)testNotConcurrent {
  gGHTestOnMainThreadRunning = YES;
  [NSThread sleepForTimeInterval:1];
  gGHTestOnMainThreadRunning = NO;
}

@end

