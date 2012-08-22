//
//  SGNCustomPopup.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGNCustomPopup.h"
#import "HJCache.h"

#define POSTER_OFFSET_WIDTH 10
#define POSTERS_PER_PAGE 2

@interface SGNCustomPopup ()
- (void)popDown:(id)sender;
@end

@implementation SGNCustomPopup

@synthesize delegate = _delegate;
@synthesize srollView  = _scrollView;
@synthesize title = _title;

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
    }
    return self;
}

- (void)loadViewWithData:(NSArray*)data
{
    int count = [data count];
    
    //create content size for scroll view
    CGRect frame = _scrollView.frame;
    
    int poster_width = (frame.size.width) / POSTERS_PER_PAGE;
    int poster_height = (frame.size.height); 
    [_scrollView setContentSize:CGSizeMake(poster_width * count, poster_height)];
    
    //create poster for each movie
    for(NSInteger i = 0; i < count; i++)
    {
        frame.size.width = poster_width - POSTER_OFFSET_WIDTH * 2;
        frame.size.height = poster_height;
        
        //set for image
        frame.origin.x = 0.0f;
        frame.origin.y = 0.0f;
        NSString * urlString = [[NSString alloc] initWithString:[[data objectAtIndex:i] 
                                                                 valueForKey:@"ImageUrl"]];
        
        HJManagedImageV *posterImage = [[HJManagedImageV alloc]initWithFrame:frame];
        [posterImage setUrl:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",PROVIDER_URL,urlString]]];
        [posterImage showLoadingWheel];
        [posterImage setImageContentMode:UIViewContentModeScaleToFill];
        [[HJCache sharedInstance].hjObjManager manage:posterImage];        
        
        //set for button
        frame.origin.x = poster_width * i + POSTER_OFFSET_WIDTH;
        frame.origin.y = 0.0f;
        //int movieId = (int)[[_movieObjects objectAtIndex:i] valueForKey:@"Id"];
        UIButton *poster = [[UIButton alloc] initWithFrame:frame];
        [poster addTarget:self action:@selector(popDown:) forControlEvents:UIControlEventTouchUpInside];
        [poster setTag:i];
        [poster addSubview:posterImage];
        
        [_scrollView addSubview:poster];
    }
    if(count > 2)
        [_scrollView setContentOffset:CGPointMake(poster_width / 2, 0) animated:NO];
}

#pragma Ultil Methods

//return scrollView when hit on view self
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return _scrollView;
    }
    return view;
}

- (void)SGNCustomPopupTap:(SGNCustomPopup*)customView withObjectIndex:(int)objectIndex
{
    
    if(_delegate != nil && [_delegate respondsToSelector:@selector(SGNCustomPopupTap:withObjectIndex:)])
    {
        [_delegate SGNCustomPopupTap:self withObjectIndex:objectIndex];
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
        [self SGNCustomPopupTap:self withObjectIndex:[sender tag]];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
    if ([animationID isEqualToString:@"popdownView"]) 
    {
        [self removeFromSuperview];
    }
}


@end
