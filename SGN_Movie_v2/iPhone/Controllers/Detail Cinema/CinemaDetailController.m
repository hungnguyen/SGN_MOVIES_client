//
//  DetaiCinemaController.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CinemaDetailController.h"
#import <QuartzCore/QuartzCore.h> 
#import "AFNetworking.h"
#import "MapKitDisplayController.h"

//define width height of each poster in list view
#define POSTER_OFFSET_WIDTH 10
#define POSTERS_PER_PAGE 2

@interface CinemaDetailController ()
{
    int poster_width;
    int poster_height;
}
    @property (strong, nonatomic) NSArray *movieObjects;
@end


@implementation CinemaDetailController

@synthesize movieObjects = _movieObjects;
@synthesize cinemaObject = _cinemaObject;
@synthesize cinemaImage = _cinemaImage;
@synthesize cinemaName =_cinemaName;
@synthesize cinemaPhone = _cinemaPhone;
@synthesize cinemaAddress = _cinemaAddress;
@synthesize cinemaView = _cinemaView;
@synthesize scrollView = _scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *image_url = [NSString stringWithFormat:@"http://www.galaxycine.vn%@", [_cinemaObject valueForKey:@"ImageUrl"]];
    
    //set round border
    [[_cinemaView layer] setMasksToBounds:YES];
    [[_cinemaView layer] setCornerRadius:10.0f];
    [[_cinemaImage layer] setMasksToBounds:YES];
    [[_cinemaImage layer] setCornerRadius:10.0f];

    [_cinemaName setText:[_cinemaObject valueForKey:@"Name"]];
    [_cinemaPhone setText:[_cinemaObject valueForKey:@"Phone"]];
    [_cinemaAddress setText:[_cinemaObject valueForKey:@"Address"]];
    [_cinemaImage setUrl:[NSURL URLWithString:image_url]];
    [_cinemaImage showLoadingWheel];
    [[HJCache sharedInstance].hjObjManager manage:_cinemaImage];
    
    //get list movie-objects
    int cinemaId = (int)[_cinemaObject valueForKey:@"Id"];
    NSString *url = [NSString stringWithFormat:@"http://sgn-m.apphb.com/movie/cinema?cinemaid=%@",cinemaId]; 
    [self getListCinemas:url];
}

- (void) setPosterList 
{
    int count = [_movieObjects count];

    //create content size for scroll view
    CGRect frame = self.scrollView.frame;
    poster_width = (frame.size.width) / POSTERS_PER_PAGE;
    poster_height = (frame.size.height); 
    [_scrollView setContentSize:CGSizeMake(poster_width * count, poster_height)];

    //create poster for each movie
    for(NSInteger i = 0; i < count; i++)
    {
        frame.size.width = poster_width - POSTER_OFFSET_WIDTH * 2;
        frame.size.height = poster_height;
        
        //set for image
        frame.origin.x = 0.0f;
        frame.origin.y = 0.0f;
        NSString * urlString = [[NSString alloc] initWithString:[[_movieObjects objectAtIndex:i] 
                                                                 valueForKey:@"ImageUrl"]];
        
        HJManagedImageV *posterImage = [[HJManagedImageV alloc]initWithFrame:frame];
        [posterImage setUrl:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",PROVIDER_URL,urlString]]];
        [posterImage showLoadingWheel];
        [posterImage setImageContentMode:UIViewContentModeScaleToFill];
        [[HJCache sharedInstance].hjObjManager manage:posterImage];        
        
        //set for button
        frame.origin.x = poster_width * i + POSTER_OFFSET_WIDTH;
        frame.origin.y = 0.0f;
        int movieId = (int)[[_movieObjects objectAtIndex:i] valueForKey:@"Id"];
        UIButton *poster = [[UIButton alloc] initWithFrame:frame];
        [poster addTarget:self action:@selector(tapPoster:) forControlEvents:UIControlEventTouchUpInside];
        [poster setTag:movieId];
        [poster addSubview:posterImage];
        
        [_scrollView addSubview:poster];
    }
}

- (void) tapPoster:(UIButton*) sender
{
    NSLog(@"tag: %@", [sender tag]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" 
                                                    message:@"not figure"
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) getListCinemas:(NSString*)urlString
{
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [self setMovieObjects: (NSArray*) [JSON objectForKey:@"Data"]];
                                                                                            [self setPosterList];
                                                                                        } 
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
                                                                                        }
                                         ];
    [operation start];
}

- (IBAction)showMap:(id)sender {
    MapKitDisplayController * mapKitController = [[MapKitDisplayController alloc] initWithNibName:@"MapKitDisplayView" bundle:nil];
    [mapKitController setCinemaObject:_cinemaObject];
    [self.navigationController pushViewController:mapKitController animated:YES];
}
@end
