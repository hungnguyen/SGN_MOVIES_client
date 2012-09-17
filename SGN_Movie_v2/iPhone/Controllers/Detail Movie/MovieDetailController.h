//
//  MovieDetailController.h
//  SGN_Movie_v2
//
//  Created by vnicon on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repository.h"
#import "SGNCustomPopup.h"

@interface MovieDetailController : UIViewController <UITableViewDelegate,UITableViewDataSource,
SGNCustomPopupDelegate,RepositoryDelegate>

@property (assign, nonatomic) int movieObjectId;
@property (strong, nonatomic) SGNCustomPopup *popupView;
@property (strong, nonatomic) IBOutlet UIView *maskView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

