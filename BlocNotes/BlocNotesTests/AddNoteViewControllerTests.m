//
//  AddNoteViewControllerTests.m
//  BlocNotes
//
//  Created by Tim Pryor on 2015-07-08.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AddNoteViewController.h"
#import <objc/message.h>
#import "NoteStore.h"


@interface AddNoteViewControllerTests : XCTestCase


@end

@implementation AddNoteViewControllerTests

{
    Note *n;
    AddNoteViewController *anvc;
    id sender;
    UITextView *tv;
    
}


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    anvc = [[AddNoteViewController alloc]init];
    n = (Note *) [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:[[NoteStore sharedInstance] managedObjectContext]];
    sender = [[UIBarButtonItem alloc]init];
    tv = [[UITextView alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    anvc = nil;
}

- (void)testViewControllerHasADelegateProperty
{
    objc_property_t delegateProperty = class_getProperty([anvc class], "delegate");
    XCTAssertTrue(delegateProperty != NULL, @"AddNoteViewController needs a delegate");
}

- (void)testViewControllerHasANoteProperty
{
    objc_property_t noteProperty = class_getProperty([anvc class], "currentNote");
    XCTAssertTrue(noteProperty != nil, @"AddNoteViewController needs a note object");
}

- (void)testThatAddNoteViewControllerBodyFieldNeverEmpty
{
    
    tv.text = @"";
    
    anvc.textView = tv;
    anvc.currentNote = n;
    
    [anvc savePressed:sender];
    XCTAssertTrue(anvc.currentNote.body.length > 0);
}

- (void)testThatCancelPressedPerformsNoChanges
{
    anvc.textView = tv;
    anvc.currentNote = n;
    [anvc cancelPressed:sender];
    
    
    
    
}



//- (void)testViewControllerSetsDelegate
//{
//    XCTAssertTrue(anvc.delegate != nil);
//    
//}





@end
