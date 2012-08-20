//
//  Sessiontime.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Sessiontime.h"

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

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription entityForName:[Sessiontime entityName]
                       inManagedObjectContext:context];
}

#pragma mark Query
+ (NSArray*) selectMovieIdsByCinemaId:(int)_cinemaId context:(NSManagedObjectContext*)context
{
    NSEntityDescription *description = [NSEntityDescription entityForName:[Sessiontime entityName]
                                                   inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cinemaId = %i", _cinemaId];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setEntity:description];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"movieId"]];
    
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

+ (NSArray*) selectCinemaIdsByMovieId:(int)_movieId context:(NSManagedObjectContext*)context
{
    NSEntityDescription *description = [NSEntityDescription entityForName:[Sessiontime entityName]
                                                   inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"movieId = %i", _movieId];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setEntity:description];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"cinemaId"]];
    
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

+ (NSArray*) selectByMovieId:(int)_movieId cinemaId:(int)_cinemaId context:(NSManagedObjectContext*)context
{
    NSEntityDescription *description = [NSEntityDescription entityForName:[Sessiontime entityName]
                                                   inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(movieId = %i) AND (cinemaId = %i)", _movieId, _cinemaId];
    NSSortDescriptor *sortDate = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
    NSSortDescriptor *sortTime = [[NSSortDescriptor alloc]initWithKey:@"time" ascending:YES];
    NSArray *sort = [NSArray arrayWithObjects:sortDate, sortTime, nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:description];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sort];
    
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

@end
