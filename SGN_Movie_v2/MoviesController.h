//
//  ViewController.h
//  SGN_Movie_v2
//
//  Created by vnicon on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJCache.h"

@interface ViewController : UIViewController <UIScrollViewDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;
@property (retain, nonatomic) NSArray * nowShowingMovies;
@property (retain,nonatomic)  NSArray * comingSoonMovies;

@end
