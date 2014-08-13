//
//  GHDispatchTest.m
//  GRUnit
//
//  Created by Gabriel on 7/23/14.
//
//

#import "GRTestCase.h"

@interface GHDispatchTest : GRTestCase { }
@end

@implementation GHDispatchTest

// This is the default setting
- (void)testNotOnMainThread {
  GRAssertFalse([NSThread isMainThread]);
}

- (void)testDispatch {
  dispatch_queue_t queue = dispatch_queue_create("GHDispatchTest_testDispatch", NULL);
  dispatch_group_t group = dispatch_group_create();
  
  dispatch_group_async(group, queue, ^{
    GRTestLog(@"Test logging in dispatch queue before");
    [NSThread sleepForTimeInterval:2];
    GRTestLog(@"Test logging in dispatch queue after");
  });
  
  dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

- (void)testDispatchWithCompletion:(dispatch_block_t)completion {
  dispatch_queue_t queue = dispatch_queue_create("GHDispatchTest_testDispatchWithCompletion", NULL);
  dispatch_async(queue, ^{
    GRTestLog(@"Test logging in dispatch queue before");
    [NSThread sleepForTimeInterval:2];
    GRTestLog(@"Test logging in dispatch queue after");
    completion();
  });
}

@end
