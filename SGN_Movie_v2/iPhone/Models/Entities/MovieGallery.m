//
//  MovieGallery.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieGallery.h"


@implementation MovieGallery

@dynamic movieId;
@dynamic imageUrl;

+ (NSString*)entityName
{
    return @"MovieGallery";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription entityForName:[MovieGallery entityName]
                       inManagedObjectContext:context];
}

+ (NSArray*) selectByMovieId:(int)_movieId context:(NSManagedObjectContext*)context
{
    NSEntityDescription *description = [NSEntityDescription entityForName:[self entityName]
                                                   inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"movieId = %i", _movieId];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:description];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

@end
