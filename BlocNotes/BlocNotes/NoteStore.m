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
@property (nonatomic, strong) NSManagedObjectContext *context;
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
    _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
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
    _context = [[NSManagedObjectContext alloc]init];
    _context.persistentStoreCoordinator = psc;
    
  }
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
  BOOL successful = [self.context save:&error];
  if (!successful) {
    NSLog(@"Error saving: %@", [error localizedDescription]);
  }
  return successful;
}

# pragma mark - Getters

- (NSArray *)privateNotes
{
  if (!_privateNotes) {
    _privateNotes = [[NSMutableArray alloc]init];
  }
  return _privateNotes;
}


- (Note *)createNote
{
  Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                             inManagedObjectContext:self.context];
  
  [self.privateNotes addObject:note];
  return note;
}


- (void)loadAllNotes
{
  if (!self.privateNotes) {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" // entity = table
                                              inManagedObjectContext:self.context]; //database layer
    fetchRequest.entity = entity;
    
    // do we want to set a predicate, like only recent notes? from book;
    // NSPredicate *p = [NSPredicate predicateWithFormat:@"valueInDollors > 50"];
    // [request setPredicate:p]
    //
    
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue"
                                                         ascending:YES];
    fetchRequest.sortDescriptors = @[sd];
    
    NSError *error;
    NSArray *notes = [self.context executeFetchRequest:fetchRequest error:&error];
    if (!notes) {
      [NSException raise:@"Fetch failed"
                  format:@"Reason: %@", [error localizedDescription]];
    }
    
    self.privateNotes = [[NSMutableArray alloc] initWithArray:notes];
    
  }
}

- (void)removeNote:(Note *)note
{
  [self.context deleteObject:note];
  [self.privateNotes removeObjectIdenticalTo:note]; //look in objcbook
  
}






@end
