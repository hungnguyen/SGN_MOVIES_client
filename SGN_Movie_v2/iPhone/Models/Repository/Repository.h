//
//  CinemaRepository.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Repository;

@protocol RepositoryDelegate <NSObject>
@required
- (void)RepositoryStartUpdate:(Repository*)repository;
- (void)RepositoryFinishUpdate:(Repository *)repository;
@end

@interface Repository : NSObject <UIAlertViewDelegate>

@property (nonatomic, retain) UIActivityIndicatorView* loadingWheel;
@property (nonatomic, assign) BOOL isUpdateProvider;
@property (nonatomic, assign) BOOL isUpdateCinema;
@property (nonatomic, assign) BOOL isUpdateMovie;
@property (nonatomic, assign) BOOL isUpdateSessiontime;

+ (Repository*)sharedInstance;

- (void) updateEntityWithUrlString:(NSString*)urlString;
- (NSString *) readLastUpdated;
@end
