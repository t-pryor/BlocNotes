//
//  MasterViewController.h
//  BlocNotes
//
//  Created by Tim Pryor on 2015-06-15.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AddNoteViewController.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, AddNoteViewControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>


/**
 Manages communication between the Note Store and the table view.
 Moved fetch initialization information to the Note Store.
 This is accessed through the Note Store singleton createInitialFetchRequest method.
 The managed object context was also moved to the NoteStore and this is accessed through its getter method.
 */
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;



@end 
