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
@property (nonatomic, strong) NSManagedObjectContext *context;



+ (instancetype)sharedInstance;
- (Note *)createNote;
- (BOOL) saveChanges;
- (void) deleteNote: (Note *)note;
- (void) deleteNoteWithTitle: (NSString *) title;

- (NSFetchRequest *)createFetchRequest;


- (void)loadAllNotes;


- (Note *)createNoteWithTitle:(NSString *)title
                      andBody:(NSString *)body;

- (Note *)fetchNoteWithTitle:(NSString *)title;

- (Note *)editNoteWithTitle:(NSString *)title
                   withNewBody:(NSString *)body;




@end
