//
//  SGNCustomPopup.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGNCustomPopup.h"
#import "SGNManagedImage.h"
#import "AppDelegate.h"

@interface SGNCustomPopup ()
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) bool isMovie;
- (void)popDown:(id)sender;
@end

@implementation SGNCustomPopup

@synthesize delegate = _delegate;
@synthesize data = _data;
@synthesize carousel = _carousel;
@synthesize isMovie = _isMovie;

#pragma mark Init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithNibName:(NSString*)nibNameOrNil
{
    //load default NibName if does not have
    if(nibNameOrNil == nil || [nibNameOrNil isEqualToString:@""])
        nibNameOrNil = @"SGNCustomPopup";
    self = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] objectAtIndex:0];
    
    if(self)
    {
        //Init
        _carousel.type = iCarouselTypeCoverFlow;
        
    }
    return self;
}

- (void)loadViewWithData:(NSArray*)data isMovie:(bool)isMovie
{
    [self setData:data];
    self.isMovie = isMovie;
    [_carousel reloadData];
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_data count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{ 
    NSString *hostUrl = [[[[AppDelegate currentDelegate] rightMenuController] provider] hostUrl];
    NSString * urlString = [hostUrl stringByAppendingString:[[_data objectAtIndex:index] 
                                                             valueForKey:@"imageUrl"]];
    
    SGNManagedImage *posterImage = (SGNManagedImage*)view;
    if(posterImage == nil)
    {
        NSLog(@"Carousel");
        CGRect frame = CGRectMake(0, 0, 150, 200);
        posterImage = [[SGNManagedImage alloc]initWithFrame:frame];
        [posterImage setImageContentMode:UIViewContentModeScaleAspectFit];
        
        //apply configs below
        posterImage.isConfigImage =  true;
        //scale image to show reflection
        posterImage.reflectionScale = 0.25f;
        //opaque of reflection image
        posterImage.reflectionAlpha = 0.25f;
        //gap between image and its reflection
        posterImage.reflectionGap = 10.0f;
        //shadow behind image
        posterImage.shadowOffset = CGSizeMake(0.0f, 2.0f);
        posterImage.shadowBlur = 5.0f;
        posterImage.shadowColor = [UIColor blackColor]; 
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popDown:)];
        [tapGR setNumberOfTapsRequired:1];
        [posterImage addGestureRecognizer:tapGR];
        
        frame = CGRectMake(0, 0, 320, 20);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
        titleLabel.tag = 999;
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        [posterImage addSubview:titleLabel];
    }
    [posterImage clear];
    posterImage.frame = _carousel.bounds;
    posterImage.tag = index;
    [posterImage setImageFromURL:urlString];
    UILabel *titleLabel = (UILabel*)[posterImage viewWithTag:999];
    if(_isMovie == false)
    {
        titleLabel.text = [[_data objectAtIndex:index] valueForKey:@"name"];
    }
    return posterImage;
}


#pragma Ultil Methods

- (void)SGNCustomPopupTap:(SGNCustomPopup*)customView withObject:(id)object
{
    if(_delegate != nil && [_delegate respondsToSelector:@selector(SGNCustomPopupTap:withObject:)])
    {
        [_delegate SGNCustomPopupTap:self withObject:object];
    }
}

#pragma mark Popup-down Methods
- (void)popUp
{
    //set initial location at bottom of view
    CGRect frame = self.bounds;
    frame.origin.x = [self superview].bounds.size.width;
    frame.origin.y = (self.superview.bounds.size.height - frame.size.height ) / 2;
    self.frame = frame;
    
    //animation to new location, dedermined by height of the view in Nib
    [UIView beginAnimations:@"popupView" context:nil];
    frame.origin.x = [self superview].bounds.size.width - self.bounds.size.width;
    self.frame = frame;
    [UIView commitAnimations];
}

- (void)popDown:(id)sender
{
    [UIView beginAnimations:@"popdownView" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    //move this view to bottom of superview
    CGRect frame =  self.frame;
    frame.origin.x = [self superview].bounds.size.width;
    self.frame = frame;
    [UIView commitAnimations];
    
    if(sender != nil && sender != [NSNull null])
    {
        UITapGestureRecognizer *tapGR = (UITapGestureRecognizer*)sender;
        id object  = [_data objectAtIndex:tapGR.view.tag];
        [self SGNCustomPopupTap:self withObject:object];
    }
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
    if ([animationID isEqualToString:@"popdownView"]) 
    {
        [self removeFromSuperview];
    }
}


@end
