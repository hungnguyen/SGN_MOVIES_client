//
//  MovieDetailController.h
//  SGN_Movie_v2
//
//  Created by vnicon on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJCache.h"
#import "MoviesController.h"
#import "AppDelegate.h"
#import "TrailerController.h"
#import "SGNCustomPopup.h"
#import "Repository.h"

@interface MovieDetailController : UIViewController <UITableViewDelegate,UITableViewDataSource,
                                                        SGNCustomPopupDelegate,RepositoryDelegate>

@property (strong, nonatomic) NSArray *listCinemas;
@property (assign, nonatomic) int movieObjectId;
@property (strong, nonatomic)  SGNCustomPopup *popupView;
@property (strong, nonatomic) IBOutlet UIView *maskView;
@property (strong, nonatomic) IBOutlet UIButton *trailerButton;
@property (strong, nonatomic) IBOutlet UIButton *showTimeButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextView *textView;

- (IBAction)showTrailer:(id)sender;
- (IBAction)showShowTime:(id)sender;

@end
