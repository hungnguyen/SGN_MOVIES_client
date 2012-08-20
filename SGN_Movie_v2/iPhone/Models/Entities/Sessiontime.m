//
//  Sessiontime.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Sessiontime.h"
#import "Cinema.h"
#import "Movie.h"

@implementation Sessiontime

@dynamic cinemaId;
@dynamic date;
@dynamic movieId;
@dynamic providerId;
@dynamic sessiontimeId;
@dynamic time;

+ (NSString*)entityName
{
    return @"Sessiontime";
}

+ (NSString*)entityDateName
{
    return @"date";
}

+(NSString*)entityTimeName
{
    return @"time";
}

//remove
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSParameterAssert(context);
    return [NSEntityDescription entityForName:[Sessiontime entityName]
                       inManagedObjectContext:context];
}

+ (NSArray*) selectMovieIdsByCinemaId:(int)_cinemaId context:(NSManagedObjectContext*)context
{
    NSEntityDescription *description = [NSEntityDescription entityForName:[Sessiontime entityName]
                                                   inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %i", [Cinema entityIdName], _cinemaId];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setEntity:description];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:[Movie entityIdName]]];
    
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

+ (NSArray*) selectByMovieId:(int)_movieId cinemaId:(int)_cinemaId context:(NSManagedObjectContext*)context
{
    NSEntityDescription *description = [NSEntityDescription entityForName:[Sessiontime entityName]
                                                   inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K = %i) AND (%K = %i)", [Movie entityIdName], _movieId, [Cinema entityIdName], _cinemaId];
    NSSortDescriptor *sortDate = [[NSSortDescriptor alloc]initWithKey:[Sessiontime entityDateName] ascending:YES];
    NSSortDescriptor *sortTime = [[NSSortDescriptor alloc]initWithKey:[Sessiontime entityTimeName] ascending:YES];
    NSArray *sort = [NSArray arrayWithObjects:sortDate, sortTime, nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:description];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sort];
    
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

@end
