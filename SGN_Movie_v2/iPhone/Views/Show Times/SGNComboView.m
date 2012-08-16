//
//  SGNCinemaMovieButton.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGNComboView.h"

@implementation SGNComboView

@synthesize cinemaName = _cinemaName;
@synthesize movieImage = _movieImage;
@synthesize cinemaImage = _cinemaImage;
@synthesize movieTitle = _movieTitle;
@synthesize mainView = _mainView;

- (id)initWithCoder:(NSCoder*)coder 
{
    //init self as place holder, without any sub view in it (in XIB file, this is mainView)
    if ((self = [super initWithCoder:coder])) 
    {
        //get mainView from XIB file
        UIView *mainView = [[[NSBundle mainBundle] loadNibNamed:@"SGNComboView" 
                                                          owner:self 
                                                        options:nil] objectAtIndex:0];
        //add mainView as subview for self
        [self addSubview:mainView];
    }
    return self; 
}

- (id)initWithNibName:(NSString*)nibNameOrNil
{
    if(self)
    {
        //Load all views in XIB file
        if(nibNameOrNil == nil || [nibNameOrNil isEqualToString:@""])
            nibNameOrNil = @"SGNComboView";
        UIView *myMainView = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil 
                                                            owner:self 
                                                          options:nil] objectAtIndex:0];
        //init SGNCinemaMovieCell view based on mainView
        //then add mainView as sub view of self
        self = [super initWithFrame:myMainView.frame];
        [self addSubview:myMainView];
    }
    return self;
}

- (void)fillWithCinema:(Cinema*)cinemaObj andMovie:(NSArray*)movieObj
{
    NSString *cinemaImage_url = [NSString stringWithFormat:@"http://www.galaxycine.vn%@", [cinemaObj imageUrl]];
    NSString *movieImage_url = [NSString stringWithFormat:@"http://www.galaxycine.vn%@", [movieObj valueForKey:@"ImageUrl"]];
    
    [_cinemaName setText:[cinemaObj valueForKey:@"Name"]];
    [_movieTitle setText:[movieObj valueForKey:@"Title"]];
    
    [_cinemaImage clear];
    [_cinemaImage setUrl:[NSURL URLWithString:cinemaImage_url]];
    [_cinemaImage showLoadingWheel];
    [[HJCache sharedInstance].hjObjManager manage:_cinemaImage];
    
    [_movieImage clear];
    [_movieImage setUrl:[NSURL URLWithString:movieImage_url]];
    [_movieImage showLoadingWheel];
    [[HJCache sharedInstance].hjObjManager manage:_movieImage];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
