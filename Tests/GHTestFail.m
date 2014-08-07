//
//  GHTestFail.m
//  GRUnit
//
//  Created by Gabriel Handford on 7/15/09.
//  Copyright 2009. All rights reserved.
//

#import "GRTestCase.h"

@interface GHTestFail : GRTestCase { }
@end

@implementation GHTestFail

- (void)testFail_EXPECTED {
  GRFail(@"Test failure");
}

- (void)testSucceedAfterFail {
}

@end
