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

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, weak) id <AddNoteViewControllerDelegate> delegate;
@property (nonatomic, weak) Note *currentNote;

- (IBAction)cancelPressed:(id)sender;
- (IBAction)savePressed:(id)sender;

@end


@protocol AddNoteViewControllerDelegate

- (void)addNoteViewControllerDidSave;
- (void)addNoteViewControllerDidCancel:(Note *)noteToDelete;

@end