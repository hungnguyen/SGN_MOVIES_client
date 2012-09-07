//
//  CinemaGallery.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CinemaGallery.h"


@implementation CinemaGallery

@dynamic cinemaId;
@dynamic imageUrl;

+ (NSString*)entityName
{
    return @"CinemaGallery";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription entityForName:[CinemaGallery entityName]
                       inManagedObjectContext:context];
}

+ (NSArray*) selectByCinemaId:(int)_cinemaId context:(NSManagedObjectContext*)context
{
    NSEntityDescription *description = [NSEntityDescription entityForName:[self entityName]
                                                   inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cinemaId = %i", _cinemaId];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:description];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

@end
