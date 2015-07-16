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
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


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
  
  return self;
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
  BOOL successful = [self.managedObjectContext save:&error];
  if (!successful) {
    NSLog(@"Error saving: %@", [error localizedDescription]);
  }
  return successful;
}


- (Note *)createNote
{
    Note *note = [NSEntityDescription
                  insertNewObjectForEntityForName:@"Note"
                  inManagedObjectContext:self.managedObjectContext];
    
    [self.privateNotes addObject:note];
    return note;
}

- (Note *)createNoteWithBody:(NSString *)body
{
    Note *note = (Note *)[NSEntityDescription
                          insertNewObjectForEntityForName:@"Note"
                          inManagedObjectContext:self.managedObjectContext];
    note.body = body;
    note.dateCreated = [NSDate date];
    [self.privateNotes addObject:note];
    
    return note;
}

-(Note *)createNoteWithTitle:(NSString *)title
{
    Note *note = (Note *)[NSEntityDescription
                          insertNewObjectForEntityForName:@"Note"
                          inManagedObjectContext:self.managedObjectContext];
    
    note.title = title;
    note.dateCreated = [NSDate date];
    [self.privateNotes addObject:note];
    
    return note;
}

- (NSArray *)fetchNotesWithBatchSize:(NSUInteger)batchSize predicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)sortDescriptors
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    [fetchRequest setFetchBatchSize:batchSize];
    
    // Specify criteria for filtering which objects to fetch
    [fetchRequest setPredicate:predicate];
    
    // Specify how the fetched objects should be sorted
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Problem! %@", error);
    }
    
    return fetchedObjects;

}

- (void)deleteNote:(Note *)note
{
    [self.managedObjectContext deleteObject:note];
    [self.privateNotes removeObjectIdenticalTo:note];
    note = nil;
  
}

- (NSFetchRequest *)createInitialFetchRequest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    return fetchRequest;
}


- (void)loadNotesFromInitialFetchIntoStore:(NSArray *)notes
{
    self.privateNotes = [[NSMutableArray alloc] initWithArray:notes];
    
}



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "io.medux.BlocNotes" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BlocNotes" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BlocNotes.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}



#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}




@end
