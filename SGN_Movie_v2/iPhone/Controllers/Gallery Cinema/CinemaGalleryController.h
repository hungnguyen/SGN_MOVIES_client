//
//  CinemaGalleryController.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface CinemaGalleryController : UIViewController <iCarouselDelegate, iCarouselDataSource>

@property (assign, nonatomic) int cinemaObjectId;
@property (strong, nonatomic) IBOutlet iCarousel *carousel;

@end
