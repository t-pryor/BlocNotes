//
//  DetailViewController.m
//  BlocNotes
//
//  Created by Tim Pryor on 2015-06-15.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import "DetailViewController.h"
#import "NoteStore.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.detailTextView.text = self.currentNote.body;
   
    // like Evernote, if user did not enter text during
    // initial note creation, show placeholder text in light gray
    if ([self.detailTextView.text isEqualToString:@"Tap to edit"]) {
        self.detailTextView.textColor = [UIColor lightGrayColor];
    }
}

- (void)saveEdits
{
    if (![self.currentNote.body isEqualToString:self.detailTextView.text]) {
        self.currentNote.body = self.detailTextView.text;
    
        NSError *error = nil;
        NSManagedObjectContext *context = [[NoteStore sharedInstance]managedObjectContext];
        if (![context save:&error]) {
            NSLog(@"Error! %@", error);
        }
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    // only commit edits if currentNote exists
    // currentNote won't exist after deleting note in master
    if (self.currentNote) [self saveEdits];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}



@end
