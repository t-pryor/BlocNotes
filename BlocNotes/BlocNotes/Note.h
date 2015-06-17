//
//  Note.h
//  BlocNotes
//
//  Created by Tim Pryor on 2015-06-17.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic) NSTimeInterval dateModified;
@property (nonatomic) NSTimeInterval dateCreated;
@property (nonatomic, retain) NSString * title;
@property (nonatomic) BOOL recentlyUpdated;

@end
