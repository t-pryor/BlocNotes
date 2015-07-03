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
  
    [[NoteStore sharedInstance]createNoteWithTitle:@"Test Note A" andBody:@"Test Note Body A"];
    [[NoteStore sharedInstance]createNoteWithTitle:@"Test Note B" andBody:@"Test Note Body B"];
    [[NoteStore sharedInstance]createNoteWithTitle:@"Test Note C" andBody:@"Test Note Body C"];
    [[NoteStore sharedInstance]createNoteWithTitle:@"Test Note D" andBody:@"Test Note Body D"];
    [[NoteStore sharedInstance]createNoteWithTitle:@"Test Note E" andBody:@"Test Note Body E"];
  
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
//    [[NoteStore sharedInstance]deleteNoteWithTitle:@"Test Note A"];
//    [[NoteStore sharedInstance]deleteNoteWithTitle:@"Test Note B"];
//    [[NoteStore sharedInstance]deleteNoteWithTitle:@"Test Note C"];
//    [[NoteStore sharedInstance]deleteNoteWithTitle:@"Test Note D"];
//    [[NoteStore sharedInstance]deleteNoteWithTitle:@"Test Note E"];
    

    
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
  
  [[NoteStore sharedInstance] loadAllNotes];
  
  
  [[NoteStore sharedInstance] createNote];
  [[NoteStore sharedInstance] createNote];
  [[NoteStore sharedInstance] createNote];
  
  BOOL successful = [[NoteStore sharedInstance] saveChanges];
  
  XCTAssertEqual(successful, YES);
  
  [[NoteStore sharedInstance]loadAllNotes];
  
  //XCTAssertEqual([[[NoteStore sharedInstance] allNotes] count], 3);
  
  
}

- (void)testCreateNoteWithTitleAndBody
{
  Note *testNote = [[NoteStore sharedInstance] createNoteWithTitle:@"test title 1" andBody:@"this is just a test body 1"];
  
  XCTAssertEqualObjects(testNote.title, @"test title 1");
  XCTAssertEqualObjects(testNote.body , @"this is just a test body 1");
  XCTAssertTrue(testNote.dateCreated);
  
}

- (void)testFetchNoteWithTitle
{
  [[NoteStore sharedInstance] createNoteWithTitle:@"test title 2" andBody:@"this is just a test body 2"];
  
  Note *fetchedTestNote = [[NoteStore sharedInstance] fetchNoteWithTitle:@"test title 2"];
  
  XCTAssertEqualObjects(fetchedTestNote.title, @"test title 2");
  
  
}






- (void)testDeleteNote
{

  Note *testNote1 = [[[NoteStore sharedInstance]allNotes]lastObject];
  Note *testNote2 = [[[NoteStore sharedInstance]allNotes]lastObject];
  
  XCTAssertEqualObjects(testNote1, testNote2);
  NSLog(@"TEST NOTE1 TITLE:  %@", testNote1.title);
  
  [[NoteStore sharedInstance] deleteNote:testNote1];
  NSLog(@"TEST NOTE1 TITLE:  %@", testNote1.title);

  
  testNote1 = [[[NoteStore sharedInstance]allNotes]lastObject];
  NSLog(@"TEST NOTE1 TITLE:  %@", testNote1.title);
  
  XCTAssertNotEqualObjects(testNote1, testNote2);
  
  NSLog(@"******************");
  NSLog(@"ALL NOTES COUNT:  %d", [[[NoteStore sharedInstance] allNotes]count]);
  
}

- (void)testDeleteNoteWithTitle //15:22:59
{
    [[NoteStore sharedInstance] createNoteWithTitle:@"Test Delete Note" andBody: @"Test Delete Note Body"];
    
    XCTAssertNotNil([[NoteStore sharedInstance]fetchNoteWithTitle:@"Test Delete Note"]);
    
    [[NoteStore sharedInstance]deleteNoteWithTitle:@"Test Delete Note"];
    
    XCTAssertNil([[NoteStore sharedInstance]fetchNoteWithTitle:@"Test Delete Note"]);
}

- (void)testCreateFetchRequest
{
  NSFetchRequest *testRequest = [[NoteStore sharedInstance] createFetchRequest];
  
  XCTAssertNotNil(testRequest);
  XCTAssertEqualObjects([testRequest class], [NSFetchRequest class]);
  XCTAssertNotNil([testRequest entity]);
  XCTAssertTrue([[testRequest sortDescriptors] count] > 0);
  
}

- (void)testEditNoteWithTitle
{
    Note *testNote = [[NoteStore sharedInstance]fetchNoteWithTitle:@"Test Note C"];
    
    XCTAssertEqualObjects(testNote.body, @"Test Note Body C");
    
    
    [[NoteStore sharedInstance] editNoteWithTitle:@"Test Note C"
     withNewBody:@"Test Note Body NEW C"];
    
    testNote = [[NoteStore sharedInstance]fetchNoteWithTitle:@"Test Note C"];
    
    XCTAssertNotEqualObjects(testNote.body, @"Test Note Body C");
    
}









@end
