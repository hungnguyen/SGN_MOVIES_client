//
//  HJCache.m
//  NavgationBar_Review
//
//  Created by vnicon on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HJCache.h"


@implementation HJCache


+(HJObjManager *)getHJObjManager
{
    if(imgMan==nil)
    {
        imgMan = [[HJObjManager alloc] init];
        //if you are using for full screen images, you'll need a smaller memory cache:
        //HJObjManager* objMan = [[HJObjManager alloc] initWithLoadingBufferSize:2 memCacheSize:2];
        
        NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches"] ;
        HJMOFileCache* fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectory];
        imgMan.fileCache = fileCache;
    }
    return imgMan;
}

@end
