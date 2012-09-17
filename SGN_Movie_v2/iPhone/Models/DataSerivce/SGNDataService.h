//
//  RepositoryService.h
//  SBJSon_Touch
//
//  Created by vnicon on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGNDataService : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (SGNDataService*) sharedInstance;
+ (NSManagedObjectContext*) defaultContext;
- (void) saveContext;

@end
