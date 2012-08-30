//
//  SGNManagedImage.h
//  hjlib
//
//  Copyright Hung Nguyen
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import <Foundation/Foundation.h>
#import "HJManagedImageV.h"


/* 
 The managed image view is a UIView subclass that can be used just like any other view, 
 and it contains a UIImage object thats a managed object, and hence 
 can be cached, shared, and asynchronously loaded by the object manager. 
 So you can think of it like a UIImageView
 that has built in image object sharing, asynchronous loading, and caching.
 If you want to use HJCache for handling images (which is what its primarily designed for)
 you'll probably want to use this class or your own version of it.
 NB HJManagedImageV is an example of how to use HJCache, its not fully functional for all cases, 
 so don't be afraid to code your own version of it to suit your needs.
 */

@class SGNManagedImage;

@interface SGNManagedImage : HJManagedImageV

//new custom values for ImageFX 
@property (nonatomic, assign) UIViewContentMode imageContentMode;
@property (nonatomic, assign) CGFloat reflectionGap;
@property (nonatomic, assign) CGFloat reflectionScale;
@property (nonatomic, assign) CGFloat reflectionAlpha;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat shadowBlur;
@property (nonatomic, assign) CGFloat cornerRadius;

@end





