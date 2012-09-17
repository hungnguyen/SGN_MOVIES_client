//
//  SGNCellBackGround.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 9/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGNCellBackGround.h"
#import "SGNCoreGraphic.h"

@implementation SGNCellBackGround

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //create Core Graphic Context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect paperRect = self.bounds;
    
    //Fill content view
    CGColorRef whiteColor = [UIColor whiteColor].CGColor;
    CGContextSetFillColorWithColor(context, whiteColor);
    CGContextFillRect(context, rect);
    
    //Draw border
//    CGColorRef grayColor = [UIColor grayColor].CGColor;
//    CGContextSetStrokeColorWithColor(context, grayColor);
//    CGContextSetLineWidth(context, 1);
//    CGContextStrokeRect(context, paperRect);

    //Draw separator
    CGColorRef lightGrayColor = [UIColor lightGrayColor].CGColor;
    CGPoint startPoint = CGPointMake(paperRect.origin.x, 
                                     paperRect.origin.y + paperRect.size.height - 1);
    CGPoint endPoint = CGPointMake(paperRect.origin.x + paperRect.size.width - 1, 
                                   paperRect.origin.y + paperRect.size.height - 1);
    [SGNCoreGraphic draw1PxStroke:context 
                       startPoint:startPoint 
                         endPoint:endPoint 
                       CGColorRef:lightGrayColor];
    
}

@end
