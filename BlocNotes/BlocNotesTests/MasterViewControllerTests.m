//
//  MasterViewControllerTests.m
//  BlocNotes
//
//  Created by Tim Pryor on 2015-06-24.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MasterViewController.h"

@interface MasterViewControllerTests : XCTestCase

@end

@implementation MasterViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNSFetchedResultsControllerInitialization
{
  MasterViewController *testMasterVC = [[MasterViewController alloc ]init];
  
  NSFetchedResultsController *testFetchedResultsController = [testMasterVC fetchedResultsController];
  
  XCTAssertNotNil(testFetchedResultsController);
  XCTAssertNotNil(testFetchedResultsController.cacheName);
  XCTAssertNotNil(testFetchedResultsController.delegate);
  
}

- (void)testNumberOfRowsInTableView
{
  
  MasterViewController *testMasterVC = [[MasterViewController alloc ]init];
  
  NSFetchedResultsController *testFetchedResultsController = [testMasterVC fetchedResultsController];
  
 // testMasterVC numberOfSectionsInTableView:<#(UITableView *)#>
  
}




- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
