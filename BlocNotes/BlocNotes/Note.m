//
//  Note.m
//  BlocNotes
//
//  Created by Tim Pryor on 2015-07-07.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import "Note.h"


@implementation Note

@dynamic body;
@dynamic dateCreated;
@dynamic dateModified;
@dynamic recentlyUpdated;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    self.body = @"Tap to Edit";
}


@end
