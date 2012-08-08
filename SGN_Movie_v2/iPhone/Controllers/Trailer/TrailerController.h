//
//  TrailerController.h
//  SGN_Movie_v2
//
//  Created by vnicon on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBYouTubePlayerViewController.h"

@interface TrailerController : UIViewController <LBYouTubePlayerControllerDelegate>
{
    LBYouTubePlayerViewController *youTubePlayerController;
}
-(void) createYouTubePlayer:(NSURL*) youTubeURL;
@end
