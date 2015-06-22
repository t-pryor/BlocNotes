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

+ (instancetype)sharedInstance;

- (Note *)createNote;

@end
