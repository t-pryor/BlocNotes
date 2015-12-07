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
    Note *testNote3;
    Note *testNote4;
    
    NoteStore *testStore0;
    NoteStore *testStore1;
    NoteStore *testStore2;
}


- (void)setUp
{
    [super setUp];
    
    testNote1 = [[NoteStore sharedInstance] createNote];
    testNote2 = [[NoteStore sharedInstance] createNote];
    
    testNote3 = [[NoteStore sharedInstance] createNoteWithTitle:@"testNote3 title"];
    testNote4 = [[NoteStore sharedInstance] createNoteWithTitle:@"testNote4 title" andURLString:@"www.example.com/ex1"];
    
    testStore0 = [[NoteStore alloc]init];
    testStore1 = [NoteStore sharedInstance];
    testStore2 = [NoteStore sharedInstance];
}


- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [[NoteStore sharedInstance] deleteNote:testNote1];
    [[NoteStore sharedInstance] deleteNote:testNote2];
}


- (void)testInitReturnsNil
{
    // testStore0 uses NoteStore's init method, which should return nil
    // when using NoteStore, need to use singleton [NoteStore sharedInstance], which in turn calls its non-public initPrivate method
    XCTAssertNil(testStore0);
}


- (void)testNoteStoreSharedInstanceReturnsNoteStoreSingleton
{
    // testStore1 and testStore2 both call [NoteStore sharedInstance] singleton
    // they should both reference the same object
    XCTAssertEqualObjects(testStore1, testStore2);
}


- (void)testThatCreateNoteSuccessfullyCreatesNote
{
    XCTAssertEqualObjects([testNote1 class], [Note class]);
}


- (void)testCreateNoteWithTitleCreatesNote
{
    XCTAssertEqualObjects([testNote3 class], [Note class]);
}

- (void)testCreateNoteWithTitleAndURLStringCreatesNote
{
    XCTAssertEqualObjects([testNote4 class], [Note class]);
}

- (void)testAllNotesGetter
{
    // create a new testNote, which should be added as the last item in the public allNotes array
    Note *testNote5 = [[NoteStore sharedInstance] createNoteWithTitle:@"testNote5 title"];
    XCTAssertEqualObjects(testNote5, [[[NoteStore sharedInstance] allNotes] lastObject]);
    [[NoteStore sharedInstance] deleteNote:testNote5];
}


- (void)testDeleteNote
{
    NSInteger countBeforeCreation = [[[NoteStore sharedInstance] allNotes] count];

    // this will add two notes to the NoteStore's privateNotes array (a copy of which is returned by the allNotes method)
    [[NoteStore sharedInstance] createNoteWithTitle:@"Note A"];
    [[NoteStore sharedInstance] createNoteWithTitle:@"Note B"];
    
    NSInteger countAfterCreation = [[[NoteStore sharedInstance] allNotes] count];
    
    // verify that these two notes were added to the privateNotes array
    XCTAssertEqual(countBeforeCreation, countAfterCreation-2);
    
    // testNoteY and testNoteZ are both references to the same object: the last object in the Array
    // this last object would be a note with title @"Note B"
    Note *testNoteY = [[[NoteStore sharedInstance] allNotes] lastObject];
    Note *testNoteZ = [[[NoteStore sharedInstance] allNotes] lastObject];
    
    // Both testNotes have the same title
    XCTAssertTrue([testNoteY.title isEqualToString:@"Note B"]);
    XCTAssertTrue([testNoteZ.title isEqualToString:@"Note B"]);
    // Both testNotes point to the same Note object
    XCTAssertEqualObjects(testNoteY, testNoteZ);
    
    // This will delete the last element of the testNotes array
    // The last element now points to a note with the title @"Note A"
    [[NoteStore sharedInstance] deleteNote:testNoteY];
    
    NSInteger countAfterDeletion = [[[NoteStore sharedInstance] allNotes]count];
    // Verify that the last element in allNotes was deleted
    XCTAssertEqual(countAfterDeletion, countAfterCreation - 1);
    
    // testNoteY now points to the last object, which should have title @"Note A"
    testNoteY = [[[NoteStore sharedInstance]allNotes]lastObject];
    XCTAssertTrue([testNoteY.title isEqualToString:@"Note A"]);

    // therefore, the Note with title "Note B" was removed from the privateNotes array
    
    // testNoteZ still points to the Note with title @"Note B"
    XCTAssertTrue([testNoteZ.title isEqualToString:@"Note B"]);
    
    // verify these point to different Note objects
    XCTAssertNotEqualObjects(testNoteY, testNoteZ);
}

- (void)testContainerURL
{
    // if this returns non-nil value then app group and entitlement settings are setup correctly
    XCTAssertNotNil([[NoteStore sharedInstance] applicationDocumentsDirectory]);
}


- (void)testSharedResourceFilePathReturnedFromNoteStore
{
    XCTAssertNotNil([[NoteStore sharedInstance] sharedResourceFilePath]);
}












@end
