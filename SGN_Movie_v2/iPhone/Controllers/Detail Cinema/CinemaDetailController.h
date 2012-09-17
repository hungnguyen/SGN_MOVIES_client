//
//  DetaiCinemaController.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJCache.h"
#import "SGNCustomPopup.h"
#import "Repository.h"

@interface CinemaDetailController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate, RepositoryDelegate,
SGNCustomPopupDelegate>

@property (assign, nonatomic) int cinemaObjectId;
@property (strong, nonatomic)  SGNCustomPopup *popupView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *maskView;

@end
