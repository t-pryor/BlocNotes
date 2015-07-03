//
//  Note+Utilities.h
//  BlocNotes
//
//  Created by Tim Pryor on 2015-06-25.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import "Note.h"

@interface Note (Utilities)

+ (Note *)createNoteWithTitle: (NSString *)title
                      andBody: (NSString *)body;


+ (Note *)retrieveNoteWithTitle: (NSString *)title;





+ (Note *)editNoteWithTitle: (NSString *)oldTitle
               withNewTitle: (NSString *)newTitle
                 andNewBody: (NSString *)newBody;





@end
