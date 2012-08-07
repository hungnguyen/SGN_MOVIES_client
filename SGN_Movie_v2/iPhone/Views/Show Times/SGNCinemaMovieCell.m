//
//  SGNCinemaMovieButton.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGNCinemaMovieCell.h"

@implementation SGNCinemaMovieCell

@synthesize cinemaName = _cinemaName;
@synthesize movieImage = _movieImage;
@synthesize cinemaImage = _cinemaImage;
@synthesize movieTitle = _movieTitle;
- (id)initWithFrame:(CGRect)frame
{
    //self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"SGNCinemaMovieCell" owner:self options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)fillWithCinema:(NSArray*)cinemaObj andMovie:(NSArray*)movieObj
{
    NSString *cinemaImage_url = [NSString stringWithFormat:@"http://www.galaxycine.vn%@", [cinemaObj valueForKey:@"ImageUrl"]];
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
