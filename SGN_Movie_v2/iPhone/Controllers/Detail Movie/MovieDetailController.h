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

@interface MovieDetailController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
   UITableView *tableView;
}

@property (strong, nonatomic) IBOutlet UIButton *trailerButton;
- (IBAction)showTrailer:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *showTimeButton;
- (IBAction)showShowTime:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSDictionary * movieInfo;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end
