//
//  AddNoteViewController.m
//  BlocNotes
//
//  Created by Tim Pryor on 2015-07-07.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import "AddNoteViewController.h"
#import "NoteStore.h"
#import "ShareUtils.h"

@interface AddNoteViewController ()

@end

@implementation AddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navItem.title = @"New Note";
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                    target:self
                                    action:@selector(sharePressed:)];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                   target:self
                                   action:@selector(savePressed)];
   
    self.navItem.rightBarButtonItems = @[saveButton, shareButton];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                     target:self
                                     action:@selector(cancelPressed)];
    
    self.navItem.leftBarButtonItem = cancelButton;
    
    [self setupTitleText];
    [self setupBodyText];
}


- (void)setupTitleText
{
    self.titleText.textColor = [UIColor blueColor];
    self.titleText.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.titleText.text = @"Tap here to edit title";
}


- (void)setupBodyText
{
    self.bodyText.textAlignment = NSTextAlignmentLeft;
    self.bodyText.textColor = [UIColor blackColor];
    self.bodyText.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.bodyText.text = @"Tap here to add note details";
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)cancelPressed
{
    [self.delegate addNoteViewControllerDidCancel:self.currentNote];
}


- (void)savePressed
{
    if ([self.titleText.text isEqualToString: @"Tap here to edit title"]) {
        
        NSPredicate *p = [NSPredicate predicateWithFormat:@"title contains 'Untitled'"];
        NSArray *untitledNotes = [[NoteStore sharedInstance] searchResultsUsingPredicate:p];
        
        if ([untitledNotes count] > 0) {
            NSUInteger numberOfUntitledNotes = [untitledNotes count] + 1;
            [self.currentNote setTitle:[NSString stringWithFormat:@"Untitled Note (%lu)", (unsigned long)numberOfUntitledNotes]];
        } else {
            [self.currentNote setTitle:@"Untitled Note"];
        }
        
    } else {
        [self.currentNote setTitle:self.titleText.text];
    }
  
    [self.currentNote setBody:self.bodyText.text];
    [self.currentNote setUrlString:nil];
    [self.delegate addNoteViewControllerDidSave];
}


- (void)sharePressed:(id)sender
{
    UIActivityViewController *activityVC =
        [ShareUtils createActivityViewControllerWithTitle:self.titleText.text
                                                  andBody:self.bodyText.text];
    [self presentViewController:activityVC animated:YES completion:nil];
}





@end
