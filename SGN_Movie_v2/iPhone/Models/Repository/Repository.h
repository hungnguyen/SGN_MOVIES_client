//
//  CinemaRepository.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Repository;

@protocol SGNRepositoryDelegate <NSObject>
@required
- (void)SGNRepositoryStartUpdate:(Repository*)repository;
- (void)SGNRepositoryFinishUpdate:(Repository *)repository;
@end

@interface Repository : NSObject

@property (nonatomic, assign) id<SGNRepositoryDelegate> delegate;
@property (nonatomic, retain) UIActivityIndicatorView* loadingWheel;

+ (Repository*)sharedInstance;

- (void) updateEntity:(NSEntityDescription*)entity predicate:(NSPredicate*)predicate urlString:(NSString*)urlString;
- (void)deleteDataInEntity:(NSEntityDescription*)entity predicate:(NSPredicate*)predicate;
- (void)insertData:(NSArray*)JSON InEntity:(NSEntityDescription*)entity;
- (NSArray*)selectDataInEntity:(NSEntityDescription*)entity predicate:(NSPredicate*)predicate sortDescriptor:(NSArray*)sortDescriptors;

@end
