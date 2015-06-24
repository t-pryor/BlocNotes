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

- (void)testAllNotesGetter
{
  Note *testNote0 = [[NoteStore sharedInstance] createNote];
  Note *testNote1 = [[NoteStore sharedInstance] createNote];
  Note *testNote2 = [[NoteStore sharedInstance] createNote];
  
  XCTAssertEqualObjects(testNote0, [[[NoteStore sharedInstance] allNotes] firstObject]);
  XCTAssertEqualObjects(testNote1, [[[NoteStore sharedInstance] allNotes] objectAtIndex:1]);
  XCTAssertEqualObjects(testNote2, [[[NoteStore sharedInstance] allNotes] objectAtIndex:2]);

}

- (void)testSaveChanges
{
 
  [[NoteStore sharedInstance] createNote];
  [[NoteStore sharedInstance] createNote];
  [[NoteStore sharedInstance] createNote];
  
  BOOL successful = [[NoteStore sharedInstance] saveChanges];
  
  XCTAssertEqual(successful, YES);
  
}



- (void)testLoadAllNotes
{
  
  [[NoteStore sharedInstance] createNote];
  [[NoteStore sharedInstance] createNote];
  [[NoteStore sharedInstance] createNote];
  
  BOOL successful = [[NoteStore sharedInstance] saveChanges];
  
  XCTAssertEqual(successful, YES);
  
  
}

- (void)testRemoveNote
{
  XCTAssertEqual([[[NoteStore sharedInstance] allNotes]count], 0);
  
  Note *testNote = [[NoteStore sharedInstance] createNote];
  XCTAssertEqual([[[NoteStore sharedInstance] allNotes]count], 1);
  
  [[NoteStore sharedInstance] removeNote:testNote];
  XCTAssertEqual([[[NoteStore sharedInstance] allNotes]count], 0);
  
}

- (void)testCreateFetchRequest
{
  NSFetchRequest *testRequest = [[NoteStore sharedInstance] createFetchRequest];
  
  XCTAssertNotNil(testRequest);
  XCTAssertEqualObjects([testRequest class], [NSFetchRequest class]);
  XCTAssertNotNil([testRequest entity]);
  XCTAssertTrue([[testRequest sortDescriptors] count] > 0);
  
}

- (void)testFetchRequestInitialization
{
  
}








@end
