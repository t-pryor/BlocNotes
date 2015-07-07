//
//  NoteStore.m
//  BlocNotes
//
//  Created by Tim Pryor on 2015-06-18.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import "NoteStore.h"
#import "Note.h"



@interface NoteStore ()

@property (nonatomic) NSMutableArray *privateNotes;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end



@implementation NoteStore

+ (instancetype)sharedInstance
{
  static dispatch_once_t onceToken;
  
  static id sharedInstance;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] initPrivate];
  });
  
  return sharedInstance;
}


- (instancetype)init
{
  NSException *ex = [NSException exceptionWithName:@"Singleton"
                          reason:@"Use +[NoteStore sharedInstance]"
                        userInfo:nil];
  
  NSLog(@"Exception: %@", ex);
  return nil;
}


- (instancetype)initPrivate
{
  self = [super init];
  if (self) {
    // Read in xcdatamodeld
    self.model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSLog(@"******* NSEntityDescription: %@", [self.model entities] );
    
    NSPersistentStoreCoordinator *psc =
    [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    
    // Where does the SQLite file go?
    NSString *path = [self notePath];
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    
    NSError *error;
    
    if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                           configuration:nil
                                     URL:storeURL
                                 options:nil
                                   error:&error]) {
      
      [NSException raise:@"Open Failurez"
                  format:@"%@",[error localizedDescription]];
    }
    
    // Create the managed object context
    //_context = [[NSManagedObjectContext alloc]init];
    self.context.persistentStoreCoordinator = psc;
    NSLog(@" ");
  }
  return self;
}

- (NSManagedObjectContext *)context
{
  if (!_context) {
    _context = [[NSManagedObjectContext alloc]init];
    
  }
  return _context;
}

- (NSArray *)allNotes
{
  return [self.privateNotes copy];
}


- (NSString *)notePath
{
  NSArray *documentDirectories =
  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  
  // Get one and only document directory from that list
  NSString *documentDirectory = [documentDirectories firstObject];
  
  return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}


- (BOOL)saveChanges //should call when moving to background
{
  NSError *error;
  BOOL successful = [self.context save:&error];
  if (!successful) {
    NSLog(@"Error saving: %@", [error localizedDescription]);
  }
  return successful;
}


- (Note *)createNote
{
  Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                             inManagedObjectContext:self.context];
  
  [self.privateNotes addObject:note];
  return note;
}

- (Note *)createNoteWithBody:(NSString *)body
{
    Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                               inManagedObjectContext:self.context];
    note.body = body;
    note.dateCreated = [NSDate timeIntervalSinceReferenceDate];
    [self.privateNotes addObject:note];
    
    return note;
}

- (NSArray *)fetchNotesWithBatchSize:(NSUInteger)batchSize predicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)sortDescriptors
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    
    [fetchRequest setFetchBatchSize:batchSize];
    
    // Specify criteria for filtering which objects to fetch
    [fetchRequest setPredicate:predicate];
    
    // Specify how the fetched objects should be sorted
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Problem! %@", error);
    }
    
    return fetchedObjects;

}

- (void)loadAllNotes
{
  if (!self.privateNotes) {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" // entity = table
                                              inManagedObjectContext:self.context]; //database layer
    fetchRequest.entity = entity;
  
    NSError *error;
    NSArray *notes = [self.context executeFetchRequest:fetchRequest error:&error];
  
    if (!notes) {
      [NSException raise:@"Fetch failed"
                  format:@"Reason: %@", [error localizedDescription]];
    }
    
    self.privateNotes = [[NSMutableArray alloc] initWithArray:notes];
  }
}


- (void)deleteNote:(Note *)note
{
  [self.context deleteObject:note];
  [self.privateNotes removeObjectIdenticalTo:note]; //look in objcbook
  note = nil;
  
}


- (NSFetchRequest *)createFetchRequest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateModified" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    return fetchRequest;
    
}




@end
