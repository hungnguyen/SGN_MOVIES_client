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

@property (nonatomic, assign) id<RepositoryDelegate> delegate;
@property (nonatomic, retain) UIActivityIndicatorView* loadingWheel;

+ (Repository*)sharedInstance;

- (void) updateEntityWithUrlString:(NSString*)urlString;
- (void)deleteDataInEntity:(NSEntityDescription*)entity predicate:(NSPredicate*)predicate;
- (void)insertData:(NSArray*)JSON InEntity:(NSEntityDescription*)entity;
- (NSArray*)selectDataInEntity:(NSEntityDescription*)entity predicate:(NSPredicate*)predicate sortDescriptor:(NSArray*)sortDescriptors;

@end
