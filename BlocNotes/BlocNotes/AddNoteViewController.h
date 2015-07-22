//
//  AddNoteViewController.h
//  BlocNotes
//
//  Created by Tim Pryor on 2015-07-07.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@protocol AddNoteViewControllerDelegate;

@interface AddNoteViewController : UIViewController

/**
 Represents the new note being created.
 Once user fills in note info, this information will be passed to the currentNote's body property
 */
@property (nonatomic, weak) Note *currentNote;




@property (weak, nonatomic) IBOutlet UITextView *titleText;



/**
 This stores the text being entered by the user.
 This info passed to currentNote.body when save is entered.
 */

@property (weak, nonatomic) IBOutlet UITextView *bodyText;



/**
 The Master VC is the delegate and performs a model segue when the user wants to create a new note.
 */
@property (nonatomic, weak) id <AddNoteViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

/**
 This calls the delegate's addNoteViewControllerDidCancel: method when the cancel button is pressed
 */
- (void)cancelPressed;


/**
 This calls the delegate's addNoteViewControllerDidSave: method when the save button is pressed
 */
- (void)savePressed;

@end


/**
 This protocol is instituted by the Master VC to handle when the user presses save and cance.
 */
@protocol AddNoteViewControllerDelegate

- (void)addNoteViewControllerDidSave;
- (void)addNoteViewControllerDidCancel:(Note *)noteToDelete;

@end