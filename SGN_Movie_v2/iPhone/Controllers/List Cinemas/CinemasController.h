//
//  CinemaController.h
//  SGN_Movie_v2
//
//  Created by vnicon on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGNRepository.h"

@interface CinemasController : UIViewController <UITableViewDelegate, UITableViewDataSource,
RepositoryDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) int isToggled;

@end
