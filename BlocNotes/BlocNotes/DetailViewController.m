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
    
    self.title = @"Note Details";
    
    // iOS7 adds content offset automatically to scroll views (which text views inherit from)
    // set to NO on view controller to turn off behavior
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupTitleText];
    [self setupBodyText];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sharePressed:)];
    
    self.navigationItem.rightBarButtonItem = shareButton;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
    
    if (self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.navigationItem.leftBarButtonItem = doneButton;

    }
}
- (void)setupTitleText
{
    self.detailTitleTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.detailTitleTextView.text = self.currentNote.title;
    self.detailTitleTextView.textColor = [UIColor blueColor];
    
}

- (void)setupBodyText
{
    self.detailBodyTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.detailBodyTextView.text = self.currentNote.body;

    // like Evernote, if user did not enter text during
    // initial note creation, show placeholder text in light gray
    if ([self.detailBodyTextView.text isEqualToString:@"Tap to edit"]) {
        self.detailBodyTextView.textColor = [UIColor lightGrayColor];
    } else {
        self.detailBodyTextView.textColor = [UIColor blackColor];
    }
    
    self.detailBodyTextView.textAlignment = NSTextAlignmentLeft;
    
}


- (void)saveEdits
{
    if (![self.currentNote.body isEqualToString:self.detailBodyTextView.text] || ![self.currentNote.title isEqualToString:self.detailTitleTextView.text]) {
        
        self.currentNote.title = self.detailTitleTextView.text;
        self.currentNote.body = self.detailBodyTextView.text;
        self.currentNote.dateModified = [NSDate date];
        
    
        NSError *error = nil;
        NSManagedObjectContext *context = [[NoteStore sharedInstance]managedObjectContext];
        if (![context save:&error]) {
            NSLog(@"Error! %@", error);
        }
    }
}


- (void)sharePressed:(id)sender
{
    
    NSArray *objectsToShare = @[self.currentNote.title, self.currentNote.body];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
    UIPopoverPresentationController *pop = activityVC.popoverPresentationController;
    pop.barButtonItem = sender;
    
}

- (void)donePressed:(id)sender
{
    UITraitCollection *traitCollection_idiomPhone = [UITraitCollection traitCollectionWithUserInterfaceIdiom:UIUserInterfaceIdiomPhone];
    
    UITraitCollection *traitCollection_hCompact = [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassCompact];
    UITraitCollection *traitCollection_vRegular = [UITraitCollection traitCollectionWithVerticalSizeClass:UIUserInterfaceSizeClassRegular];
    
    
    NSArray *traitsArray = @[traitCollection_idiomPhone, traitCollection_hCompact, traitCollection_vRegular];
    
    UITraitCollection *traitCollection= [UITraitCollection traitCollectionWithTraitsFromCollections:traitsArray];
    
    [self.splitViewController setOverrideTraitCollection:traitCollection forChildViewController:self.splitViewController.viewControllers[0]];

    NSLog(@"----------- %@", [self.splitViewController.viewControllers[0] traitCollection]);

}

- (void)viewWillDisappear:(BOOL)animated
{
    // only commit edits if currentNote exists
    // currentNote won't exist after deleting note in master
    if (self.currentNote) [self saveEdits];
    
    UITraitCollection *traitCollection = [UITraitCollection traitCollectionWithUserInterfaceIdiom:UIUserInterfaceIdiomPhone];
    
    [self.navigationController.splitViewController setOverrideTraitCollection:traitCollection forChildViewController:self.splitViewController.viewControllers[0]];
    
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}



@end
