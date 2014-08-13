//
//  GHTestLogTest.m
//  GRUnit
//
//  Created by Gabriel Handford on 7/30/09.
//  Copyright 2009. All rights reserved.
//

#import "GRTestCase.h"

@interface GHTestLogTest : GRTestCase { }
@end

@implementation GHTestLogTest

- (void)testLog {
  for(NSInteger i = 0; i < 100; i++) {
    GRTestLog(@"Line: %d", (int)i);
    [NSThread sleepForTimeInterval:0.05];
  }
}

- (void)testNSLog {
  for(int i = 0; i < 5; i++) {
    NSLog(@"Using NSLog: %d", i);
    fputs([@"stdout\n" UTF8String], stdout);
    fflush(stdout);   
  }
}

@end
