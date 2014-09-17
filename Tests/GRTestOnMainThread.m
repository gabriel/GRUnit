//
//  GRTestOnMainThread.m
//  GRnit
//
//  Created by Gabriel Handford on 7/18/09.
//  Copyright 2009. All rights reserved.
//

#import "GRTestCase.h"

@interface GRTestOnMainThread : GRTestCase { }
@end

static BOOL gGRTestOnMainThreadRunning = NO;

@implementation GRTestOnMainThread

- (BOOL)shouldRunOnMainThread {
  return YES;
}

- (void)setUp {
  GRAssertTrue([NSThread isMainThread]);
}

- (void)tearDown {
  GRAssertTrue([NSThread isMainThread]);
}

- (void)testFail {
  GRAssertThrows({
    GRAssertTrue([NSThread isMainThread]);
    GRFail(@"Test failure");
  });
}

- (void)testSucceedAfterFail {
  GRAssertTrue([NSThread isMainThread]);
}

- (void)testNotConcurrent {
  GRAssertFalse(gGRTestOnMainThreadRunning);
  [NSThread sleepForTimeInterval:1];
  GRAssertFalse(gGRTestOnMainThreadRunning);
}

@end


@interface GRTestOnMainThreadNotConcurrent : GRTestCase { }
@end

@implementation GRTestOnMainThreadNotConcurrent

- (void)testNotConcurrent {
  gGRTestOnMainThreadRunning = YES;
  [NSThread sleepForTimeInterval:1];
  gGRTestOnMainThreadRunning = NO;
}

@end

