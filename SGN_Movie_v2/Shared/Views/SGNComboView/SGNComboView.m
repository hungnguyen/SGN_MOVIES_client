//
//  SGNCinemaMovieButton.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGNComboView.h"
#import "AppDelegate.h"

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

- (void)fillWithCinema:(Cinema*)cinemaObj andMovie:(Movie*)movieObj
{
    NSString *hostUrl = [[[[AppDelegate currentDelegate] rightMenuController]provider]hostUrl];
    NSString *cinemaImage_url = [hostUrl stringByAppendingString:[cinemaObj imageUrl]];
    NSString *movieImage_url = [hostUrl stringByAppendingString:[movieObj imageUrl]];
    
    [_cinemaName setText:[cinemaObj name]];
    [_movieTitle setText:[movieObj title]];
    
    [_cinemaImage setImageFromURL:cinemaImage_url];
    [_movieImage setImageFromURL:movieImage_url];
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
