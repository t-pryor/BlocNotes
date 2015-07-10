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
    if ([self.textView.text isEqualToString:@""]) {
        self.textView.textColor = [UIColor grayColor];
        self.textView.text = @"Tap to edit";
    }
    
    [self.currentNote setBody:self.textView.text];
    [self.delegate addNoteViewControllerDidSave];

}

@end
