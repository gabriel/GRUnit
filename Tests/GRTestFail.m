//
//  GRTestFail.m
//  GRUnit
//
//  Created by Gabriel Handford on 7/15/09.
//  Copyright 2009. All rights reserved.
//

#import "GRTestCase.h"

@interface GRTestFail : GRTestCase { }
@end

@implementation GRTestFail

- (void)testFail {
  GRFail(@"Test failure");
  
  //GRAssertEqualsWithAccuracy(15.0, 16.0, 0.001);
  //GRAssertNotEqualStrings(@"a", @"a");
  //GRAssertEquals(1U, 2.2);
}

- (void)testSucceedAfterFail {
}

@end
