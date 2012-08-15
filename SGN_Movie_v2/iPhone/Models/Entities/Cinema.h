//
//  Cinema.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Cinema : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * cinemaId;
@property (nonatomic, retain) NSString * cinemaWebId;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * mapUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * providerId;

+ (NSString*)entityName;
+ (NSString*)idAttributeName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)context;

@end
