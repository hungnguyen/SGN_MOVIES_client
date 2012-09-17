//
//  ViewController.h
//  SGN_Movie_v2
//
//  Created by vnicon on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGNRepository.h"
#import "PSCollectionView.h"

@interface MoviesController : UIViewController <UIScrollViewDelegate, RepositoryDelegate,
PSCollectionViewDelegate, PSCollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (assign, nonatomic) int isToggled;

- (IBAction)pageChange:(id)sender;

@end