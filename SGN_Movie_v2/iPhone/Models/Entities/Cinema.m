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

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSParameterAssert(context);
    return [NSEntityDescription entityForName:[Cinema entityName]
                       inManagedObjectContext:context];
}

@end
