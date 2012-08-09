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

#define PROVIDER_URL @"http://www.galaxycine.vn/"

@interface MoviesController : UIViewController <UIScrollViewDelegate>
{
    @public
    bool isToggled;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@end
