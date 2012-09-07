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
#import "Cinema.h"
#import "Movie.h"
#import "Sessiontime.h"
#import "Provider.h"
#import "MovieGallery.h"
#import "CinemaGallery.h"
#import "SGNManagedObject.h"

#define FORMAT_TIME @"dd.MM.yyyy HH.mm.ss"
//#define FORMAT_TIME_GMT @"dd.MM.yyyy HH.mm.ss zzz"

@interface Repository()
@property (assign, nonatomic) BOOL isUpdating;
@end

@implementation Repository

//@synthesize delegate = _delegate;
@synthesize loadingWheel = _loadingWheel;
@synthesize isUpdating = _isUpdating;
@synthesize isUpdateProvider = _isUpdateProvider;
@synthesize isUpdateCinema = _isUpdateCinema;
@synthesize isUpdateMovie = _isUpdateMovie;
@synthesize isUpdateSessiontime = _isUpdateSessiontime;
@synthesize currentProviderId = _currentProviderId;

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
- (void) updateEntityWithUrlString:(NSString*)urlString;
{
    //only allow one updating a time
    if(_isUpdating == YES) 
        return;
    else
    {
        [self setIsUpdating:YES];
        [self setIsUpdateProvider:NO];
        [self setIsUpdateCinema:NO];
        [self setIsUpdateMovie:NO];
        [self setIsUpdateSessiontime:NO];
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];    
    
    //get GMT time
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [formatter setDateFormat:FORMAT_TIME];
    NSDate *gmtDate = [formatter dateFromString:[self readLastUpdated]];

    //get UTC with GMTinput
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:FORMAT_TIME];
    NSString *utcDate = [formatter stringFromDate:gmtDate];

    urlString = [[NSString stringWithFormat:urlString, utcDate, FORMAT_TIME]
                 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [self RepositoryStartUpdate:self];
                                                                                            [self checkNeedToUpdateFromJSON:JSON];
                                                                                            [self RepositoryFinishUpdate:self];
                                                                                            [self setIsUpdating:NO];
                                                                                        } 
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Request Failed with Error: %@, %@", error, [error userInfo]);
                                                                                            [self setIsUpdating:NO];
                                                                                        }
                                         ];
    [operation start];
}

#pragma mark Self Delegate

//raise before update new data 
- (void)RepositoryStartUpdate:(Repository*)repository
{
    id<RepositoryDelegate> delegate = (id<RepositoryDelegate>)[[AppDelegate currentDelegate] navigationController].topViewController;
    
    //create loadding wheel
    [_loadingWheel removeFromSuperview];
	[self setLoadingWheel:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]];
	_loadingWheel.hidesWhenStopped=YES;
    UIView *superView = [(UIViewController*)delegate view];
    _loadingWheel.center = superView.center;
	[superView addSubview:_loadingWheel];
	[_loadingWheel startAnimating];

    if(delegate != nil && [delegate respondsToSelector:@selector(RepositoryStartUpdate:)])
    {
        [delegate RepositoryStartUpdate:repository];
    }
}

//raise after update new data
- (void)RepositoryFinishUpdate:(Repository*)repository
{
    id<RepositoryDelegate> delegate = (id<RepositoryDelegate>)[[AppDelegate currentDelegate] navigationController].topViewController;
    
    [_loadingWheel stopAnimating];
    [_loadingWheel removeFromSuperview];
    
    //save context after update all data
    [[DataService sharedInstance] saveContext];
    
    //reload data for right menu
    if(_isUpdateProvider == YES)
        [[[AppDelegate currentDelegate] rightMenuController] reloadData];
    
    if(delegate != nil && [delegate respondsToSelector:@selector(RepositoryFinishUpdate:)])
    {
        [delegate RepositoryFinishUpdate:repository];
    }
}

#pragma mark Database Query

//delete 
- (void)deleteDataInEntity:(NSEntityDescription*)entity 
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

- (void)insertData:(NSArray*)JSON InEntity:(NSEntityDescription*)entity
{
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    for(NSDictionary *dict in JSON)
    {
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entity.name 
                                                                inManagedObjectContext:context];
        [object safeSetValuesForKeysWithDictionary:dict];
    }
    // NSLog(@"DONE INSERT");
}

