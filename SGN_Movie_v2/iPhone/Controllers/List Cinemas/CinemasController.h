//
//  CinemaController.h
//  SGN_Movie_v2
//
//  Created by vnicon on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repository.h"
#import "WEPopoverContentViewController.h"
#import "WEPopoverController.h"

@interface CinemasController : UIViewController <UITableViewDelegate, UITableViewDataSource, RepositoryDelegate,WEPopoverContentDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) bool isToggled;
@property (strong, nonatomic) WEPopoverController * popOverController;

@end
