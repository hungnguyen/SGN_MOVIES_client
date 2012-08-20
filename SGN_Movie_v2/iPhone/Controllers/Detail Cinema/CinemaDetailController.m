//
//  DetaiCinemaController.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h> 
#import "CinemaDetailController.h"
#import "ShowtimesController.h"
#import "AFNetworking.h"
#import "MapKitDisplayController.h"
#import "Cinema.h"
#import "Movie.h"
#import "Sessiontime.h"
#import "DataService.h"
#import "Repository.h"
#import "AppDelegate.h"

//define width height of each poster in list view
#define POSTER_OFFSET_WIDTH 10
#define POSTERS_PER_PAGE 2

@interface CinemaDetailController ()
{
    int poster_width;
    int poster_height;
}
@property (strong, nonatomic) NSArray *movieObjects;
@property (strong, nonatomic) Cinema *cinemaObject;
@property (strong, nonatomic) NSString *cinemaWebId;
@end


@implementation CinemaDetailController

@synthesize cinemaObjectId = _cinemaObjectId;
@synthesize cinemaWebId = _cinemaWebId;
@synthesize movieObjects = _movieObjects;
@synthesize cinemaObject = _cinemaObject;
@synthesize cinemaImage = _cinemaImage;
@synthesize cinemaName =_cinemaName;
@synthesize cinemaPhone = _cinemaPhone;
@synthesize cinemaAddress = _cinemaAddress;
@synthesize cinemaView = _cinemaView;
@synthesize scrollView = _scrollView;

#pragma mark Initialization
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
    [self setTitle:@"DETAIL CINEMA"];

    //set round border
    [[_cinemaView layer] setMasksToBounds:YES];
    [[_cinemaView layer] setCornerRadius:10.0f];
    [[_cinemaImage layer] setMasksToBounds:YES];
    [[_cinemaImage layer] setCornerRadius:10.0f];
    
    [self setCinemaWebId:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    //[[Repository sharedInstance] setDelegate:self];
    [self reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self setMovieObjects:nil];
    [self setCinemaObject:nil];
    [self setCinemaWebId:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setCinemaImage:nil];
    [self setCinemaName:nil];
    [self setCinemaPhone:nil];
    [self setCinemaAddress:nil];
    [self setScrollView:nil];
    [self setCinemaView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Utils

- (void) loadPosterList 
{
    int count = [_movieObjects count];
    
    //create content size for scroll view
    CGRect frame = _scrollView.frame;
    
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
        Movie *movieObject = [_movieObjects objectAtIndex:i];
        NSString * urlString = [[NSString alloc] initWithString:[movieObject imageUrl]];
        
        HJManagedImageV *posterImage = [[HJManagedImageV alloc]initWithFrame:frame];
        [posterImage setUrl:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",PROVIDER_URL,urlString]]];
        [posterImage showLoadingWheel];
        [posterImage setImageContentMode:UIViewContentModeScaleToFill];
        [[HJCache sharedInstance].hjObjManager manage:posterImage];        
        
        //set for button
        frame.origin.x = poster_width * i + POSTER_OFFSET_WIDTH;
        frame.origin.y = 0.0f;
        //int movieId = (int)[[_movieObjects objectAtIndex:i] valueForKey:@"Id"];
        UIButton *poster = [[UIButton alloc] initWithFrame:frame];
        [poster addTarget:self action:@selector(tapPoster:) forControlEvents:UIControlEventTouchUpInside];
        [poster setTag:i];
        [poster addSubview:posterImage];
        
        [_scrollView addSubview:poster];
    }
}

- (void)reloadView
{
    NSString *image_url = [NSString stringWithFormat:@"http://www.galaxycine.vn%@", [_cinemaObject imageUrl]];
    [_cinemaName setText:[_cinemaObject name]];
    [_cinemaPhone setText:[_cinemaObject phone]];
    [_cinemaAddress setText:[_cinemaObject address]];
    [_cinemaImage clear];
    [_cinemaImage setUrl:[NSURL URLWithString:image_url]];
    [_cinemaImage showLoadingWheel];
    [[HJCache sharedInstance].hjObjManager manage:_cinemaImage];
    
    //reload Data for list poster movies
    [self loadPosterList];
}

#pragma mark Action

- (IBAction)showTicket:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ticket" 
                                                    message:@"feature in next release" 
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    [alert show];
}

- (IBAction)showMap:(id)sender {
    MapKitDisplayController * mapKitController = [[MapKitDisplayController alloc] initWithNibName:@"MapKitDisplayView" bundle:nil];
    [mapKitController setCinemaObject:_cinemaObject];
    [[self navigationController] pushViewController:mapKitController animated:YES];
}

- (void) tapPoster:(UIButton*) sender
{
    ShowtimesController *showtimesController = [[ShowtimesController alloc] initWithNibName:@"ShowTimesView" 
                                                                                     bundle:nil];
    [showtimesController setCinemaObjectId:[_cinemaObject cinemaId].intValue];
    Movie *movie = [_movieObjects objectAtIndex:[sender tag]];
    [showtimesController setMovieObjectId:[movie movieId].intValue];
    [[self navigationController]pushViewController:showtimesController animated:YES];
}

#pragma mark CoreData

//get data from server, in case data was not exist, show alert view and rollback to root view
- (void)reloadData
{
    NSLog(@"RELOAD DATA");
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];

    [self setCinemaObject:[Cinema selectByCinemaId:_cinemaObjectId context:context]];
    if(_cinemaObject == nil 
       || (_cinemaWebId != nil && ![_cinemaWebId isEqualToString:[_cinemaObject cinemaWebId]]))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update Data" 
                                                        message:@"New Data was updated" 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSArray *movieIds = [Sessiontime selectMovieIdsByCinemaId:[_cinemaObject cinemaId].intValue context:context];
    [self setMovieObjects:[Movie selectByArrayIds:[movieIds valueForKey:@"movieId"] context:context]];
    [self reloadView];
}

#pragma mark UIAlertViewDelegate

//after click on alert notice "data were updated"
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[AppDelegate currentDelegate].navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark SGNRepositoryDelegate

- (void)RepositoryStartUpdate:(Repository *)repository
{
    NSLog(@"DELEGATE START");
    
}

- (void)RepositoryFinishUpdate:(Repository *)repository
{
    if([repository isUpdateMovie] == YES || [repository isUpdateCinema] == YES)
        [self reloadData];
    NSLog(@"DELEGATE FINISH");
}

@end
