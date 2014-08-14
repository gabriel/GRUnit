//
//  GRTestMacrosTest.m
//  GRUnit
//
//  Created by Gabriel Handford on 7/30/09.
//  Copyright 2009. All rights reserved.
//


#import "GRTestCase.h"


@interface GRTestMacrosTest : GRTestCase { }
@end

@interface TestException : NSException
@end
@implementation TestException
@end

@implementation GRTestMacrosTest

- (void)testEquals {
  GRAssertEquals(1U, 1U);
  GRAssertThrows({
    GRAssertEquals(1U, 2.2);
  });
}

- (void)testEqualsAccuracy {
  GRAssertEqualsWithAccuracy(15.0, 15.000001, 0.001);
  GRAssertThrows({
    GRAssertEqualsWithAccuracy(15.0, 16.0, 0.001);
  });
}

- (void)testEqualObjects {
  GRAssertEqualObjects([NSNumber numberWithInt:1], [NSNumber numberWithInt:1]);
  GRAssertNotEqualObjects([NSNumber numberWithInt:1], [NSNumber numberWithInt:2]);
}

- (void)testThrows {
  GRAssertThrowsSpecific({
    [NSException raise:NSInvalidArgumentException format:@"Test"];
  }, NSException);
  
  GRAssertThrowsSpecificNamed({  
    [NSException raise:NSInvalidArgumentException format:@"Test"];
  }, NSException, NSInvalidArgumentException);
  
  GRAssertNoThrowSpecific({
    [NSException raise:NSInvalidArgumentException format:@"Test"];
  }, TestException);
  
  GRAssertNoThrow({
    
  });
}

- (void)testAssertNotEqualStrings {
  GRAssertNotEqualStrings(@"a", @"b");
  GRAssertNotEqualStrings(@"a", nil);
  GRAssertNotEqualStrings(nil, @"a");
  GRAssertThrows({
    GRAssertNotEqualStrings(@"a", @"a");
  });
}

@end
