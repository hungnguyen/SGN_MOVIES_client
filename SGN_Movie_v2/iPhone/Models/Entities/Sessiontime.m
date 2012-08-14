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
    NSParameterAssert(context);
    return [NSEntityDescription entityForName:[Sessiontime entityName]
                       inManagedObjectContext:context];
}
@end
