//
//  AddNoteViewController.m
//  BlocNotes
//
//  Created by Tim Pryor on 2015-07-07.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import "AddNoteViewController.h"
#import "NoteStore.h"

@interface AddNoteViewController ()

@end

@implementation AddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navItem.title = @"New Note";
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sharePressed:)];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed)];
   
   
    self.navItem.rightBarButtonItems = @[saveButton, shareButton];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
    
    self.navItem.leftBarButtonItem = cancelButton;
    
    
    [self setupTitleText];
    [self setupBodyText];
    
}


- (void)setupTitleText
{
    self.titleText.textColor = [UIColor blueColor];
    self.titleText.text = @"Untitled Note";
    self.titleText.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
}


- (void)setupBodyText
{
    self.bodyText.textColor = [UIColor blackColor];
    self.bodyText.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
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
    if ([self.bodyText.text isEqualToString:@""]) {
        self.bodyText.text = @"Tap to edit";
    //    [NSThread sleepForTimeInterval:2.6];
    }
    
    [self.currentNote setTitle:self.titleText.text];
    [self.currentNote setBody:self.bodyText.text];
    
    [self.delegate addNoteViewControllerDidSave];
}


- (void)sharePressed:(id)sender
{
    
    NSArray *objectsToShare = @[self.titleText.text, self.bodyText.text];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
    UIPopoverPresentationController *pop = activityVC.popoverPresentationController;
    pop.barButtonItem = sender;
    
}




@end
