//
//  GRTest.m
//  GRUnit
//
//  Created by Gabriel Handford on 1/18/09.
//  Copyright 2009. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "GRTest.h"

#import "GRTesting.h"
#import "GRTestCase.h"

NSString * const GRUnitTimeoutException = @"GRUnitTimeoutException";

NSString *NSStringFromGRTestStatus(GRTestStatus status) {
  switch(status) {
    case GRTestStatusNone: return NSLocalizedString(@"Waiting", nil);
    case GRTestStatusRunning: return NSLocalizedString(@"Running", nil);
    case GRTestStatusCancelling: return NSLocalizedString(@"Cancelling", nil);
    case GRTestStatusSucceeded: return NSLocalizedString(@"Succeeded", nil);
    case GRTestStatusErrored: return NSLocalizedString(@"Errored", nil);
    case GRTestStatusCancelled: return NSLocalizedString(@"Cancelled", nil);
      
    default: return NSLocalizedString(@"Unknown", nil);
  }
}

GRTestStats GRTestStatsMake(NSInteger succeedCount, NSInteger failureCount, NSInteger testCount) {
  GRTestStats stats;
  stats.succeedCount = succeedCount;
  stats.failureCount = failureCount;
  stats.testCount = testCount;
  return stats;
}

const GRTestStats GRTestStatsEmpty = {0, 0, 0};

NSString *NSStringFromGRTestStats(GRTestStats stats) {
  return [NSString stringWithFormat:@"%@/%@/%@", @(stats.succeedCount), @(stats.failureCount), @(stats.testCount)];
}

BOOL GRTestStatusIsRunning(GRTestStatus status) {
  return (status == GRTestStatusRunning || status == GRTestStatusCancelling);
}

BOOL GRTestStatusEnded(GRTestStatus status) {
  return (status == GRTestStatusSucceeded 
          || status == GRTestStatusErrored
          || status == GRTestStatusCancelled
          || status == GRTestStatusNone);
}

@interface GRTest ()
@property NSString *identifier;
@property NSString *name;
@property NSMutableArray *log;
@end

@protocol GRTestSetUpTearDown
- (void)_setUp;
- (void)_tearDown;
@end


@implementation GRTest

- (id)initWithIdentifier:(NSString *)identifier name:(NSString *)name delegate:(id<GRTestDelegate>)delegate {
  if ((self = [self init])) {
    _identifier = identifier;
    _name = name;
    _interval = -1;
    _delegate = delegate;
  }
  return self;
}

- (id)initWithTestCase:(GRTestCase *)testCase selector:(SEL)selector delegate:(id<GRTestDelegate>)delegate {
  NSString *name = NSStringFromSelector(selector);
  NSString *identifier = [NSString stringWithFormat:@"%@/%@", NSStringFromClass(testCase.class), name];
  if ((self = [self initWithIdentifier:identifier name:name delegate:delegate])) {
    _testCase = testCase;
    _selector = selector;
  }
  return self;  
}


- (BOOL)isEqual:(id)test {
  return ((test == self) || 
          ([test conformsToProtocol:@protocol(GRTest)] && 
           [self.identifier isEqual:[test identifier]]));
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ %@", self.identifier, [super description]];
}

- (GRTestStats)stats {
  switch(_status) {
    case GRTestStatusSucceeded: return GRTestStatsMake(1, 0, 1);
    case GRTestStatusErrored: return GRTestStatsMake(0, 1, 1);
    case GRTestStatusCancelled: return GRTestStatsMake(0, 0, 1);
    default:
      return GRTestStatsMake(0, 0, 1);
  }
}

- (void)reset {
  _status = GRTestStatusNone;
  _interval = 0;
  _exception = nil;
  [_delegate testDidUpdate:self source:self];
}

- (void)cancel {
  if (_status == GRTestStatusRunning) {
    _status = GRTestStatusCancelling;
    // TODO(gabe): Call cancel on target if available?    
  } else {
    _status = GRTestStatusCancelled;
  }
  [_testCase cancel];
  [_delegate testDidUpdate:self source:self];
}

- (void)setDisabled:(BOOL)disabled {
  _disabled = disabled;
  [_delegate testDidUpdate:self source:self];
}

- (void)setHidden:(BOOL)hidden {
  _hidden = hidden;
  [_delegate testDidUpdate:self source:self];
}

- (NSInteger)disabledCount {
  return (_disabled || _hidden ? 1 : 0);
}

- (void)setException:(NSException *)exception {
  _exception = exception;
  _status = GRTestStatusErrored;
  [_delegate testDidUpdate:self source:self];
}

