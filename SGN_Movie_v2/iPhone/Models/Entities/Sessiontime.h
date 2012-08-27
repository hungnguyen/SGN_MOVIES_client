//
//  Sessiontime.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sessiontime : NSManagedObject

@property (nonatomic, retain) NSNumber * cinemaId;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * movieId;
@property (nonatomic, retain) NSNumber * providerId;
@property (nonatomic, retain) NSNumber * sessiontimeId;

+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSArray*) selectByMovieId:(int)_movieId cinemaId:(int)_cinemaId context:(NSManagedObjectContext*)context;
+ (NSArray*) selectMovieIdsByCinemaId:(int)_cinemaId context:(NSManagedObjectContext*)context;
+ (NSArray*) selectCinemaIdsByMovieId:(int)_movieId context:(NSManagedObjectContext*)context;

@end