#pragma mark Check Need To Update

-(void) checkNeedToUpdateFromJSON:(id) JSON
{
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    if([[JSON objectForKey:@"Data"] objectForKey:@"Cinema"] != [NSNull null])
    {
        NSLog(@"Update Cinemas");
        //update cinema
        NSEntityDescription *cinemaEntity = [Cinema entityInManagedObjectContext:context];
        [self deleteDataInEntity:cinemaEntity];
        [self insertData:(NSArray *)[[JSON objectForKey:@"Data"] objectForKey:@"Cinema"]  
                InEntity:cinemaEntity];
        
        //update cinema gallery
        NSEntityDescription *cinemaGalleryEntity = [CinemaGallery entityInManagedObjectContext:context];
        [self deleteDataInEntity:cinemaGalleryEntity];
        [self insertData:(NSArray *)[[JSON objectForKey:@"Data"] objectForKey:@"CinemaGallery"]  
                InEntity:cinemaGalleryEntity];
        
        [self setIsUpdateCinema:YES];
    }
    if([[JSON objectForKey:@"Data"] objectForKey:@"Movie"] != [NSNull null])
    {
        NSLog(@"Update Movies");
        //update movie
        NSEntityDescription *movieEntity = [Movie entityInManagedObjectContext:context];
        [self deleteDataInEntity:movieEntity];
        [self insertData:(NSArray *)[[JSON objectForKey:@"Data"] objectForKey:@"Movie"]  
                InEntity:movieEntity];
        
        //update movie gallery
        NSEntityDescription *movieGalleryEntity = [MovieGallery entityInManagedObjectContext:context];
        [self deleteDataInEntity:movieGalleryEntity];
        [self insertData:(NSArray *)[[JSON objectForKey:@"Data"] objectForKey:@"MovieGallery"]  
                InEntity:movieGalleryEntity];
        
        [self setIsUpdateMovie:YES];
    }
    if([[JSON objectForKey:@"Data"] objectForKey:@"Sessiontime"] != [NSNull null])
    {
        NSLog(@"Update Sessiontime");
        NSEntityDescription *sessiontimeEntity = [Sessiontime entityInManagedObjectContext:context];
        [self deleteDataInEntity:sessiontimeEntity];
        [self insertData:(NSArray *)[[JSON objectForKey:@"Data"] objectForKey:@"Sessiontime"]  InEntity:sessiontimeEntity];
        [self setIsUpdateSessiontime:YES];
    }
    if([[JSON objectForKey:@"Data"] objectForKey:@"Provider"] != [NSNull null])
    {
        NSLog(@"Update Provider");
        NSEntityDescription *providerEntity = [Provider entityInManagedObjectContext:context];
        [self deleteDataInEntity:providerEntity];
        [self insertData:(NSArray *)[[JSON objectForKey:@"Data"] objectForKey:@"Provider"]  InEntity:providerEntity];
        [self setIsUpdateProvider:YES];
    }
    //Write LastUpdated
    NSString *lastUpdateServer = [[JSON objectForKey:@"Data"] objectForKey:@"LastUpdate"];
    [self writeLastUpdated:lastUpdateServer];
    
}

#pragma mark Read & Write LastUpdate 
- (NSString *) readLastUpdated
{
    
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
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
    
    NSString * LastUpdated = [[NSString alloc] initWithFormat:@"%@",[temp objectForKey:@"LastUpdated"]];
    return  LastUpdated;
}

- (void) writeLastUpdated:(NSString*)lastUpdateServer
{
    if(lastUpdateServer == nil || lastUpdateServer == (NSString*)[NSNull null] || [lastUpdateServer isEqualToString:@""])
        return;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    //get UTC time
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:FORMAT_TIME];
    NSDate *utcDate = [formatter dateFromString:lastUpdateServer];
    
    //get current GMT with UTCinput
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [formatter setDateFormat:FORMAT_TIME];
    NSString *gmtDate = [formatter stringFromDate:utcDate];
    
    NSString *error;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
                               [NSArray arrayWithObjects: gmtDate, nil]
                                                          forKeys:[NSArray arrayWithObjects: @"LastUpdated",nil]];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    }
    
}

@end
