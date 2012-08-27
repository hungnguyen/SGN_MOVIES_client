//
//  Movie.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Movie.h"


@implementation Movie

@dynamic cast;
@dynamic director;
@dynamic duration;
@dynamic genre;
@dynamic imageUrl;
@dynamic infoUrl;
@dynamic isNowShowing;
@dynamic language;
@dynamic movieDescription;
@dynamic movieId;
@dynamic movieWebId;
@dynamic providerId;
@dynamic title;
@dynamic trailerUrl;
@dynamic version;

+ (NSString*)entityName
{
    return @"Movie";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription entityForName:[Movie entityName]
                       inManagedObjectContext:context];
}

#pragma mark Query
+ (NSArray*) selectByArrayIds:(NSArray*)_movieIds context:(NSManagedObjectContext*)context
{
    NSEntityDescription *description = [NSEntityDescription entityForName:[Movie entityName]
                                                   inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"movieId IN %@", _movieIds];
    NSSortDescriptor *sortDecriptor = [[NSSortDescriptor alloc]initWithKey:@"movieId" ascending:YES];
    NSArray *sort = [NSArray arrayWithObjects:sortDecriptor, nil];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setEntity:description];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sort];
    
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

+ (Movie*) selectByMovieId:(int)_movieId context:(NSManagedObjectContext*)context
{
    NSEntityDescription *description = [NSEntityDescription entityForName:[Movie entityName]
                                                   inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"movieId = %i", _movieId];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:description];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    if (items != nil && [items count] > 0) 
    {
        return [items objectAtIndex:0];
    }
    else {
        return nil;
    }
}

+ (NSArray*) selectByProviderId:(int)_providerId context:(NSManagedObjectContext*)context
{
    NSEntityDescription *description = [NSEntityDescription entityForName:[Movie entityName]
                                                   inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"providerId = %i", _providerId];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"movieId" ascending:YES];
    NSArray *sort =  [NSArray arrayWithObjects:sortDescriptor, nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:description];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sort];
    
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

+ (NSArray*) selectByProviderId:(int)_providerId isNowShowing:(bool)_isShowing context:(NSManagedObjectContext*)context
{
    NSEntityDescription *description = [NSEntityDescription entityForName:[Movie entityName]
                                                   inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(providerId = %i) AND (isNowShowing = %i)", _providerId, _isShowing];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"movieId" ascending:YES];
    NSArray *sort =  [NSArray arrayWithObjects:sortDescriptor, nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:description];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sort];
    
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

@end
