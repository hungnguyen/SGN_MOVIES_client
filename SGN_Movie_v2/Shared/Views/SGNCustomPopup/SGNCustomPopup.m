//
//  SGNCustomPopup.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGNCustomPopup.h"
#import "HJCache.h"
#import "AppDelegate.h"
#import "SGNManagedImage.h"

#define POSTER_OFFSET_WIDTH 10
#define POSTERS_PER_PAGE 2

@interface SGNCustomPopup ()
@property (nonatomic, strong) NSArray *data;
- (void)popDown:(id)sender;
@end

@implementation SGNCustomPopup

@synthesize delegate = _delegate;
@synthesize title = _title;
@synthesize data = _data;
@synthesize carousel = _carousel;

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

- (void)loadViewWithData:(NSArray*)data
{
    [self setData:data];
    [_carousel reloadData];
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_data count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{ 
    CGRect frame = CGRectMake(0, 0, 150, 180);
    
    NSString *hostUrl = [[[[AppDelegate currentDelegate] rightMenuController] provider] hostUrl];
    NSString * urlString = [hostUrl stringByAppendingString:[[_data objectAtIndex:index] 
                                                             valueForKey:@"imageUrl"]];
    SGNManagedImage *posterImage = [[SGNManagedImage alloc]initWithFrame:frame];
    [posterImage setUrl:[NSURL URLWithString:urlString]];
    [posterImage showLoadingWheel];
    [posterImage setImageContentMode:UIViewContentModeScaleAspectFill];
    
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
    
    [[HJCache sharedInstance].hjObjManager manage:posterImage];        
    
    UIButton *poster = [[UIButton alloc] initWithFrame:frame];
    [poster addTarget:self action:@selector(popDown:) forControlEvents:UIControlEventTouchUpInside];
    [poster setTag:index];
    [poster addSubview:posterImage];
    
    return poster;
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
    frame.origin.y = [self superview].bounds.size.height;
    self.frame = frame;
    
    //animation to new location, dedermined by height of the view in Nib
    [UIView beginAnimations:@"popupView" context:nil];
    frame.origin.y = [self superview].bounds.size.height - self.bounds.size.height;
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
    frame.origin.y = [self superview].bounds.size.height;
    self.frame = frame;
    [UIView commitAnimations];
    
    if(sender != nil && sender != [NSNull null])
    {
        id object  = [_data objectAtIndex:[sender tag]];
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
