//
//  RightMenuController.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Provider.h"

@interface RightMenuController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic, readonly) Provider *provider;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void) reloadData;

@end
