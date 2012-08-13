//
//  Movie.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Movie : NSManagedObject

@property (nonatomic, retain) NSNumber * movieId;
@property (nonatomic, retain) NSNumber * providerId;
@property (nonatomic, retain) NSString * director;
@property (nonatomic, retain) NSString * movieWebId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSString * duration;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * movieDescription;
@property (nonatomic, retain) NSString * cast;
@property (nonatomic, retain) NSNumber * isNowShowing;
@property (nonatomic, retain) NSString * producer;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSString * infoUrl;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * trailerUrl;

@end
