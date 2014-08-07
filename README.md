# GRUnit 

GRUnit is a test framework for iOS which runs as a Test (app) target in your project.

## Install

### Install the GRUnit gem

```xml
$ gem install grunit
```

### Install the Tests target

This will edit your ProjectName.xcodeproj file and create a Tests target, scheme, and a sample test file.

```xml
$ grunit install -n ProjectName
```

### Add the Tests target to your Podfile

Create a new file named `Podfile` in the directory that contains the your `.xcodeproj` file, or edit it if it already exists.

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

### Install Command Line

```xml
$ grunit install_cli -n ProjectName
```

Install ios-sim using homebrew:

```xml
$ brew install ios-sim
```

Now you can run tests from the command line:

```xml
$ grunit run -n ProjectName
```

### Add a test

To generate a test in your test target with name SampleTest:

```xml
$ grunit add -n ProjectName -f SampleTest
```

### Sync all files references in main target to test target:

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
}

- (void)testWithCompletion:(dispatch_block_t)completion {
  dispatch_queue_t queue = dispatch_queue_create("MyTest", NULL);
  dispatch_async(queue, ^{
    [NSThread sleepForTimeInterval:2];
    GRTestLog(@"Log something and it will show up in the UI and stdout");

    // Call completion when the test is done
    completion();
  });
}

@end
```

## Test Macros

```
GRAssertNoErr(a1)
GRAssertErr(a1, a2)
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
GRAssertNil(a1)
GRAssertNotNil(a1)
GRAssertTrue(expr)
GRAssertTrueNoThrow(expr)
GRAssertFalse(expr)
GRAssertFalseNoThrow(expr)
GRAssertThrows(expr)
GRAssertThrowsSpecific(expr, specificException)
GRAssertThrowsSpecificNamed(expr, specificException, aName)
GRAssertNoThrow(expr)
GRAssertNoThrowSpecific(expr, specificException)
GRAssertNoThrowSpecificNamed(expr, specificException, aName)
```

## iOS

![GRUnit-IPhone-0.5.8](https://raw.github.com/gh-unit/gh-unit/master/Documentation/images/ios.png)
