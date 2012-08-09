//
//  SGNCustomPopup.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGNCustomPopup.h"
#import "HJCache.h"

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

- (void)setScrollViewData:(NSArray*)data
{
    //set scrollview content
    [_scrollView setContentSize:CGSizeMake(_scrollView.bounds.size.width * [data count], _scrollView.bounds.size.height)];
    
    for (int i=0; i < [data count]; i++) 
    {
        //set for button
        CGRect frame = _scrollView.bounds;
        frame.origin.x = i * _scrollView.bounds.size.width;
        frame = CGRectInset(frame, 10.0f, 0.0f);
        
        UIButton *poster = [[UIButton alloc] initWithFrame:frame];
        [poster addTarget:self action:@selector(popDown:) forControlEvents:UIControlEventTouchUpInside];
        [poster setTag:i];
        
        //set for image
        frame.origin.x = 0.0f;
        NSString * urlString = [[NSString alloc] initWithString:[[data objectAtIndex:i] 
                                                                 valueForKey:@"ImageUrl"]];
        
        HJManagedImageV *posterImage = [[HJManagedImageV alloc]initWithFrame:frame];
        [posterImage setUrl:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",PROVIDER_URL,urlString]]];
        [posterImage showLoadingWheel];
        //[posterImage setImageContentMode:UIViewContentModeScaleToFill];
        [[HJCache sharedInstance].hjObjManager manage:posterImage];     
        
        [poster addSubview:posterImage];
        [_scrollView addSubview:poster];
    }

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
