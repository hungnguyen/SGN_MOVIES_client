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

+ (NSString*)idAttributeName
{
    return @"cinemaId";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSParameterAssert(context);
    return [NSEntityDescription entityForName:[Cinema entityName]
                       inManagedObjectContext:context];
}

+ (NSArray*)sortIdAscending
{
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:[Cinema idAttributeName] ascending:YES];
    return [NSArray arrayWithObjects:sort, nil];
}

+ (NSPredicate*)predicateSelectByProviderId:(int)_providerId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %i", [Provider idAttributeName], _providerId];
    return predicate;
}
@end
