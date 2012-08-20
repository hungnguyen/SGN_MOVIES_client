//
//  DetaiCinemaController.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJCache.h"
#import "Repository.h"

@interface CinemaDetailController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate, RepositoryDelegate>

@property (assign, nonatomic) int cinemaObjectId;
@property (strong, nonatomic) IBOutlet HJManagedImageV *cinemaImage;
@property (strong, nonatomic) IBOutlet UILabel *cinemaName;
@property (strong, nonatomic) IBOutlet UILabel *cinemaPhone;
@property (strong, nonatomic) IBOutlet UILabel *cinemaAddress;
@property (strong, nonatomic) IBOutlet UIView *cinemaView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)showMap:(id)sender;
- (IBAction)showTicket:(id)sender;

@end
