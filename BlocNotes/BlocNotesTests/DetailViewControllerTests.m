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
    UITextView *btv;
    UITextView *ttv;
    
}


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    dvc = [[DetailViewController alloc]init];
    n = [[NoteStore sharedInstance] createNote];
    n.body = @"Body in setUp method";
    n.title = @"Title in setUp method";
    dvc.currentNote = n;
    btv = [[UITextView alloc]init];
    dvc.detailBodyTextView = btv;
    ttv = [[UITextView alloc] init];
    dvc.detailTitleTextView = ttv;
    
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

- (void)testThatBodyEditsAreSaved
{
    dvc.detailBodyTextView.text = dvc.currentNote.body;
    XCTAssertEqualObjects(dvc.currentNote.body, @"Body in setUp method");
    dvc.detailBodyTextView.text = @"Body after edit";
    [dvc saveEdits];
    
    
    NSPredicate *p = [NSPredicate predicateWithFormat:@"body == 'Body after edit'"];
    
    NSArray *a = [[NoteStore sharedInstance] fetchNotesWithBatchSize:20 predicate:p andSortDescriptors:nil];
    
    n = a.firstObject;
    
    XCTAssertEqualObjects(n.body, @"Body after edit");
    
}

- (void)testThatTitleEditsAreSaved
{
    dvc.detailTitleTextView.text = dvc.currentNote.title;
    XCTAssertEqualObjects(dvc.currentNote.title, @"Title in setUp method");
    dvc.detailTitleTextView.text = @"Title after edit";
    [dvc saveEdits];
    
    NSPredicate *p = [NSPredicate predicateWithFormat:@"title == 'Title after edit'"];
    
    NSArray *a = [[NoteStore sharedInstance] fetchNotesWithBatchSize:20 predicate:p andSortDescriptors:nil];
    
    n = a.firstObject;
    
    XCTAssertEqualObjects(n.title, @"Title after edit");
    
    
}

- (void)testThatDateModifiedIsSaved
{
    dvc.detailTitleTextView.text = dvc.currentNote.title;
    
    XCTAssertEqualObjects(dvc.currentNote.title, @"Title in setUp method");
    dvc.detailTitleTextView.text = @"zzzzzTitle after edit in date modified test methodz";
    NSDate *date = [NSDate date];
    
    [dvc saveEdits];
    
    NSPredicate *p = [NSPredicate predicateWithFormat:@"title == 'zzzzzTitle after edit in date modified test methodz'"];
    
    NSArray *a = [[NoteStore sharedInstance] fetchNotesWithBatchSize:20 predicate:p andSortDescriptors:nil];
    
    n = a.firstObject;

    NSDate *modifiedDate = n.dateModified;
    
    [[NoteStore sharedInstance] deleteNote:n];
    
    XCTAssertTrue([date laterDate:modifiedDate] == modifiedDate);
    
    NSDate *d = [date laterDate:modifiedDate];
    
    
}


- (void)testThatOnlyDVCsWithAssociatedNotesSaveEdits
{
    dvc.currentNote = nil;
    
    [dvc saveEdits];
    
    
    
}





@end
