//
//  HJCache.h
//  NavgationBar_Review
//
//  Created by vnicon on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJManagedImageV.h"
#import "HJObjManager.h"


@interface HJCache : NSObject

@property (strong, nonatomic) HJObjManager *hjObjManager;

+ (HJCache *)sharedInstance;

@end

