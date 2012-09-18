//
//  SGNCustomPopup.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGNCustomPopup.h"
#import "AppDelegate.h"
#import "SGNCollectionViewCell.h"

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
@synthesize pageControl = _pageControl;

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
        _carousel.type = iCarouselTypeLinear;
    }
    return self;
}

- (void)loadViewWithData:(NSArray*)data isMovie:(bool)isMovie
{
    [self setData:data];
    self.isMovie = isMovie;
    [_carousel reloadData];
}

#pragma mark iCarousel DataSource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    _pageControl.numberOfPages = _data.count;
    return [_data count];
}

#pragma mark iCarousel Delegate

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        default:
        {
            return value;
        }
    }
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{ 
    NSString *hostUrl = [[[[AppDelegate currentDelegate] rightMenuController] provider] hostUrl];
    NSString * imageUrl = [hostUrl stringByAppendingString:[[_data objectAtIndex:index] 
                                                             valueForKey:@"imageUrl"]];
    
    SGNCollectionViewCell *cell = (SGNCollectionViewCell*)view;
    if(cell == nil)
    {
        cell = [[SGNCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, POSTER_WIDTH, POSTER_HEIGHT)];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [tapGR setNumberOfTapsRequired:1];
        [cell addGestureRecognizer:tapGR];

    }
    else 
    {
        [cell prepareForReuse];
    } 
        
    cell.tag = index;
    [cell.imageView setImageFromURL:imageUrl];
    if(_isMovie == false)
    {
        cell.contentLabel.text = [[_data objectAtIndex:index] valueForKey:@"name"];
    }
    else
    {
        cell.contentLabel.text = [[_data objectAtIndex:index] valueForKey:@"title"];
    }
    
    _pageControl.currentPage = _carousel.currentItemIndex;
    return cell;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
        _pageControl.currentPage = _carousel.currentItemIndex;
}

#pragma Ultil Methods

- (void)SGNCustomPopupTap:(SGNCustomPopup*)customView withObject:(id)object
{
    if(_delegate != nil && [_delegate respondsToSelector:@selector(SGNCustomPopupTap:withObject:)])
    {
        [_delegate SGNCustomPopupTap:self withObject:object];
    }
}

- (IBAction)pageChange:(id)sender
{
    NSLog(@"page: %i", _pageControl.currentPage);
    [_carousel scrollToItemAtIndex:_pageControl.currentPage animated:YES];
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
}

- (void)tapImageView:(id)sender
{
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
