//
//  ShowTimesController.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowtimesController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *cinemaObject;
@property (strong, nonatomic) NSArray *movieObject;

@property (strong, nonatomic) IBOutlet UIButton *buttonCinemaMovie;
@property (strong, nonatomic) IBOutlet UITableView *tableViewShowtimes;
- (IBAction)setCinemaMovie:(id)sender;

@end
