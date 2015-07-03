//
//  NoteTests.m
//  BlocNotes
//
//  Created by Tim Pryor on 2015-06-17.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Note.h"
#import "Note+Utilities.h"
#import "NoteStore.h"

@interface NoteTests : XCTestCase

@end

@implementation NoteTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
  
  


}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testThatNoteIsCreatedCorrectly
{

  Note *testNote = [Note createNoteWithTitle:@"test title 1" andBody:@"this is just a test body 1"];

  XCTAssertEqualObjects(testNote.title, @"test title 1");
  XCTAssertEqualObjects(testNote.body , @"this is just a test body 1");
  XCTAssertTrue(testNote.dateCreated);

}


//- (void)testRetrieveNoteWithTitle
//{
//  
//  Note *testNote = [Note createNoteWithTitle:@"test title 2" andBody:@"this is just a test body 2"];
//
//  [[NoteStore sharedInstance] saveChanges];
//  
//  
//  Note *retrievedTestNote = [Note retrieveNoteWithTitle:@"test title 2"];
//  
//  XCTAssertEqualObjects(retrievedTestNote.title, @"test title 2");
//  
//  
//  
//}

/*
- (void)testThatNoteCanBeModifiedCorrectly
{
  
  Note *testNote = [Note editNoteWithTitle:@"test title 2" andBody:@"this is just a test body 2"];
  
  

}

*/







@end
