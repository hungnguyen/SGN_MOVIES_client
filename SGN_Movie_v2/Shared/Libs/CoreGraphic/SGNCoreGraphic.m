//
//  SGNCoreGraphic.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 9/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGNCoreGraphic.h"

@implementation SGNCoreGraphic

+ (void) drawLinearGradient:(CGContextRef)context rect:(CGRect)rect starColor:(CGColorRef)startColor endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), (CGRectGetMinY(rect)));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), (CGRectGetMaxY(rect)));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

+ (void) draw1PxStroke:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
            CGColorRef:(CGColorRef)color
{
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
    CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

+ (void) drawGlossAndGradient:(CGContextRef)context rect:(CGRect) rect startColor:(CGColorRef)startColor
                     endColor:(CGColorRef) endColor
{
    [self drawLinearGradient:context rect:rect starColor:startColor endColor:endColor];
    
    
    CGColorRef glossColor1 = [UIColor colorWithRed:1.0 green:1.0 
                                              blue:1.0 alpha:0.35].CGColor;
    CGColorRef glossColor2 = [UIColor colorWithRed:1.0 green:1.0 
                                              blue:1.0 alpha:0.1].CGColor;
    
    CGRect topHalf = CGRectMake(rect.origin.x, rect.origin.y, 
                                rect.size.width, rect.size.height/2);
    
    [self drawLinearGradient:context rect:topHalf starColor:glossColor1 endColor:glossColor2];
    
}

@end
