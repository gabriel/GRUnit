//
//  GHTestMacrosTest.m
//  GRUnit
//
//  Created by Gabriel Handford on 7/30/09.
//  Copyright 2009. All rights reserved.
//


#import "GRTestCase.h"


@interface GHTestMacrosTest : GRTestCase { }
@end

@implementation GHTestMacrosTest

- (void)testEquals {
  GRAssertEqualsWithAccuracy(15.0, 15.000001, 0.001);
}

- (void)testEqualsAccuracyMessage {
  GRAssertThrows({
    GRAssertEqualsWithAccuracy(15.0, 16.0, 0.001);
  });
}

- (void)testEqualsFloat {
  float expectedX = 100;
  float actualX = 200;
  GRAssertThrows({
    GRAssertEquals(actualX, expectedX);
  });
}

- (void)testNSLog {
  NSLog(@"Testing NSLog");  
  // TODO(gabe): Test this was output
}

- (void)testGRAssertNotEqualStrings_EXPECTED {
  GRAssertNotEqualStrings(@"a", @"a");
}

- (void)testGRAssertNotEqualStrings {
  GRAssertNotEqualStrings(@"a", @"b");
  GRAssertNotEqualStrings(@"a", nil);
  GRAssertNotEqualStrings(nil, @"a");
  GRAssertThrows({ GRAssertNotEqualStrings(@"a", @"a"); });
}

@end
