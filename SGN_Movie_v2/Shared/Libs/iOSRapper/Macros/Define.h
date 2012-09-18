//
//  Define.h
//  iOSRappers
//
//  Created by Duc Ngo on 7/16/12.
//  Copyright (c) 2012 Tech Propulsion Labs. All rights reserved.
//



/* Macro use for NO ARC */
#if __has_feature(objc_arc)
#define SAFE_RELEASE(obj) 
#define SAFE_TIMER_RELEASE(obj) 
#else
#define SAFE_RELEASE(obj) ([obj release], obj = nil)
#define SAFE_TIMER_RELEASE(obj) ([obj invalidate], [obj release], obj = nil)
#endif

/* ARC macros */
#if !defined(__clang__) || __clang_major__ < 3
#ifndef __bridge
#define __bridge
#endif

#ifndef __bridge_retain
#define __bridge_retain
#endif

#ifndef __bridge_retained
#define __bridge_retained
#endif

#ifndef __autoreleasing
#define __autoreleasing
#endif

#ifndef __strong
#define __strong
#endif

#ifndef __unsafe_unretained
#define __unsafe_unretained
#endif

#ifndef __weak
#define __weak
#endif
#endif

#if __has_feature(objc_arc)
#define SAFE_ARC_PROP_RETAIN strong
#define SAFE_ARC_RETAIN(x) (x)
#define SAFE_ARC_RELEASE(x)
#define SAFE_ARC_AUTORELEASE(x) (x)
#define SAFE_ARC_BLOCK_COPY(x) (x)
#define SAFE_ARC_BLOCK_RELEASE(x)
#define SAFE_ARC_SUPER_DEALLOC()
#define SAFE_ARC_AUTORELEASE_POOL_START() @autoreleasepool {
#define SAFE_ARC_AUTORELEASE_POOL_END() }
#else
#define SAFE_ARC_PROP_RETAIN retain
#define SAFE_ARC_RETAIN(x) ([(x) retain])
#define SAFE_ARC_RELEASE(x) ([(x) release])
#define SAFE_ARC_AUTORELEASE(x) ([(x) autorelease])
#define SAFE_ARC_BLOCK_COPY(x) (Block_copy(x))
#define SAFE_ARC_BLOCK_RELEASE(x) (Block_release(x))
#define SAFE_ARC_SUPER_DEALLOC() ([super dealloc])
#define SAFE_ARC_AUTORELEASE_POOL_START() NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#define SAFE_ARC_AUTORELEASE_POOL_END() [pool release];
#endif


/// DEBU macro
#ifdef DEBUG
#define MCRelease(x) [x release], x = nil
#define DLog(...) NSLog(@"%s(%p) %@", __PRETTY_FUNCTION__, self, [NSString stringWithFormat:__VA_ARGS__])
#define ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
#else
#define MCRelease(x) [x release], x = nil
#define DLog(...) do { } while (0)
#ifndef NS_BLOCK_ASSERTIONS
#define NS_BLOCK_ASSERTIONS
#endif
#define ALog(...) NSLog(@"%s(%p) %@", __PRETTY_FUNCTION__, self, [NSString stringWithFormat:__VA_ARGS__])
#endif


/// Import common categories
#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "NSString+Ext.h"
#import "NSManagedObject+Json.h"
#import "UIImage+FX.h"
#import "Functions.h"
#endif



/// Shor selector
#define SEL(x) @selector(x)
#define L(key) (NSLocalizedString((key), nil))


/// Common UI Constants
#define HEIGHT_OF_STATUS_BAR 20
#define HEIGHT_OF_TOOLBAR 44
#define HEIGHT_OF_TABLE_CELL 44
#define HEIGHT_OF_TAB_BAR 49
#define HEIGHT_OF_SEARCH_BAR 44
#define HEIGHT_OF_NAVIGATION_BAR 44
#define HEIGHT_OF_TEXTFIELD 31
#define HEIGHT_OF_PICKER 216
#define HEIGHT_OF_KEYBOARD 216
#define HEIGHT_OF_SEGMENTED_CONTROL 43
#define HEIGHT_OF_SEGMENTED_CONTROL_BAR 29
#define HEIGHT_OF_SEGMENTED_CONTROL_BEZELED 40
#define HEIGHT_OF_SWITCH 27
#define HEIGHT_OF_SLIDER 22
#define HEIGHT_OF_PROGRESS_BAR 9
#define HEIGHT_OF_PAGE_CONTROL 36
#define HEIGHT_OF_BUTTON 37
