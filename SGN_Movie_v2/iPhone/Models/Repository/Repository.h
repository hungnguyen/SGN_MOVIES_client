//
//  CinemaRepository.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Repository;
@interface Repository : NSObject

+ (Repository*)sharedInstance;
- (void) updateEntity:(NSEntityDescription*)entity withUrlString:(NSString*)urlString;
- (void)deleteAllObjectWithEntity:(NSEntityDescription*)entity;
- (void)insertObjects:(NSArray*)JSON withEntity:(NSEntityDescription*)entity;
- (NSArray*)selectObjectsWithEntity:(NSEntityDescription*)entity andPredicateOrNil:(NSPredicate*)predicate;

@end
