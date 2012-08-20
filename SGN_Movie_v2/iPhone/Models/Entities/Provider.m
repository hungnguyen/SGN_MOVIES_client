//
//  Provider.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Provider.h"


@implementation Provider

@dynamic hostUrl;
@dynamic name;
@dynamic providerId;

+ (NSString*)entityName
{
    return @"Provider";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription entityForName:[Provider entityName]
                       inManagedObjectContext:context];
}

#pragma mark Query
+ (Provider*) selectByProviderId:(int)_providerId context:(NSManagedObjectContext*)context
{
    NSEntityDescription *description = [NSEntityDescription entityForName:[Provider entityName]
                                                   inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"providerId = %i", _providerId];

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

+ (NSArray*) selectAllInContext:(NSManagedObjectContext*)context
{
    NSEntityDescription *description = [NSEntityDescription entityForName:[Provider entityName]
                                                   inManagedObjectContext:context];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"providerId" ascending:YES];
    NSArray *sort =  [NSArray arrayWithObjects:sortDescriptor, nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:description];
    [fetchRequest setSortDescriptors:sort];
    
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

@end