- (void)_didRunWithInterval:(NSTimeInterval)interval exception:(NSException *)exception completion:(GRTestCompletionBlock)completion {
  _exception = exception; // nil if didn't error
  _interval = interval;
  
  [self _setLogWriter:nil];
  
  if (_exception) {
    _status = GRTestStatusErrored;
  }
  
  if (_status == GRTestStatusCancelling) {
    _status = GRTestStatusCancelled;
  } else if (_status == GRTestStatusRunning) {
    _status = GRTestStatusSucceeded;
  }
  
  [_delegate testDidEnd:self source:self];
  
  completion(self);
  
  [_testCase setCurrentTest:nil];
}

- (void)run:(dispatch_queue_t)queue completion:(GRTestCompletionBlock)completion {
  if (_status == GRTestStatusCancelled || _disabled || _hidden) {
    completion(self);
    return;
  }
  
  _status = GRTestStatusRunning;
  
  [_delegate testDidStart:self source:self];
  
  [self _setLogWriter:self];

  _exception = nil;
  
  [_testCase setCurrentTest:self];
  
  [self runTest:^(NSException *exception, NSTimeInterval interval) {
    [self _didRunWithInterval:interval exception:exception completion:completion];
  }];
}

- (void)_setUp:(dispatch_block_t)afterSetup completion:(void (^)(NSException *exception, NSTimeInterval interval))completion {
  @try {
    if ([_testCase respondsToSelector:@selector(setUp)]) {
      [(id)_testCase setUp];
    }

    if ([_testCase respondsToSelector:@selector(setUp:)]) {
      [(id)_testCase setUp:afterSetup];
    } else {
      afterSetup();
    }
  } @catch(NSException *e) {
    completion(nil, 0);
    return;
  }
}

- (void)_tearDown:(void (^)(NSException *exception))completion {
  @try {
    [_testCase tearDownForTestCase];
    
    if ([_testCase respondsToSelector:@selector(tearDown)]) {
      [(id)_testCase tearDown];
    }
    
    if ([_testCase respondsToSelector:@selector(tearDown:)]) {
      [(id)_testCase tearDown:^{
        completion(nil);
      }];
    } else {
      completion(nil);
    }
  } @catch(NSException *e) {
    completion(e);
  }
}

- (void)runTest:(void (^)(NSException *exception, NSTimeInterval interval))completion {
  __weak GRTest *blockSelf = self;
  [self _setUp:^{
    [blockSelf _runTest:completion];
  } completion:completion];
}

- (void)_runTest:(void (^)(NSException *exception, NSTimeInterval interval))completion {
  NSDate *startDate = [NSDate date];
  
  @try {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    NSMethodSignature *signature = [_testCase methodSignatureForSelector:_selector];
    if ([signature numberOfArguments] == 2) {
      [_testCase performSelector:_selector];
      [self _tearDown:^(NSException *e) {
        completion(e, [[NSDate date] timeIntervalSinceDate:startDate]);
      }];
    } else {
      // Run target with completion block (asynchronous)
      [_testCase performSelector:_selector withObject:^() {
        [self _tearDown:^(NSException *e) {
          completion(e, [[NSDate date] timeIntervalSinceDate:startDate]);
        }];
      }];      
    }
#pragma clang diagnostic pop
    
  } @catch(NSException *e) {
    completion(e, [[NSDate date] timeIntervalSinceDate:startDate]);
  }
}

- (void)log:(NSString *)message testCase:(id)testCase {
  if (!_log) _log = [NSMutableArray array];
  [_log addObject:message];
  [_delegate test:self didLog:message source:self];
}

#pragma mark Log Writer

- (void)_setLogWriter:(id<GRTestCaseLogWriter>)logWriter {
  [_testCase setLogWriter:logWriter];
} 

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
  [coder encodeObject:_identifier forKey:@"identifier"];
  [coder encodeBool:_hidden forKey:@"hidden"];
  [coder encodeInteger:_status forKey:@"status"];
  [coder encodeDouble:_interval forKey:@"interval"];
}

- (id)initWithCoder:(NSCoder *)coder {
  GRTest *test = [self initWithIdentifier:[coder decodeObjectForKey:@"identifier"] name:nil delegate:nil];
  test.hidden = [coder decodeBoolForKey:@"hidden"];
  test.status = [coder decodeIntegerForKey:@"status"];
  test.interval = [coder decodeDoubleForKey:@"interval"];
  return test;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
  if (!_testCase) [NSException raise:NSObjectNotAvailableException format:@"NSCopying unsupported for tests without target/selector pair"];
  return [[GRTest allocWithZone:zone] initWithTestCase:_testCase selector:_selector delegate:_delegate];
}

@end
