//
//  CinemaRepository.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SGNRepository;

@protocol RepositoryDelegate <NSObject>
@required
- (void)RepositoryStartUpdate:(SGNRepository*)repository;
- (void)RepositoryFinishUpdate:(SGNRepository *)repository;
@end

@interface SGNRepository : NSObject

@property (nonatomic, assign) BOOL isUpdateProvider;
@property (nonatomic, assign) BOOL isUpdateCinema;
@property (nonatomic, assign) BOOL isUpdateMovie;
@property (nonatomic, assign) BOOL isUpdateSessiontime;
@property (nonatomic, assign) int currentProviderId;

+ (SGNRepository*)sharedInstance;

- (void)updateEntityWithUrlString:(NSString*)urlString;
- (NSDate*)readLastUpdated;

@end
