//
//  MovieGalleryController.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface MovieGalleryController : UIViewController <iCarouselDelegate, iCarouselDataSource>

@property (assign, nonatomic) int movieObjectId;
@property (strong, nonatomic) IBOutlet iCarousel *carousel;

@end
