//
//  SearchResultsTableViewController.h
//  BlocNotes
//
//  Created by Tim Pryor on 2015-12-08.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchResultsTableViewController;

@protocol SearchResultsTableViewControllerDelegate <NSObject>

- (void)searchResultsTableViewControllerDone:(SearchResultsTableViewController *)srtvc;

@end

@interface SearchResultsTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *searchResults;

@property (weak, nonatomic) NSObject <SearchResultsTableViewControllerDelegate> *delegate;

@end
