//
//  ViewController.h
//  SGN_Movie_v2
//
//  Created by vnicon on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJCache.h"
#import "AboutController.h"
#import "MovieDetailController.h"
#import "Repository.h"
#import "DataService.h"
#import "Movie.h"
#import "Provider.h"

@interface MoviesController : UIViewController <UIScrollViewDelegate, RepositoryDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (assign, nonatomic) int isToggled;
@end
