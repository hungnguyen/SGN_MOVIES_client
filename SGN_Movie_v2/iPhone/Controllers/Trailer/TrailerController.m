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

//@synthesize youTubePlayerController = _youTubePlayerController;

#pragma mark - Init

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
    youTubePlayerController = [[LBYouTubePlayerViewController alloc] initWithYouTubeURL:youTubeURL];
    [youTubePlayerController setDelegate:self];
    [youTubePlayerController.view setFrame:CGRectMake(0, 0, 320, 400)];
    [self.view addSubview:youTubePlayerController.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    youTubePlayerController = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - LBYouTubePlayerControllerDelegate

-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL
{
    
}
-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller failedExtractingYouTubeURLWithError:(NSError *)error
{
    
}
@end
