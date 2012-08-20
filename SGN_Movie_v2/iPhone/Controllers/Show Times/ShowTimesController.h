//
//  ShowTimesController.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGNComboView.h"
#import "Repository.h"

@interface ShowtimesController : UIViewController <UITableViewDataSource, UITableViewDelegate, RepositoryDelegate,
                                                        UIAlertViewDelegate>

@property (assign, nonatomic) int cinemaObjectId;
@property (assign, nonatomic) int movieObjectId;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet SGNComboView *comboView;

@end
