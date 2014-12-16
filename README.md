# GRUnit 

GRUnit is a test framework for iOS and OSX which runs as a Test (app) target in your project. It's meant to be very similar to XCTest and supports asynchronous testing with timeouts. By default, it is meant to raise an Exception on test failure, so you can use an exception breakpoint and debug in Xcode at the point of failure.



![GRUnit-1.0.1a](https://raw.githubusercontent.com/gabriel/GRUnit/master/GRUnit-1.0.1a.png)
![GRUnit-1.0.1b](https://raw.githubusercontent.com/gabriel/GRUnit/master/GRUnit-1.0.1b.png)

Projects using GRUnit:

* [NAChloride](https://github.com/gabriel/NAChloride)
* [MPMessagePack](https://github.com/gabriel/MPMessagePack)
* [TSTripleSec](https://github.com/gabriel/TSTripleSec)

## Install

### Install the GRUnit gem

This gem makes it easy to setup a test app target.

```xml
$ gem install grunit
```

### Install the Tests target

This will edit your ProjectName.xcodeproj file and create a Tests target, scheme, and a sample test file. Its ok to run this multiple times, it won't duplicate any files, targets or schemes.

```xml
$ grunit install -n ProjectName
```

### Add the Tests target to your Podfile

Setup your Podfile to include GRUnit for the Tests target you just created. 

```ruby
# Podfile
platform :ios, '7.0'

target :Tests do
	pod 'GRUnit', '~> 1.0.1'
end
```

Install your project's pods. CocoaPods will then download and configure the required libraries for your project:

```xml
$ pod install
```

Note: If you don't have a Tests target in your project, you will get an error: "[!] Unable to find a target named Tests". If you named your test target something different, such as "ProjectTests" then the Podfile target line should look like: `target :ProjectTests do` instead.

You should use the `.xcworkspace` file to work on your project:

```xml
$ open ProjectName.xcworkspace
```

### Add a test

To generate a test in your test target with name SampleTest:

```xml
$ grunit add -n ProjectName -f SampleTest
```

or read the `GRTestCase` example below.

### Sync all files references in main target to test target:

If you want to link all the files in your main target to the test target in your project file, run this sync command.

```xml
$ grunit sync -n ProjectName
```

## GRTestCase

```objc
#import <GRUnit/GRUnit.h>

@interface MyTest : GRTestCase
@end

@implementation MyTest

- (void)test {
  GRAssertEquals(1U, 1U);
  GRAssertEqualStrings(@"a string", @"a string");
  GRAssertEqualObjects(@[@"test"], expectedArray);
  // See more macros below

  // To log in a test and have it show in the UI with this test
  GHTestLog(@"Log this number: %@", @(123));
}

// Test with completion (async) callback
- (void)testWithCompletion:(dispatch_block_t)completion {
  dispatch_queue_t queue = dispatch_queue_create("MyTest", NULL);
  dispatch_async(queue, ^{
    [NSThread sleepForTimeInterval:2];
    GRTestLog(@"Log something and it will show up in the UI and stdout");

    // Call completion when the test is done
    completion();
  });
}

- (void)testRunLoopsWithCompletion:(dispatch_block_t)completion {
  // If you are using sockets attached to run loops, you need to 
  // call wait which will run the default and common run loop modes

  [self wait:10]; // Run loops until completion (or timeout after 10 seconds)
}

// For a long test, you can check cancel state and break/return
- (void)testCancel {
  for (NSInteger i = 0; i < 123456789; i++) {
    if (self.isCancelling) break;
  }
}

// Runs before each test
- (void)setUp {
}

// Runs before each test (async)
- (void)setUp:(dispatch_block_t)completion {
  completion();
}

// Runs after each test
- (void)tearDown {
}

// Runs after each test (async)
- (void)tearDown:(dispatch_block_t)completion {
  completion();
}


@end
```

To have all your tests in a test case run on the main thread, implement `shouldRunOnMainThread`.

```objc
@implementation MyTest

- (void)testSomethingOnMainThread {
  GRAssertTrue([NSThread isMainThread]);
}

- (BOOL)shouldRunOnMainThread {
  return YES;
}

@end
```

## Exception Breakpoint

GRUnit works best with an exception breakpoint. So your test run will breakpoint if an error occurs allowing you to interact with the debugger.

https://developer.apple.com/library/ios/recipes/xcode_help-breakpoint_navigator/articles/adding_an_exception_breakpoint.html

When adding the exception breakpoint, you change the action to `Debugger Command` of `po $eax` so it logs the exception to the console automatically.

## Test Macros

```
GRAssertNil(a1)
GRAssertNotNil(a1)
GRAssertTrue(expr)
GRAssertFalse(expr)
GRAssertNotNULL(a1)
GRAssertNULL(a1)
GRAssertNotEquals(a1, a2)
GRAssertNotEqualObjects(a1, a2, desc, ...)
GRAssertOperation(a1, a2, op)
GRAssertGreaterThan(a1, a2)
GRAssertGreaterThanOrEqual(a1, a2)
GRAssertLessThan(a1, a2)
GRAssertLessThanOrEqual(a1, a2)
GRAssertEqualStrings(a1, a2)
GRAssertNotEqualStrings(a1, a2)
GRAssertEqualCStrings(a1, a2)
GRAssertNotEqualCStrings(a1, a2)
GRAssertEqualObjects(a1, a2)
GRAssertEquals(a1, a2)
GHAbsoluteDifference(left,right) (MAX(left,right)-MIN(left,right))
GRAssertEqualsWithAccuracy(a1, a2, accuracy)
GRFail(description, ...)
GRAssertNoErr(a1)
GRAssertErr(a1, a2)
```

### Example Project

This project uses GRUnit. Open `GRUnit.xcworkspace` and run the Tests target.

### Command Line

Install:

```xml
$ grunit install_cli -n ProjectName
```

Install ios-sim using homebrew (for iOS):

```xml
$ brew install ios-sim
```

Now you can run tests from the command line:

This doesn't work right...

```xml
$ grunit run -n ProjectName
```

### Converting from GHUnit

1. Replace `#import <GHUnit/GHUnit.h>` with `#import <GRUnit/GRUnit.h>`
1. Replace `GHTestCase` with `GRTestCase`
1. Replace `GHAssert...` with `GRAssert...` and remove the description argument (usually nil).
1. Replace `GHTestLog` with `GRTestLog`.
1. Replace `GHUnitIOSAppDelegate` with `GRUnitIOSAppDelegate`.
