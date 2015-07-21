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

{
    
    Note *testNote1;
    Note *testNote2;
    
    NoteStore *testStore1;
    NoteStore *testStore2;
    NoteStore *testStore3;
    
}


- (void)setUp {
    [super setUp];
    
    testNote1 = [[NoteStore sharedInstance] createNoteWithTitle:@"testNote1 title"];
    testNote2 = [[NoteStore sharedInstance] createNoteWithTitle:@"testNote2 title"];
    
    testStore1 = [[NoteStore alloc]init];
    testStore2 = [NoteStore sharedInstance];
    testStore3 = [NoteStore sharedInstance];
  
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [[NoteStore sharedInstance] deleteNote:testNote1];
    [[NoteStore sharedInstance] deleteNote:testNote2];
    
}


// Testing: Test init method

- (void)testInitReturnsNil
{
    XCTAssertNil(testStore1);
}


/*** [NoteStore sharedInstance] and associated initPrivate method ***/

- (void)testNoteStoreSharedInstanceReturnsNoteStoreSingleton
{
    XCTAssertEqualObjects(testStore2, testStore3);
}

- (void)testThatCreateNoteSuccessfullyCreatesNote
{
    testNote1 = [[NoteStore sharedInstance] createNote];
    
    XCTAssertEqualObjects([testNote1 class], [Note class]);
}

- (void)testThatCreateNoteWithBodyCreatesNote
{
    testNote1 = [[NoteStore sharedInstance] createNoteWithBody:@"This is the body of a test note"];
    
    XCTAssertEqualObjects(testNote1.body , @"This is the body of a test note");
}

- (void)testCreateNoteWithTitleCreatesNote
{
    XCTAssertEqualObjects(testNote1.title, @"testNote1 title");
}


- (void)testFetch
{
 
    NSArray *fetchedNotes = [[NoteStore sharedInstance] fetchNotesWithBatchSize:20 predicate:nil andSortDescriptors:nil];
    
    NSLog(@"fetched notes: %@", fetchedNotes);
    
    NSPredicate *testPredicate = [NSPredicate predicateWithFormat:@"title == 'testNote1 title'"];
    
    fetchedNotes = [[NoteStore sharedInstance] fetchNotesWithBatchSize:20 predicate:testPredicate andSortDescriptors:nil];
    
    XCTAssertEqualObjects([[fetchedNotes firstObject] title], testNote1.title);

    
    NSSortDescriptor *testSort = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:NO];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:testSort,nil];
    
    testPredicate = [NSPredicate predicateWithFormat:@"title LIKE '*title*'"];
    
    
    fetchedNotes = [[NoteStore sharedInstance] fetchNotesWithBatchSize:20 predicate:testPredicate andSortDescriptors:sortDescriptors];
    
    XCTAssertEqualObjects([[fetchedNotes firstObject] title], testNote2.title);
    
    testPredicate = [NSPredicate predicateWithFormat:@"title CONTAINS 'testNote2'"];
    
    fetchedNotes = [[NoteStore sharedInstance] fetchNotesWithBatchSize:20 predicate:testPredicate andSortDescriptors:sortDescriptors];
    
    XCTAssertEqualObjects([[fetchedNotes firstObject] title], testNote2.title);
    
    testPredicate = [NSPredicate predicateWithFormat:@"body CONTAINS 'foo'"];
    
    fetchedNotes = [[NoteStore sharedInstance] fetchNotesWithBatchSize:20 predicate:testPredicate andSortDescriptors:sortDescriptors];

    XCTAssertNil([fetchedNotes firstObject]);
    
}

- (void)testAllNotesGetter
{
    Note *testNote3 = [[NoteStore sharedInstance] createNoteWithTitle:@"testNote3 title"];
    
    XCTAssertEqualObjects(testNote3, [[[NoteStore sharedInstance] allNotes] lastObject]);
    
    [[NoteStore sharedInstance] deleteNote:testNote3];
}



- (void)testDeleteNote
{

    [[NoteStore sharedInstance] createNoteWithBody:@"This is the body of a test note in the testDeleteNote method"];
    
    [[NoteStore sharedInstance] createNoteWithBody:@"This is the body of another test note in the testAllNotes method"];
    
    NSInteger countAfterCreation = [[[NoteStore sharedInstance] allNotes]count];
    
    Note *testNoteA = [[[NoteStore sharedInstance]allNotes]lastObject];
    Note *testNoteB = [[[NoteStore sharedInstance]allNotes]lastObject];
    
    XCTAssertEqualObjects(testNoteA, testNoteB);
    
    [[NoteStore sharedInstance] deleteNote:testNoteA];
    
    NSInteger countAfterDeletion = [[[NoteStore sharedInstance] allNotes]count];
    
    testNoteA = [[[NoteStore sharedInstance]allNotes]lastObject];
    
    XCTAssertNotEqualObjects(testNoteA, testNoteB);
    XCTAssertEqual(countAfterDeletion, countAfterCreation - 1);
    
    [[NoteStore sharedInstance] deleteNote:testNoteB];

}













@end
