//
//  Movie.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/13/12.
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
@dynamic producer;
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
    NSParameterAssert(context);
    return [NSEntityDescription entityForName:[Movie entityName]
                       inManagedObjectContext:context];
}

@end
