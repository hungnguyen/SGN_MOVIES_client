//
//  SGNCinemaMovieButton.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGNManagedImage.h"
#import "Cinema.h"
#import "Movie.h"

@class SGNComboView;
@interface SGNComboView : UIView

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet SGNManagedImage *cinemaImage;
@property (strong, nonatomic) IBOutlet SGNManagedImage *movieImage;
@property (strong, nonatomic) IBOutlet UILabel *cinemaName;
@property (strong, nonatomic) IBOutlet UILabel *movieTitle;

- (void)fillWithCinema:(Cinema*)cinemaObj andMovie:(Movie*)movieObj;
- (id)initWithNibName:(NSString*)nibNameOrNil;
@end