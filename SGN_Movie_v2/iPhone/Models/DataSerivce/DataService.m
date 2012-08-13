//
//  RepositoryService.m
//  SBJSon_Touch
//
//  Created by vnicon on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataService.h"
#import <CoreData/CoreData.h>

@implementation DataService
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Util
+ (DataService *) sharedInstance
{
    static DataService *sharedRepository;
    static dispatch_once_t onceToken;
      dispatch_once(&onceToken, ^{
            sharedRepository = [[DataService alloc] init];
        
    });
    return sharedRepository;
}

+ (NSManagedObjectContext *) defaultContext
{
    @synchronized (self)
    {
        return [[DataService sharedInstance] managedObjectContext];
    }
}

- (void) saveContext
{
    NSError *error = nil;
   
    if(_managedObjectContext != nil)
    {
        if([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
            abort();
        }
    }
}

-(BOOL) updateDatabase
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CINEMA" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError * error;
    NSArray *fetchObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
       
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YYYY"];

    NSString *lastModifyDateString = [dateFormatter stringFromDate:[[fetchObjects objectAtIndex:0] valueForKey:@"lastModify"]];
    NSLog(@"LAST MODIFY: %@",lastModifyDateString);
    
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];

    NSLog(@"CURRENT DATE: %@",currentDate);
    
    if(lastModifyDateString==currentDate)
        return FALSE;
    return TRUE;    
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    if (_persistentStoreCoordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    }
    return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
//    if (_managedObjectModel != nil)
//    {
//        return _managedObjectModel;
//    }
//    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
//    return _managedObjectModel;
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SGN_Movie" 
                                              withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *url = [[AppDelegate currentDelegate] applicationDocumentsDirectory];
    NSURL *storeURL = [url URLByAppendingPathComponent:@"SGN_Movie.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[storeURL path]])
    {
        NSURL *defaultURL = [[NSBundle mainBundle] URLForResource:@"SGN_Movie" 
                                                    withExtension:@"sqlite"];
        if(defaultURL)
        {
            [fileManager copyItemAtURL:defaultURL toURL:storeURL error:nil];
        }
    }
    
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
           // Update to handle the error appropriately.
           NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
           exit(-1);  // Fail
       }    
    return _persistentStoreCoordinator;
}

@end
