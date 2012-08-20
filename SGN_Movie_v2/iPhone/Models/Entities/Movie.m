//
//  Movie.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Movie.h"
#import "Provider.h"

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
@dynamic producer;
@dynamic providerId;
@dynamic title;
@dynamic trailerUrl;
@dynamic version;

+ (NSString*)entityName
{
    return @"Movie";
}

+ (NSString*)entityIdName
{
    return @"movieId";
}
//remove
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSParameterAssert(context);
    return [NSEntityDescription entityForName:[Movie entityName]
                       inManagedObjectContext:context];
}

+ (NSArray*)sortIdAscending
{
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:[Movie entityIdName] ascending:YES];
    return [NSArray arrayWithObjects:sort, nil];
}

+ (NSPredicate*)predicateSelectByProviderId:(int)_providerId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %i", [Provider entityIdName], _providerId];
    return predicate;
}

+ (NSPredicate*)predicateSelectByMovieId:(int)_movieId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %i", [Movie entityIdName], _movieId];
    return predicate;  
}
//end remove
+ (NSArray*) selectByArrayIds:(NSArray*)_movieIds context:(NSManagedObjectContext*)context
{
    NSEntityDescription *description = [NSEntityDescription entityForName:[Movie entityName]
                                                   inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"movieId IN %@", _movieIds];
    NSSortDescriptor *sortDecriptor = [[NSSortDescriptor alloc]initWithKey:[Movie entityIdName] ascending:YES];
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %i", [Movie entityIdName], _movieId];
    NSSortDescriptor *sortDecriptor = [[NSSortDescriptor alloc]initWithKey:[Movie entityIdName] ascending:YES];
    NSArray *sort = [NSArray arrayWithObjects:sortDecriptor, nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:description];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sort];
    
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

@end
