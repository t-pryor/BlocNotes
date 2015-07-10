//
//  DetailViewControllerTests.m
//  BlocNotes
//
//  Created by Tim Pryor on 2015-07-09.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DetailViewController.h"
#import <objc/message.h>
#import "NoteStore.h"
#import "Note.h"

@interface DetailViewControllerTests : XCTestCase

@end

@implementation DetailViewControllerTests
{
    DetailViewController *dvc;
    Note *n;
    UITextView *tv;
    
}


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    dvc = [[DetailViewController alloc]init];
    n = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:[[NoteStore sharedInstance] managedObjectContext]];
    n.body = @"Body in setUp method";
    dvc.currentNote = n;
    tv = [[UITextView alloc]init];
    dvc.detailTextView = tv;
    
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    
    [[NoteStore sharedInstance] deleteNote:n];
}

- (void)testThatDetailViewControllerHasANoteProperty
{
    
    objc_property_t noteProperty = class_getProperty([dvc class], "currentNote");
    XCTAssertTrue(noteProperty != nil, @"AddNoteViewController needs a note object");
    
}

- (void)testThatEditsAreSaved
{
    dvc.detailTextView.text = dvc.currentNote.body;
    XCTAssertEqualObjects(dvc.currentNote.body, @"Body in setUp method");
    dvc.detailTextView.text = @"Body after edit";
    [dvc saveEdits];
    
    
    NSPredicate *p = [NSPredicate predicateWithFormat:@"body == 'Body after edit'"];
    
    NSArray *a = [[NoteStore sharedInstance] fetchNotesWithBatchSize:20 predicate:p andSortDescriptors:nil];
    
    n = a.firstObject;
    
    XCTAssertEqualObjects(n.body, @"Body after edit");
}

- (void)testThatDetailViewControllerAlwaysDisplaysTextEvenWithEmptyNote
{
    
}

- (void)testThatDetailViewControllerNoteCanBeEditedAndSaved
{
    
}

@end
