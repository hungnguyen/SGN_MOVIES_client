//
//  Provider.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Provider : NSManagedObject

@property (nonatomic, retain) NSString * hostUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * providerId;

+ (NSString*)entityName;
+ (NSString*)entityIdName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)context;

@end
