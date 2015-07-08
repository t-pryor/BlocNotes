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

- (void)testThatCreateNoteWithBodyCreatesNote
{
    
    Note *testNote = [[NoteStore sharedInstance] createNoteWithBody:@"This is the body of a test note"];
    
    XCTAssertEqualObjects(testNote.body , @"This is the body of a test note");
}

- (void)testFetch
{
    Note *testNote = [[NoteStore sharedInstance] createNoteWithBody:@"This is the body of a test note in the testFetch method"];
    
    //testNote2 identical except for another
    Note *testNote2 = [[NoteStore sharedInstance] createNoteWithBody:@"This is the body of another test note in the testFetch method"];
    
    
    NSArray *fetchedNotes = [[NoteStore sharedInstance] fetchNotesWithBatchSize:20 predicate:nil andSortDescriptors:nil];
    
    NSLog(@"fetched notes: %@", fetchedNotes);
    
    NSPredicate *testPredicate = [NSPredicate predicateWithFormat:@"body == 'This is the body of a test note in the testFetch method'"];
    
    fetchedNotes = [[NoteStore sharedInstance] fetchNotesWithBatchSize:20 predicate:testPredicate andSortDescriptors:nil];
    
    XCTAssertEqualObjects([[fetchedNotes firstObject] body], testNote.body);

    
    NSSortDescriptor *testSort = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:NO];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:testSort,nil];
    
    testPredicate = [NSPredicate predicateWithFormat:@"body LIKE '*testFetch*'"];
    
    
    fetchedNotes = [[NoteStore sharedInstance] fetchNotesWithBatchSize:20 predicate:testPredicate andSortDescriptors:sortDescriptors];
    
    XCTAssertEqualObjects([[fetchedNotes firstObject] body], testNote2.body);
    
    testPredicate = [NSPredicate predicateWithFormat:@"body CONTAINS 'another'"];
    
    fetchedNotes = [[NoteStore sharedInstance] fetchNotesWithBatchSize:20 predicate:testPredicate andSortDescriptors:sortDescriptors];
    
    XCTAssertEqualObjects([[fetchedNotes firstObject] body], testNote2.body);
    
    testPredicate = [NSPredicate predicateWithFormat:@"body CONTAINS 'anotherzzz'"];
    
    fetchedNotes = [[NoteStore sharedInstance] fetchNotesWithBatchSize:20 predicate:testPredicate andSortDescriptors:sortDescriptors];

    XCTAssertNil([fetchedNotes firstObject]);
    
}

- (void)testAllNotesGetter
{
   Note *testNote = [[NoteStore sharedInstance] createNoteWithBody:@"This is the body of a test note in the testAllNotesGetter method"];
    
    XCTAssertEqualObjects(testNote, [[[NoteStore sharedInstance] allNotes] lastObject]);
}



- (void)testDeleteNote
{

    [[NoteStore sharedInstance] createNoteWithBody:@"This is the body of a test note in the testDeleteNote method"];
    
    //testNote2 identical except for another
    [[NoteStore sharedInstance] createNoteWithBody:@"This is the body of another test note in the testAllNotes method"];
    
    int countAfterCreation = [[[NoteStore sharedInstance] allNotes]count];
    
    Note *testNote1 = [[[NoteStore sharedInstance]allNotes]lastObject];
    Note *testNote2 = [[[NoteStore sharedInstance]allNotes]lastObject];
    
    XCTAssertEqualObjects(testNote1, testNote2);
    
    [[NoteStore sharedInstance] deleteNote:testNote1];
    
    int countAfterDeletion = [[[NoteStore sharedInstance] allNotes]count];
    
    testNote1 = [[[NoteStore sharedInstance]allNotes]lastObject];
    
    XCTAssertNotEqualObjects(testNote1, testNote2);
    XCTAssertEqual(countAfterDeletion, countAfterCreation - 1);

}







//

//
//- (void)testSaveChanges
//{
// 
//  [[NoteStore sharedInstance] createNote];
//  [[NoteStore sharedInstance] createNote];
//  [[NoteStore sharedInstance] createNote];
//  
//  BOOL successful = [[NoteStore sharedInstance] saveChanges];
//  
//  XCTAssertEqual(successful, YES);
//  
//}
//
//
//
//- (void)testLoadAllNotes
//{
//  
//  [[NoteStore sharedInstance] loadAllNotes];
//  
//  
//  [[NoteStore sharedInstance] createNote];
//  [[NoteStore sharedInstance] createNote];
//  [[NoteStore sharedInstance] createNote];
//  
//  BOOL successful = [[NoteStore sharedInstance] saveChanges];
//  
//  XCTAssertEqual(successful, YES);
//  
//  [[NoteStore sharedInstance]loadAllNotes];
//  
//  //XCTAssertEqual([[[NoteStore sharedInstance] allNotes] count], 3);
//  
//  
//}
//









@end
