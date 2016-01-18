//
//  NoteStore.m
//  BlocNotes
//
//  Created by Tim Pryor on 2015-06-18.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import "NoteStore.h"
#import "Note.h"
#import "BlocNotes-Swift.h"

@interface NoteStore ()

@property (readonly, nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@property (nonatomic) NSMutableArray *privateNotes;
@property (nonatomic, strong) dispatch_queue_t concurrentNoteQueue;
//@property (nonatomic, strong) ICloudSupport *ics;

@end


@implementation NoteStore

+ (instancetype)sharedInstance
{
    static NoteStore *sharedNoteStore = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedNoteStore = [[self alloc] initPrivate];
        sharedNoteStore->_privateNotes = [[NSMutableArray alloc] init];
        sharedNoteStore ->_concurrentNoteQueue = dispatch_queue_create("io.bloc.BlocNotes.noteQueue", DISPATCH_QUEUE_CONCURRENT);
    });

    return sharedNoteStore;
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
    __block NSArray *array;
    
    // need to perform synchronously because need to return the array after dispatch
    dispatch_sync(self.concurrentNoteQueue, ^{
        array = [self.privateNotes copy];
    });
    
    return array;
}


- (NSString *)notePath
{
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    // Get one and only document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];

    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

#warning eliminate unecessary methods to create notes

- (Note *)createNote
{
    Note *note = [NSEntityDescription
                  insertNewObjectForEntityForName:@"Note"
                  inManagedObjectContext: self.managedObjectContext];
    
    note.dateCreated = [NSDate date];
    note.dateModified = note.dateCreated;
    note.urlString = nil;
    
    dispatch_barrier_async(self.concurrentNoteQueue, ^{
        [self.privateNotes addObject:note];
    });
    
    return note;
}


-(Note *)createNoteWithTitle:(NSString *)title
{
    Note *note = (Note *)[NSEntityDescription
                          insertNewObjectForEntityForName:@"Note"
                          inManagedObjectContext:self.managedObjectContext];
    
    note.title = title;
    note.dateCreated = [NSDate date];
    note.dateModified = note.dateCreated;
    note.urlString = nil;
    
    dispatch_barrier_async(self.concurrentNoteQueue, ^{
        [self.privateNotes addObject:note];
    });
    
    return note;
}


-(Note *)createNoteWithTitle:(NSString *)title andURLString:(NSString *)urlString
{
    Note *note = (Note *)[NSEntityDescription
                          insertNewObjectForEntityForName:@"Note"
                          inManagedObjectContext:self.managedObjectContext];
    
    note.title = title;
    note.dateCreated = [NSDate date];
    note.dateModified = note.dateCreated;
    note.urlString = urlString;
    
    return note;
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
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateModified" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    return fetchRequest;
}


- (NSArray *)searchResultsUsingPredicate:(NSPredicate *)predicate
{
    //function should return an array back to filteredList in MasterVC
    
    NSArray *searchResults;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    searchResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return searchResults;
}


- (void)loadNotesFromInitialFetchIntoStore:(NSArray *)notes
{
    __block NSMutableArray *array;
 
    dispatch_sync(self.concurrentNoteQueue, ^{
        array = [notes mutableCopy];
    });
    
    self.privateNotes = array;
}


#pragma mark - Core Data stack


// The following code is Apple boilerplate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    self.modelURL = [[NSBundle mainBundle] URLForResource:@"BlocNotes" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator { //
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    self.storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BlocNotes.sqlite"];
    
    
    
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    NSDictionary *storeOptions = @{NSPersistentStoreUbiquitousContentNameKey: @"BlocNotesStore"};
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeURL options:storeOptions error:&error]) {
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

    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
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


#pragma mark - App Extension Sharing

- (NSURL *)applicationDocumentsDirectory
{
    return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.biz.blocnote"];
}


- (NSString *)sharedResourceFilePath
{
    NSString *dirPath = self.applicationDocumentsDirectory.path;
    NSString *filePath = [dirPath stringByAppendingPathComponent: @"datafile.dat"];
    
    return filePath;
}

@end
