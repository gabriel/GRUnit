//
//  GHDispatchTest.m
//  GRUnit
//
//  Created by Gabriel on 7/23/14.
//
//

#import "GRTestCase.h"

@interface GRDispatchTest : GRTestCase { }
@end

@implementation GRDispatchTest

// This is the default setting
- (void)testNotOnMainThread {
  GRAssertFalse([NSThread isMainThread]);
}

- (void)testDispatchWait {
  GRAssertEqualStrings(NSStringFromSelector([self currentSelector]), @"testDispatchWait");
  
  dispatch_queue_t queue = dispatch_queue_create("GHDispatchTest_testDispatchWait", NULL);
  dispatch_group_t group = dispatch_group_create();
  
  dispatch_group_async(group, queue, ^{
    GRTestLog(@"Test logging in dispatch queue before");
    [NSThread sleepForTimeInterval:2];
    GRTestLog(@"Test logging in dispatch queue after");
  });
  
  dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
  
  GRAssertEqualStrings(NSStringFromSelector([self currentSelector]), @"testDispatchWait");
}

- (void)testDispatchWithCompletion:(dispatch_block_t)completion {
  
  GRAssertEqualStrings(NSStringFromSelector([self currentSelector]), @"testDispatchWithCompletion:");
  
  dispatch_queue_t queue = dispatch_queue_create("GHDispatchTest_testDispatchWithCompletion", NULL);
  dispatch_async(queue, ^{
    GRTestLog(@"Test logging in dispatch queue before");
    [NSThread sleepForTimeInterval:2];
    GRTestLog(@"Test logging in dispatch queue after");
    
    //GRAssertEqualStrings(NSStringFromSelector([self currentSelector]), @"testDispatchWithCompletion:");
    
    completion();
  });
}

- (void)_testDispatchFailure:(dispatch_block_t)completion {
  dispatch_queue_t queue = dispatch_queue_create("GHDispatchTest_testDispatchFailure_EXPECTED", NULL);
  dispatch_async(queue, ^{    
    GRFail(@"FAIL!");
  });
}

@end
