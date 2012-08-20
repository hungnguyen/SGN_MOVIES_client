//
//  SGNCinemaMovieButton.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJCache.h"
#import "Cinema.h"
#import "Movie.h"

@class SGNComboView;
@interface SGNComboView : UIView

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet HJManagedImageV *cinemaImage;
@property (strong, nonatomic) IBOutlet HJManagedImageV *movieImage;
@property (strong, nonatomic) IBOutlet UILabel *cinemaName;
@property (strong, nonatomic) IBOutlet UILabel *movieTitle;

- (void)fillWithCinema:(Cinema*)cinemaObj andMovie:(Movie*)movieObj;
- (id)initWithNibName:(NSString*)nibNameOrNil;
@end
