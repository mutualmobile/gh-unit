//
//  GHAsyncTestCaseTest.m
//  GHUnit
//
//  Created by Gabriel Handford on 4/8/09.
//  Copyright 2009. All rights reserved.
//

#import "GHAsyncTestCase.h"

@interface GHAsyncTestCaseTest : GHAsyncTestCase { }
@end

@implementation GHAsyncTestCaseTest

- (void)setUp {  
    [super setUp];
    [self prepare:_cmd];
    [self performSelector:@selector(_testSetupSuccessNotify) withObject:nil afterDelay:5.0];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:100.0];
}

- (void)testStatusSuccess {
  [self prepare];
  [self performSelector:@selector(_testStatusSuccessNotify) withObject:nil afterDelay:0.0];
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
}

- (void)_testStatusSuccessNotify {
  [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testStatusSuccess)];
}

- (void)_testSetupSuccessNotify {
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(setUp)];
}

- (void)testStatusFailure {
  [self prepare];
  [self performSelector:@selector(_testStatusFailureNotify) withObject:nil afterDelay:0.0];
  [self waitForStatus:kGHUnitWaitStatusFailure timeout:1.0];
}

- (void)_testStatusFailureNotify {
  [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testStatusFailure)];
}

- (void)testStatusSuccessWithDelay {
  [self prepare];
  [self performSelector:@selector(_testStatusSuccessWithDelayNotify) withObject:nil afterDelay:0.3];
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
}

- (void)_testStatusSuccessWithDelayNotify {
  [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testStatusSuccessWithDelay)];
}

- (void)testBadStatus { 
  [self prepare];
  [self performSelector:@selector(_testBadStatusNotify) withObject:nil afterDelay:0.0];
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:2.0];
}

- (void)_testBadStatusNotify {
   GHTestLog(@"%@", @"stuff");

  [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testBadStatus)];
}

- (void)testMissingPrepare {
  GHAssertThrows([self waitForStatus:kGHUnitWaitStatusUnknown timeout:1.0], @"Should fail since we didn't call prepare");
}

- (void)testFinishBeforeWait {
  [self prepare];
  [self performSelectorInBackground:@selector(_testFinishBeforeWaitNotify) withObject:nil];
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]]; // 0.2 is arbitrary, we want enough time for performSelectorInBackground to be called
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
}

- (void)_testFinishBeforeWaitNotify {
  [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testFinishBeforeWait)];
}

- (void)testWaitNoSelectorCheck {
  [self prepare];
  [self performSelectorInBackground:@selector(_testWaitNoSelectorCheck) withObject:nil];
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
}

- (void)_testWaitNoSelectorCheck {
  [self notify:kGHUnitWaitStatusSuccess forSelector:NULL];
}

@end


@interface GHAsyncExceptionTest : GHAsyncTestCase { }
@end

@implementation GHAsyncExceptionTest



- (BOOL)shouldRunOnMainThread {
  return YES;
}

- (void)setUp {  
    [super setUp];
    [self prepare:_cmd];
    [self performSelector:@selector(_testSetupSuccessNotify) withObject:nil afterDelay:10.0];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:100.0];
}

- (void)_testSetupSuccessNotify {
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(setUp)];
}
/*
- (void)test_EXPECTED {
  [self prepare];
  [self performSelectorInBackground:@selector(_delayedRaise) withObject:nil];
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
}*/

- (void)_delayedRaise {
  [self performSelectorOnMainThread:@selector(_raiseException) withObject:nil waitUntilDone:YES];
}

- (void)_raiseException {
  [NSException raise:NSGenericException format:@"Test exception"];
}
   
@end

