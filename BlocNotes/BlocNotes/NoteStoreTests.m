//
//  NoteStoreTests.m
//  BlocNotes
//
//  Created by Tim Pryor on 2015-06-18.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NoteStore.h"

@interface NoteStoreTests : XCTestCase

@end

@implementation NoteStoreTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


// Testing: Test init method

- (void)testInitReturnsNil
{
  NoteStore *testStore = [[NoteStore alloc] init];
  XCTAssertNil(testStore);
}


/*** [NoteStore sharedInstance] and associated initPrivate method ***/

- (void)testNoteStoreSharedInstanceReturnsNoteStoreSingleton
{
  NoteStore *testStore = [NoteStore sharedInstance];
  NoteStore *testStore2 = [NoteStore sharedInstance];
  
  XCTAssertEqualObjects(testStore, testStore2);
  
}

- (void)testThatCreateNoteSuccessfullyCreatesNote
{
  Note *testNote = [[NoteStore sharedInstance] createNote];
  
  XCTAssertEqualObjects([testNote class], [Note class]);
  
}







@end
