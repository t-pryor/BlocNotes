//
//  DetailViewController.h
//  BlocNotes
//
//  Created by Tim Pryor on 2015-06-15.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNoteViewController.h"
#import "Note.h"

@interface DetailViewController : UIViewController <UIWebViewDelegate, UIGestureRecognizerDelegate, UITextViewDelegate>

// not used except in app delegate
@property (strong, nonatomic) id detailItem;


/**
 The Note that represents the currently selected note in the Master VC
 If a Note is deleted, this property is set to nil in MasterVC.
 This prevents an attempt to save edits on a non-existing note when on an iPad,
 because the Detail VC is always being presented.
 */
@property (nonatomic, weak) Note *currentNote;


@property (weak, nonatomic) IBOutlet UITextView *detailTitleTextView;



/**
 The UITextView used to store note information
 The Detail VC's associated Note's body property supplies this information
 */
//@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UITextView *detailBodyTextView;


@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;


@property BOOL detailBodyTextViewIsEditable;

/**
 Saves the changes (if any) to Note information/
 
 This is called in viewWillDisappear, which is called when a user clicks on a Master Table View item on iPad
 or when the user clicks on the back button on iPhone.
 */
- (void)saveEdits;





@end

