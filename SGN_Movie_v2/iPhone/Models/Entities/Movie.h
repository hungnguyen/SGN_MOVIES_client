//
//  Movie.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Movie : NSManagedObject

@property (nonatomic, retain) NSString * cast;
@property (nonatomic, retain) NSString * director;
@property (nonatomic, retain) NSString * duration;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * infoUrl;
@property (nonatomic, retain) NSNumber * isNowShowing;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * movieDescription;
@property (nonatomic, retain) NSNumber * movieId;
@property (nonatomic, retain) NSString * movieWebId;
@property (nonatomic, retain) NSNumber * providerId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * trailerUrl;
@property (nonatomic, retain) NSString * version;

+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)context;

+ (Movie*) selectByMovieId:(int)_movieId context:(NSManagedObjectContext*)context;
+ (NSArray*) selectByArrayIds:(NSArray*)_movieIds context:(NSManagedObjectContext*)context;
+ (NSArray*) selectByProviderId:(int)_providerId context:(NSManagedObjectContext*)context;
+ (NSArray*) selectByProviderId:(int)_providerId isNowShowing:(bool)_isShowing context:(NSManagedObjectContext*)context;

@end
