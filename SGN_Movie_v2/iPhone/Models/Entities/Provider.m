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
    NSParameterAssert(context);
    return [NSEntityDescription entityForName:[Provider entityName]
                       inManagedObjectContext:context];
}
@end