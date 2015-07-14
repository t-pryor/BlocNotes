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

@interface DetailViewController : UIViewController


@property (strong, nonatomic) id detailItem;


@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (nonatomic, weak) Note *currentNote;




- (void)saveEdits;



@end

