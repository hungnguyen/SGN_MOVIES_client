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
#import "CinemaGalleryController.h"
#import "Sessiontime.h"
#import "DataService.h"
#import "Repository.h"
#import "AppDelegate.h"
#import "HJCache.h"

@interface CinemaDetailController ()
@property (strong, nonatomic) Cinema *cinemaObject;
@property (strong, nonatomic) NSString *cinemaWebId;
@end


@implementation CinemaDetailController

@synthesize popupView = _popupView;
@synthesize cinemaObjectId = _cinemaObjectId;
@synthesize cinemaWebId = _cinemaWebId;
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
    [self showLastUpdateOnNavigationBarWithTitle:@"CINEMA DETAIL"];
    
    //set round border
    [[_cinemaView layer] setMasksToBounds:YES];
    [[_cinemaView layer] setCornerRadius:10.0f];
    [[_cinemaImage layer] setMasksToBounds:YES];
    [[_cinemaImage layer] setCornerRadius:10.0f];
    
    [self setCinemaWebId:nil];
    [self setPopupView:[[SGNCustomPopup alloc] initWithNibName:@"SGNCustomPopup"]];
    [_popupView setDelegate:self];
    //[[_popupView title] setText:@"SELECT MOVIES"];
}

- (void)viewDidAppear:(BOOL)animated
{
    //[[Repository sharedInstance] setDelegate:self];
    [self reloadData];
    [[self view] addSubview:_popupView];
    [_popupView popUp];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //[_popupView loadViewWithData:nil];
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
    [self setPopupView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Utils

- (void)reloadView
{
    NSString *hostUrl = [[[[AppDelegate currentDelegate] rightMenuController] provider] hostUrl];
    NSString *image_url = [hostUrl stringByAppendingString:[_cinemaObject imageUrl]];
    [_cinemaName setText:[_cinemaObject name]];
    [_cinemaPhone setText:[_cinemaObject phone]];
    [_cinemaAddress setText:[_cinemaObject address]];
    [_cinemaImage clear];
    [_cinemaImage setUrl:[NSURL URLWithString:image_url]];
    [_cinemaImage showLoadingWheel];
    [[HJCache sharedInstance].hjObjManager manage:_cinemaImage];
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
    [mapKitController setCinemaName:[_cinemaObject name]];
    [mapKitController setCinemaAddress:[_cinemaObject address]];
    [mapKitController setLatitude:[_cinemaObject latitude]];
    [mapKitController setLongitude:[_cinemaObject longitude]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Back" 
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    [[self navigationController] pushViewController:mapKitController animated:YES];
}

- (IBAction)showGallery:(id)sender
{
    
    CinemaGalleryController *cinemaGalleryController = [[CinemaGalleryController alloc] initWithNibName:@"CinemaGalleryView" 
                                                                                              bundle:nil];
    cinemaGalleryController.cinemaObjectId = _cinemaObjectId;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Back" 
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    [self.navigationController pushViewController:cinemaGalleryController animated:YES];
}

#pragma mark CoreData

//get data from server, in case data was not exist, show alert view and rollback to root view
- (void)reloadData
{
    NSLog(@"RELOAD DATA");
    [self showLastUpdateOnNavigationBarWithTitle:@"CINEMA DETAIL"];
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
    NSArray *movieObject = [Movie selectByArrayIds:[movieIds valueForKey:@"movieId"] context:context];
    
    //reload Data for list poster movies
   // [_popupView loadViewWithData:movieObject];
    [_popupView carousel].type = iCarouselTypeRotary;
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

#pragma mark SGNCustomPopupDelegate

- (void)SGNCustomPopupTap:(SGNCustomPopup*)customPopup withObject:(id)object
{
    ShowtimesController *showtimesController = [[ShowtimesController alloc] initWithNibName:@"ShowTimesView" 
                                                                                     bundle:nil];
    [showtimesController setCinemaObjectId:[_cinemaObject cinemaId].intValue];
    Movie *movie = (Movie*)object;
    [showtimesController setMovieObjectId:[movie movieId].intValue];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Back" 
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    [[self navigationController]pushViewController:showtimesController animated:YES];
}
#pragma mark showLastUpdate
-(void) showLastUpdateOnNavigationBarWithTitle:(NSString*) title
{
    NSString * lastUpdateStr = [[Repository sharedInstance] readLastUpdated];
    lastUpdateStr = [lastUpdateStr stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    lastUpdateStr = [lastUpdateStr stringByReplacingOccurrencesOfString:@"." withString:@":"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont boldSystemFontOfSize: 13.0f];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%@\nlast update:%@",title,lastUpdateStr];
    [self.navigationItem setTitleView:label];
    
}
@end
