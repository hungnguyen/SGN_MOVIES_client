//
//  HJManagedImageV.m
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import "SGNManagedImage.h"
#import "HJCache.h"

@implementation SGNManagedImage

@synthesize reflectionGap = _reflectionGap;
@synthesize reflectionScale = _reflectionScale;
@synthesize reflectionAlpha = _reflectionAlpha;
@synthesize shadowColor = _shadowColor;
@synthesize shadowOffset = _shadowOffset;
@synthesize shadowBlur = _shadowBlur;
@synthesize cornerRadius = _cornerRadius;
@synthesize imageContentMode = _imageContentMode;
@synthesize isConfigImage = _isConfigImage;

#pragma mark Init

- (id) init {
    self = [super init];
    if (self) 
    {
        //defaultImage = [UIImage imageNamed:@"no_image.png"];
        //self.image = defaultImage;
        self.backgroundColor = [UIColor clearColor];
        self.imageContentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        //defaultImage = [UIImage imageNamed:@"no_image.png"];
        //self.image = defaultImage;
        self.backgroundColor = [UIColor clearColor];
        self.imageContentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) 
    {
        //self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark Methods

- (void)managedObjFailed
{
    [loadingWheel stopAnimating];
}

- (void) setImageFromURL:(NSString *)imageUrl 
{
    [self setImageFromURL:imageUrl 
              showloading:YES];
}

- (void) setImageFromURL:(NSString *)imageUrl 
             showloading:(BOOL)showloading
{
    if(!imageUrl || [imageUrl isEqual:[NSNull null]])
        return;
    
    UIImage *localImage = [UIImage imageWithContentsOfFile:imageUrl];
    if (localImage) 
    {
        self.image = localImage;
        return;
    }
#if DEBUG
    //    NSLog(@"-----imageUrl:  %@",imageUrl);
#endif
    if (imageUrl && ![imageUrl isEqual:[NSNull null]] && [imageUrl length] > 0) 
    {        
        [self clear];
        if([imageUrl hasPrefix:@"http"])
        {
            self.url = [NSURL URLWithString:imageUrl];		
            if (showloading) [self showLoadingWheel];
            [[HJCache sharedInstance].hjObjManager manage:self];
        }
        else 
        {
            self.image = [UIImage imageNamed:imageUrl];
        }
    } 
    else 
    {
        self.image = [UIImage imageNamed:@"no-image"];
    }
}

#pragma mark Extend of HJManagedImageV method

-(void) setImage:(UIImage*)theImage 
{
    //config ImageFX
    if(_isConfigImage == true)
    {
        theImage = [self imageWithConfig:theImage];
    }
    
    [super setImage:theImage];
    [imageView setContentMode:_imageContentMode];
}

#pragma mark Config Image

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
