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
#import "AppDelegate.h"

@implementation Repository

@synthesize delegate = _delegate;
@synthesize loadingWheel = _loadingWheel;

#pragma mark - Util

+ (Repository *) sharedInstance
{
    static Repository *sharedRepository;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRepository = [[Repository alloc] init];
    });
    return sharedRepository;
}

//auto get data base on Url
- (void) updateEntity:(NSEntityDescription*)entity predicate:(NSPredicate*)predicate urlString:(NSString*)urlString
{
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [self SGNRepositoryStartUpdate:self];
                                                                                            [self deleteDataInEntity:entity 
                                                                                                                  predicate:predicate];
                                                                                            [self insertData:(NSArray*)[JSON objectForKey:@"Data"] 
                                                                                                     InEntity:entity];
                                                                                            [self SGNRepositoryFinishUpdate:self];
                                                                                        } 
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Request Failed with Error: %@, %@", error, [error userInfo]);
                                                                                        }
                                         ];
    [operation start];
}

#pragma mark Self Delegate

//raise before update new data 
- (void)SGNRepositoryStartUpdate:(Repository*)repository
{
    [_loadingWheel removeFromSuperview];
	[self setLoadingWheel:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]];
	[_loadingWheel setHidesWhenStopped:YES];
    UIView *superView = [(UIViewController*)_delegate view];
    _loadingWheel.center = superView.center;
	[superView addSubview:_loadingWheel];
	[_loadingWheel startAnimating];
    if(_delegate != nil && [_delegate respondsToSelector:@selector(SGNRepositoryStartUpdate:)])
    {
        [_delegate SGNRepositoryStartUpdate:repository];
    }
}

//raise after update new data
- (void)SGNRepositoryFinishUpdate:(Repository*)repository
{
    [_loadingWheel stopAnimating];
    [_loadingWheel removeFromSuperview];
    [[DataService sharedInstance] saveContext];
    if(_delegate != nil && [_delegate respondsToSelector:@selector(SGNRepositoryFinishUpdate:)])
    {
        [_delegate SGNRepositoryFinishUpdate:repository];
    }
}

#pragma mark Database Query

//delete 
- (void)deleteDataInEntity:(NSEntityDescription*)entity predicate:(NSPredicate*)predicate
{
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *managedObject in items) 
    {
        [context deleteObject:managedObject];
    }
   // NSLog(@"DONE DELETE");
}

- (void)insertData:(NSArray*)JSON InEntity:(NSEntityDescription*)entity
{
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    for(NSDictionary *dict in JSON)
    {
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:[entity name] 
                                                                inManagedObjectContext:context];
        [object setValuesForKeysWithDictionary:dict];
    }
   // NSLog(@"DONE INSERT");
}

- (NSArray*)selectDataInEntity:(NSEntityDescription*)entity predicate:(NSPredicate*)predicate sortDescriptor:(NSArray*)sortDescriptors
{
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    if(predicate != nil)
        [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
   // NSLog(@"DONE SELECT");
    return items;
}

@end
