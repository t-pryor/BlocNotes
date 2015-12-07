//
//  NoteStore.h
//  BlocNotes
//
//  Created by Tim Pryor on 2015-06-18.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

@import CoreData;

#import <Foundation/Foundation.h>
#import "Note.h"
#define SHAREDSTORE [NoteStore sharedInstance];


@interface NoteStore : NSObject

@property (nonatomic, readonly) NSArray *allNotes;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedInstance;

- (Note *)createNote;

- (void)saveContext;

- (void)deleteNote:(Note *)note;

- (NSFetchRequest *)createInitialFetchRequest;

- (void)loadNotesFromInitialFetchIntoStore:(NSArray *)notes;

- (Note *)createNoteWithTitle:(NSString *)title;

- (Note *)createNoteWithTitle:(NSString *)title andURLString:(NSString *)urlString;

- (NSURL *)applicationDocumentsDirectory;

- (NSString *)sharedResourceFilePath;

@end
