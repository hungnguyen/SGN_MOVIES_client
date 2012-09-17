//
//  Cinema.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Cinema.h"


@implementation Cinema

@dynamic address;
@dynamic cinemaId;
@dynamic cinemaWebId;
@dynamic imageUrl;
@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic phone;
@dynamic providerId;

+ (NSString*)entityName
{
    return @"Cinema";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription entityForName:[Cinema entityName]
                       inManagedObjectContext:context];
}

#pragma mark Query

+ (NSArray*) selectByProviderId:(int)_providerId context:(NSManagedObjectContext*)context
{
    NSEntityDescription *description = [NSEntityDescription entityForName:[Cinema entityName]
                                                   inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"providerId = %i", _providerId];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    NSArray *sort =  [NSArray arrayWithObjects:sortDescriptor, nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:description];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sort];
    
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

+ (NSArray*) selectByArrayIds:(NSArray*)_cinemaIds context:(NSManagedObjectContext*)context
{
    NSEntityDescription *description = [NSEntityDescription entityForName:[Cinema entityName]
                                                   inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cinemaId IN %@", _cinemaIds];
    NSSortDescriptor *sortDecriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    NSArray *sort = [NSArray arrayWithObjects:sortDecriptor, nil];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setEntity:description];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sort];
    
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

+ (Cinema*) selectByCinemaId:(int)_cinemaId context:(NSManagedObjectContext*)context
{
    NSEntityDescription *description = [NSEntityDescription entityForName:[Cinema entityName]
                                                   inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cinemaId = %i", _cinemaId];
    
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

@end
