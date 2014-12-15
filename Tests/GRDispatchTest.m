//
//  GHDispatchTest.m
//  GRUnit
//
//  Created by Gabriel on 7/23/14.
//
//

#import "GRTestCase.h"

@interface GRDispatchTest : GRTestCase
@end

@implementation GRDispatchTest

// This is the default setting
- (void)testNotOnMainThread {
  GRAssertFalse([NSThread isMainThread]);
}

- (void)setUp {
  self.timeout = 3;
}

- (void)testDispatchWait {
  GRAssertEqualStrings(NSStringFromSelector([self selector]), @"testDispatchWait");
  
  dispatch_queue_t queue = dispatch_queue_create("GHDispatchTest_testDispatchWait", NULL);
  dispatch_group_t group = dispatch_group_create();
  
  dispatch_group_async(group, queue, ^{
    GRTestLog(@"Test logging in dispatch queue before");
    [NSThread sleepForTimeInterval:2];
    GRTestLog(@"Test logging in dispatch queue after");
  });
  
  dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
  
  GRAssertEqualStrings(NSStringFromSelector([self selector]), @"testDispatchWait");
}

- (void)testDispatchWithCompletion:(dispatch_block_t)completion {
  
  GRAssertEqualStrings(NSStringFromSelector([self selector]), @"testDispatchWithCompletion:");
  
  dispatch_queue_t queue = dispatch_queue_create("GHDispatchTest_testDispatchWithCompletion", NULL);
  dispatch_async(queue, ^{
    GRTestLog(@"Test logging in dispatch queue before");
    [NSThread sleepForTimeInterval:2];
    GRTestLog(@"Test logging in dispatch queue after");
    
    //GRAssertEqualStrings(NSStringFromSelector([self selector]), @"testDispatchWithCompletion:");
    
    completion();
  });
}

- (void)_testDispatchFailure:(dispatch_block_t)completion {
  dispatch_queue_t queue = dispatch_queue_create("GHDispatchTest_testDispatchFailure_EXPECTED", NULL);
  dispatch_async(queue, ^{    
    GRFail(@"FAIL!");
  });
}

- (void)testDispatchTimeout:(dispatch_block_t)completion {
  dispatch_queue_t queue = dispatch_queue_create("GHDispatchTest_testDispatchTimeout", NULL);
  dispatch_async(queue, ^{
    [NSThread sleepForTimeInterval:3.1];
  });
}

@end


@interface GRDispatchSetUpTest : GRTestCase
@property BOOL setUpAsync;
@end

@implementation GRDispatchSetUpTest

- (void)setUp:(dispatch_block_t)completion {
  dispatch_queue_t queue = dispatch_queue_create("GRDispatchSetUpTest", NULL);
  dispatch_async(queue, ^{
    _setUpAsync = YES;
    completion();
  });
}

- (void)tearDown:(dispatch_block_t)completion {
  dispatch_queue_t queue = dispatch_queue_create("GRDispatchSetUpTest", NULL);
  dispatch_async(queue, ^{
    completion();
  });
}

- (void)testSetUpAsync {
  GRAssertTrue(_setUpAsync);
}

@end
