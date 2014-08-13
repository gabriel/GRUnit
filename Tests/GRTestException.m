//
//  GRTestFailWithException.m
//  GRUnit
//
//  Created by Gabriel on 8/6/14.
//
//

#import "GRTestCase.h"

@interface GRTestException : GRTestCase { }
@end

@implementation GRTestException : GRTestCase { }

- (void)testException_EXPECTED {
  GRTestLog(@"Will raise an exception");
  [NSException raise:@"SomeException" format:@"Some reason for the exception"];
}

@end

