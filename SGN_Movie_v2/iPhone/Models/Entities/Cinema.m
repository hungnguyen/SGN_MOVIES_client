//
//  Cinema.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/14/12.
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
@dynamic mapUrl;
@dynamic name;
@dynamic phone;
@dynamic providerId;

+ (NSString*)entityName
{
    return @"Cinema";
}

+ (NSString*)entityIdName
{
    return @"cinemaId";
}


//remove
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSParameterAssert(context);
    return [NSEntityDescription entityForName:[Cinema entityName]
                       inManagedObjectContext:context];
}

+ (NSArray*)sortIdAscending
{
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:[Cinema entityIdName] ascending:YES];
    return [NSArray arrayWithObjects:sort, nil];
}

+ (NSPredicate*)predicateSelectByProviderId:(int)_providerId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %i", [Provider entityIdName], _providerId];
    return predicate;
}

+ (NSPredicate*)predicateSelectByCinemaId:(int)_cinemaId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %i", [Cinema entityIdName], _cinemaId];
    return predicate;  
}
//end remove

+ (NSArray*) selectByProviderId:(int)_providerId context:(NSManagedObjectContext*)context
{
    NSEntityDescription *description = [Cinema entityInManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %i", [Provider entityIdName], _providerId];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:[Cinema entityIdName] ascending:YES];
    NSArray *sort =  [NSArray arrayWithObjects:sortDescriptor, nil];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:description];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sort];
    
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

+ (Cinema*) selectByCinemaId:(int)_cinemaId context:(NSManagedObjectContext*)context
{
    NSEntityDescription *description = [Cinema entityInManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %i", [Cinema entityIdName], _cinemaId];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:[Cinema entityIdName] ascending:YES];
    NSArray *sort =  [NSArray arrayWithObjects:sortDescriptor, nil];
    
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
