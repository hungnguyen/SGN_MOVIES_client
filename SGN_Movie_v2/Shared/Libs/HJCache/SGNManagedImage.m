//
//  HJManagedImageV.m
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import "SGNManagedImage.h"
#import "UIImage+FX.h"

@implementation SGNManagedImage

@synthesize reflectionGap = _reflectionGap;
@synthesize reflectionScale = _reflectionScale;
@synthesize reflectionAlpha = _reflectionAlpha;
@synthesize shadowColor = _shadowColor;
@synthesize shadowOffset = _shadowOffset;
@synthesize shadowBlur = _shadowBlur;
@synthesize cornerRadius = _cornerRadius;
@synthesize imageContentMode = _imageContentMode;

-(void) setImage:(UIImage*)theImage 
{
    UIImage *theNewImage = [self imageWithConfig:theImage];
    [super setImage:theNewImage];
    [imageView setContentMode:_imageContentMode];
}

- (UIImage*)imageWithConfig:(UIImage*)theImage
{
    if (theImage)
    {
        CGSize size = self.bounds.size;
        //crop and scale image
        theImage = [theImage imageCroppedAndScaledToSize:size
                                             contentMode:_imageContentMode
                                                padToFit:NO];     
        //clip corners
        if (_cornerRadius)
        {
            theImage = [theImage imageWithCornerRadius:_cornerRadius];
        }
        
        //apply shadow
        if (_shadowColor && ![_shadowColor isEqual:[UIColor clearColor]] &&
            (_shadowBlur || !CGSizeEqualToSize(_shadowOffset, CGSizeZero)))
        {
            _reflectionGap -= 2.0f * (fabsf(_shadowOffset.height) + _shadowBlur);
            theImage = [theImage imageWithShadowColor:_shadowColor
                                               offset:_shadowOffset
                                                 blur:_shadowBlur];
        }
        
        //apply reflection
        if (_reflectionScale && _reflectionAlpha)
        {
            theImage = [theImage imageWithReflectionWithScale:_reflectionScale
                                                          gap:_reflectionGap
                                                        alpha:_reflectionAlpha];
        }
    }
    return theImage;
}
@end
