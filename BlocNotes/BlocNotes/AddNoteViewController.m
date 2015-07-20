//
//  AddNoteViewController.m
//  BlocNotes
//
//  Created by Tim Pryor on 2015-07-07.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import "AddNoteViewController.h"

@interface AddNoteViewController ()

@end

@implementation AddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


- (IBAction)cancelPressed:(id)sender
{
    [self.delegate addNoteViewControllerDidCancel:self.currentNote];
}

- (IBAction)savePressed:(id)sender
{
    if ([self.bodyText.text isEqualToString:@""]) {
        self.bodyText.text = @"Tap to edit";
    }
    
    [self.currentNote setTitle:self.titleText.text];
    [self.currentNote setBody:self.bodyText.text];
    
    [self.delegate addNoteViewControllerDidSave];

}

@end
