//
//  HJCache.m
//  NavgationBar_Review
//
//  Created by vnicon on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HJCache.h"
#define HJCache_IMAGE_FOLDER [NSTemporaryDirectory() stringByAppendingPathComponent:@"images"]

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
            // Init HJ caching
            // Create the object manager
            [sharedInstance setHjObjManager:[[HJObjManager alloc] initWithLoadingBufferSize:1000 memCacheSize:50]];
        
            // Create a file cache for the object manager to use
            // A real app might do this durring startup, allowing the object manager and cache to be shared by several screens
            HJMOFileCache* fileCache = [[HJMOFileCache alloc] initWithRootPath:HJCache_IMAGE_FOLDER];
            [sharedInstance.hjObjManager setFileCache:fileCache];
            
            // Have the file cache trim itself down to a size & age limit, so it doesn't grow forever
            fileCache.fileCountLimit = 1000;
            fileCache.fileAgeLimit = 60*60*24; //1 day caching
            [fileCache trimCacheUsingBackgroundThread];

            // Have the file cache trim itself down to a size & age limit, so it doesn't grow forever
            //fileCache.fileCountLimit = 300;
            //fileCache.fileAgeLimit = 60*60*24*7; //1 week
            //[fileCache trimCacheUsingBackgroundThread];
        }
    });
    return sharedInstance;
}

@end
