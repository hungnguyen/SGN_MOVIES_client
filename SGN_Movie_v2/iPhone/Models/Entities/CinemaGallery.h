//
//  CinemaGallery.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CinemaGallery : NSManagedObject

@property (nonatomic, retain) NSNumber * cinemaId;
@property (nonatomic, retain) NSString * imageUrl;

+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)context;
+ (NSArray*) selectByCinemaId:(int)_cinemaId context:(NSManagedObjectContext*)context;

@end
