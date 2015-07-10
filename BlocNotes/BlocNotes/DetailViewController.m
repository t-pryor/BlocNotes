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
    
}

- (void)saveEdits
{
    if (self.currentNote.body != self.detailTextView.text) {
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
    [self saveEdits];
}



- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}



@end
