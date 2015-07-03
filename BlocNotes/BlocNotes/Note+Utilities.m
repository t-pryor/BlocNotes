//
//  Note+Utilities.m
//  BlocNotes
//
//  Created by Tim Pryor on 2015-06-25.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import "Note+Utilities.h"
#import "NoteStore.h"

@implementation Note (Utilities)

+ (Note *)createNoteWithTitle: (NSString *)title
                      andBody: (NSString *)body
{
  
  
  Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                             inManagedObjectContext:[[NoteStore sharedInstance] context]];
  
  note.title = title;
  note.body = body;
  note.dateCreated = [NSDate timeIntervalSinceReferenceDate];

  return note;

}

//+ (Note *)retrieveNoteWithTitle: (NSString *)title
//{
//  [NSEntityDescription ]
//  
//}


/*
+ (Note *)editNoteWithTitle: (NSString *)oldTitle
               withNewTitle: (NSString *)newTitle
                 andNewBody: (NSString *)newBody
{
  
  
  
}
*/

@end
