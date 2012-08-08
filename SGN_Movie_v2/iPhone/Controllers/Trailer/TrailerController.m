//
//  TrailerController.m
//  SGN_Movie_v2
//
//  Created by vnicon on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrailerController.h"

@interface TrailerController ()

@end

@implementation TrailerController

@synthesize youTubePlayerController = _youTubePlayerController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"TRAILER";
            }
    return self;
}

-(void) createYouTubePlayer:(NSURL*) youTubeURL
{
    _youTubePlayerController = [[LBYouTubePlayerViewController alloc] initWithYouTubeURL:youTubeURL];
    [_youTubePlayerController setDelegate:self];
    [_youTubePlayerController.view setFrame:CGRectMake(0, 0, 320, 400)];
    [self.view addSubview:_youTubePlayerController.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL
{
    
}
-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller failedExtractingYouTubeURLWithError:(NSError *)error
{
    
}
@end
