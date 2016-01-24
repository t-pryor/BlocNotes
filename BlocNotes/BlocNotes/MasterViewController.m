//
//  MasterViewController.m
//  BlocNotes
//
//  Created by Tim Pryor on 2015-06-15.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "NoteStore.h"
#import "Note.h"
#import "SearchResultsTableViewController.h"


@interface MasterViewController ()

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSFetchRequest *searchFetchRequest;
@property (strong, nonatomic) NSArray *filteredList;


typedef NS_ENUM(NSInteger, NoteSearchScope)
{
    searchScopeTitle = 0,
    searchScopeNote = 1,
    searchScopeEither = 2
};

@end


@implementation MasterViewController


- (void)awakeFromNib
{
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"All Notes";
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;

    
    self.searchController.searchBar.scopeButtonTitles = @[NSLocalizedString(@"In Title", @"Title"),
                                                          NSLocalizedString(@"In Note", @"Body"),
                                                          NSLocalizedString(@"In Either", @"Either")];
    
    self.searchController.searchBar.delegate = self;
    

    
    self.definesPresentationContext = YES;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        Note *currentNote;
        UINavigationController *nav = [segue destinationViewController];
        DetailViewController *dvc = (DetailViewController *)nav.topViewController;
       
        if ([self.searchController isActive]) {
            
            UITableViewCell *currentCell = [[UITableViewCell alloc] init];
            currentCell = (UITableViewCell *)sender;
            NSString *noteTitle = currentCell.textLabel.text;
            
            NSString *predicateString = [NSString stringWithFormat:@"title contains[cd] $A"];
            NSPredicate *p = [NSPredicate predicateWithFormat:predicateString];
            NSDictionary *sub = [NSDictionary dictionaryWithObject:noteTitle forKey:@"A"];
            p = [p predicateWithSubstitutionVariables:sub];
            
            NSArray *noteArray = [[NoteStore sharedInstance] searchResultsUsingPredicate:p];
            currentNote = (Note *)[noteArray firstObject];
            
        } else {
        
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            currentNote = (Note *)[[self fetchedResultsController] objectAtIndexPath: indexPath];
        
        }
        
        dvc.currentNote = currentNote;
        dvc.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        dvc.navigationItem.leftItemsSupplementBackButton = YES;
        
        dvc.detailBodyTextViewIsEditable = NO;
    }
    
    if ([[segue identifier] isEqualToString:@"addNote"]) {
        AddNoteViewController *anvc = (AddNoteViewController *)[segue destinationViewController];
        anvc.delegate = self;
        
        Note *newNote = [[NoteStore sharedInstance] createNoteWithTitle:@""];
        anvc.currentNote = newNote;
    }
}


#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return [[self.fetchedResultsController sections] count];
    } else {
        return 1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.searchController isActive]) {
        return [self.filteredList count];
    } else {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        return [sectionInfo numberOfObjects];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Note *note = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (self.searchController.active && ([self.filteredList count] > 0)) {
        
        note = [self.filteredList objectAtIndex:indexPath.row];
    
    } else {
        note = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    cell.textLabel.text = note.title;
    
    return cell;
    
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Note *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = note.title;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // replace deleted object's text with placeholder text
        
        UINavigationController *nav = [[self.splitViewController viewControllers] lastObject];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            DetailViewController *dvc = (DetailViewController *)[[nav viewControllers] firstObject];
            
            if ([self.tableView numberOfRowsInSection:0] > 1) {
                dvc.detailTitleTextView.text = @"";
                dvc.detailBodyTextView.text = @"Select a note";
            } else {
                dvc.detailTitleTextView.text = @"";
                dvc.detailBodyTextView.text = @"Please add a new note";
            }
            // delete current note
            dvc.currentNote = nil;
        }
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}





#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
  
    NSFetchRequest *fetchRequest = [[NoteStore sharedInstance] createInitialFetchRequest];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[NoteStore sharedInstance] managedObjectContext] sectionNameKeyPath:nil cacheName:@"masterVCCache"];
  
    self.fetchedResultsController.delegate = self;
  
    NSError *error = nil;
  
    if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
	}
    
    // take initial fetched objects and load into NoteStore
    [[NoteStore sharedInstance] loadNotesFromInitialFetchIntoStore:[self.fetchedResultsController fetchedObjects]];
    
    return _fetchedResultsController;
}    


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView
                                 cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
    [self.tableView reloadData];
}

- (NSFetchRequest *)searchFetchRequest
{
    if (_searchFetchRequest != nil) {
        return _searchFetchRequest;
    }
    
    _searchFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Note"
                                   inManagedObjectContext:[[NoteStore sharedInstance] managedObjectContext]];
    [_searchFetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [_searchFetchRequest setSortDescriptors:sortDescriptors];
    
    return _searchFetchRequest;
}



#pragma mark - AddNoteViewController Delegate Methods

- (void)addNoteViewControllerDidCancel:(Note *)noteToDelete
{
    NSManagedObjectContext *context = [[NoteStore sharedInstance] managedObjectContext];
    [context deleteObject:noteToDelete];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)addNoteViewControllerDidSave
{
    [[NoteStore sharedInstance] saveContext];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UISearchResultsUpdating Delegate methods

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    NSString *searchString = self.searchController.searchBar.text;
    [self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
    
    //NSString *searchString = searchController.searchBar.text;
    //[self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
    [self.tableView reloadData];

}


- (void)searchForText:(NSString *)searchText scope:(NoteSearchScope)scopeOption
{
    NSString *predString;
    
    if (scopeOption == searchScopeTitle) {
        predString = @"title contains[cd] $A";
    } else if (scopeOption == searchScopeNote) {
        predString = @"body contains[cd] $A";
    } else {
        predString = @"title contains[cd] $A OR body contains[cd] $A";
    }
    
    NSPredicate *p = [NSPredicate predicateWithFormat:predString];
    NSDictionary *sub = [NSDictionary dictionaryWithObject:searchText forKey:@"A"];
    p = [p predicateWithSubstitutionVariables:sub];
    
    self.filteredList = [[NoteStore sharedInstance] searchResultsUsingPredicate:p];
}


#pragma mark -UISearchBarDelegate

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}





@end
