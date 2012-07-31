//
//  CinemaController.h
//  SGN_Movie_v2
//
//  Created by vnicon on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CinemasController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    @public
    bool isToggled;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listCinemas;

@end
