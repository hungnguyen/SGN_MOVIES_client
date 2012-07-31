//
//  HJCache.m
//  NavgationBar_Review
//
//  Created by vnicon on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HJCache.h"

@implementation HJCache

@synthesize hjObjManager = _hjObjManager;

+ (HJCache *)sharedInstance
{
    static HJCache *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HJCache alloc] init];
        // Do any other initialisation stuff here
        if([sharedInstance hjObjManager]==nil)
        {
            [sharedInstance setHjObjManager:[[HJObjManager alloc] initWithLoadingBufferSize:5000 memCacheSize:5000]];
        
            NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/Images"];
            HJMOFileCache* fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectory];
            // Have the file cache trim itself down to a size & age limit, so it doesn't grow forever
            fileCache.fileCountLimit = 1000;
            fileCache.fileAgeLimit = 60*60*24; //1 day caching
            [fileCache trimCacheUsingBackgroundThread];

            [sharedInstance.hjObjManager setFileCache:fileCache];
        }
    });
    return sharedInstance;
}

@end
