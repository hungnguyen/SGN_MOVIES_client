//
//  SGNCoreGraphic.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 9/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGNCoreGraphic : NSObject

+ (void) drawLinearGradient:(CGContextRef)context rect:(CGRect)rect starColor:(CGColorRef)startColor endColor:(CGColorRef)endColor;

+ (void) draw1PxStroke:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
            CGColorRef:(CGColorRef)color;

+ (void) drawGlossAndGradient:(CGContextRef)context rect:(CGRect) rect startColor:(CGColorRef)startColor
                     endColor:(CGColorRef) endColor;

@end
