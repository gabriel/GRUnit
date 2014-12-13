//
//  GRTestApp.h
//  GHUnit
//
//  Created by Gabriel Handford on 1/20/09.
//  Copyright 2009. All rights reserved.
//

#import "GRTestWindowController.h"

@interface GRTestApp : NSObject

- (id)initWithSuite:(GRTestSuite *)suite;
- (void)runTests;

@end
