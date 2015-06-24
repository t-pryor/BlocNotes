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

@interface NoteStore : NSObject

@property (nonatomic, readonly) NSArray *allNotes;
@property (nonatomic, strong) NSManagedObjectContext *context;



+ (instancetype)sharedInstance;
- (Note *)createNote;
- (BOOL) saveChanges;
- (void) removeNote: (Note *)note;

- (NSFetchRequest *)createFetchRequest;


@end
