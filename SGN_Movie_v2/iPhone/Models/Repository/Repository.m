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

- (void) updateEntitywithUrlString:(NSString*)urlString
{
    urlString = [urlString stringByAppendingFormat:@"=%@",[self ReadLastUpdated]];
    NSLog(@"URL - Get All: %@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [self SGNRepositoryStartUpdate:self];
                                                                                                                                                        
                                                                                            [self CheckNeedToUpdateFromJSON:JSON];                                                                                                       
                                                                                            
                                                                                            [self SGNRepositoryFinishUpdate:self];
                                                                                        } 
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Request Failed with Error: %@, %@", error, [error userInfo]);
                                                                                        }
                                         ];
    [operation start];
}

#pragma mark Delegate

- (void)SGNRepositoryStartUpdate:(Repository*)repository
{
    [_loadingWheel removeFromSuperview];
	[self setLoadingWheel:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]];
	_loadingWheel.hidesWhenStopped=YES;
    UIView *superView = [(UIViewController*)_delegate view];
    _loadingWheel.center = superView.center;
	[superView addSubview:_loadingWheel];
	[_loadingWheel startAnimating];
    if(_delegate != nil && [_delegate respondsToSelector:@selector(SGNRepositoryStartUpdate:)])
    {
        [_delegate SGNRepositoryStartUpdate:repository];
    }
}

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

#pragma mark Delete from Database

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
   // NSLog(@"DONE DELETE");
}

#pragma mark Insert into Database
- (void)insertObjects:(NSArray*)JSON withEntity:(NSEntityDescription*)entity
{
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    for(NSDictionary *dict in JSON)
    {
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entity.name 
                                                                inManagedObjectContext:context];
        [object setValuesForKeysWithDictionary:dict];
    }
   // NSLog(@"DONE INSERT");
}

#pragma mark Query from Database

- (NSArray*)selectObjectsWithEntity:(NSEntityDescription*)entity predicate:(NSPredicate*)predicate sortDescriptor:(NSArray*)sortDescriptors
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

#pragma mark Check  need to update

-(void) CheckNeedToUpdateFromJSON:(id) JSON
{
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    
    if([[JSON objectForKey:@"Data"] objectForKey:@"Cinema"]!= [NSNull null])             
    {
        NSLog(@"Update Cinema");
        NSEntityDescription * cinemaEntity = [Cinema entityInManagedObjectContext:context];
        [self deleteAllObjectWithEntity:cinemaEntity];
        [self insertObjects:(NSArray*)[[JSON objectForKey:@"Data"] objectForKey:@"Cinema"] withEntity:cinemaEntity];
    }
    
    if([[JSON objectForKey:@"Data"] objectForKey:@"Movie"]!=[NSNull null])
    {
        NSLog(@"Update Movie");
        NSEntityDescription * movieEntity = [Movie entityInManagedObjectContext:context];
        [self deleteAllObjectWithEntity:movieEntity];
        [self insertObjects:(NSArray*)[[JSON objectForKey:@"Data"] objectForKey:@"Movie"] withEntity:movieEntity];
    }
    if([[JSON objectForKey:@"Data"] objectForKey:@"Provider"]!=[NSNull null])
    {
        NSLog(@"Update Provider");
        NSEntityDescription * providerEntity = [Provider entityInManagedObjectContext:context];
        [self deleteAllObjectWithEntity:providerEntity];
        [self insertObjects:(NSArray*)[[JSON objectForKey:@"Data"] objectForKey:@"Provider"] withEntity:providerEntity];
        
    }
    if([[JSON objectForKey:@"Data"] objectForKey:@"Sessiontime"]!=[NSNull null])
    {
        NSLog(@"Update Sessiontime");
        NSEntityDescription * sessionEntity = [Sessiontime entityInManagedObjectContext:context];
        [self deleteAllObjectWithEntity:sessionEntity];
        [self insertObjects:(NSArray*)[[JSON objectForKey:@"Data"] objectForKey:@"Sessiontime"] withEntity:sessionEntity];
    }
    
    //Update LastUpdated
    
    [self WriteLastUpdated];
}
#pragma mark Read & Write Last update

- (NSString *) ReadLastUpdated
{
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    NSString * lastUpdatedStr = [[NSString alloc] initWithFormat:@"%@",[temp objectForKey:@"LastUpdated"]];
    
    return lastUpdatedStr;
    
}

- (void) WriteLastUpdated
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YYYY%20hh.mm.ss%20zzz"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *error;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
                               [NSArray arrayWithObjects: currentDate, nil]
                                                          forKeys:[NSArray arrayWithObjects: @"LastUpdated", nil]];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    }
    else 
    {
        NSLog(@"%@",error);
        
    }
    
}

@end
