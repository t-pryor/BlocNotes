//
//  Note.m
//  BlocNotes
//
//  Created by Tim Pryor on 2015-06-17.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import "Note.h"


@implementation Note

@dynamic body;
@dynamic dateModified;
@dynamic dateCreated;
@dynamic title;
@dynamic recentlyUpdated;

-(void) awakeFromInsert
{
  [super awakeFromInsert];
  
}


@end
