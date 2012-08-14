//
//  CinemaRepository.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Repository.h"
#import "AFNetworking.h"
#import "DataService.h"

#define API_CINEMA_UPDATE @"http://sgnm-server.apphb.com/cinema/list"

@implementation Repository

+ (Repository *) sharedInstance
{
    static Repository *sharedRepository;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRepository = [[Repository alloc] init];
        
    });
    return sharedRepository;
}

- (void) updateEntity:(NSEntityDescription*)entity withUrlString:(NSString*)urlString
{
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [self deleteAllObjectWithEntity:entity];
                                                                                            [self insertObjects:(NSArray*)[JSON objectForKey:@"Data"] 
                                                                                                    withEntity:entity];
                                                                                        } 
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Request Failed with Error: %@, %@", error, [error userInfo]);
                                                                                        }
                                         ];
    [operation start];
}

- (void)deleteAllObjectWithEntity:(NSEntityDescription*)entity
{
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) 
    {
        [context deleteObject:managedObject];
    }
    [[DataService sharedInstance] saveContext];
}

- (void)insertObjects:(NSArray*)JSON withEntity:(NSEntityDescription*)entity
{
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    for(NSDictionary *dict in JSON)
    {
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entity.name 
                                                                inManagedObjectContext:context];
        [object setValuesForKeysWithDictionary:dict];
        [object setValue:@"abc" forKey:@"entityKey"];
    }
    [[DataService sharedInstance] saveContext];
}

- (NSArray*)selectObjectsWithEntity:(NSEntityDescription*)entity andPredicateOrNil:(NSPredicate*)predicate
{
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    if(predicate != nil)
        [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    return items;
}

@end
