//
//  MovieDetailController.m
//  SGN_Movie_v2
//
//  Created by vnicon on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieDetailController.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>  
#import <AVFoundation/AVBase.h>
#import <AVFoundation/AVAnimation.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerLayer.h>
#import "LBYouTubePlayerViewController.h"
#import "AFNetworking.h"
#import "ShowtimesController.h"
#import "Sessiontime.h"

#define CELL_WIDTH 320
#define CELL_HEIGHT 60
#define TABLEVIEW_Ypos 293

#define ImageX -39
#define ImageY 43
#define ImageWidth 200
#define ImageHeight  190

@interface MovieDetailController ()

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) int fontSize;
@property (strong, nonatomic) NSString *fontName;
@property (strong, nonatomic) Movie * movieInfo;
@property (assign, nonatomic) int countCinemas;
@end

@implementation MovieDetailController
@synthesize scrollView = _scrollView;
@synthesize showTimeButton = _showTimeButton;
@synthesize trailerButton = _trailerButton;
@synthesize movieInfo = _movieInfo;
@synthesize textView = _textView;
@synthesize tableView = _tableView;
@synthesize fontName = _fontName;
@synthesize fontSize = _fontSize;
@synthesize popupView = _popupView;
@synthesize maskView = _maskView;
@synthesize movieObjectId = _movieObjectId;
@synthesize countCinemas = _countCinemas;

#pragma mark - Init

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
    
    [self showLastUpdateOnNavigationBarWithTitle:@"MOVIE DETAIL"];
    [self setFontSize:14];
    [self setFontName:@"Arial-BoldMT"];
    
    [_trailerButton setTitle:@"TRAILER" forState:UIControlStateNormal];
    [_showTimeButton setTitle:@"SHOWTIME" forState:UIControlStateNormal];
    
    
    [_tableView setFrame:CGRectMake(0, TABLEVIEW_Ypos, CELL_WIDTH, CELL_HEIGHT*5 + 300)];
    [_scrollView setContentSize:CGSizeMake(320, TABLEVIEW_Ypos + (CELL_HEIGHT*5 + 300))];
    [_scrollView setBounces:NO];
    
    [self setPopupView:[[SGNCustomPopup alloc] initWithNibName:@"SGNCustomPopup"]];
    [_popupView setDelegate:self];
    [[_popupView title] setText:@"SELECT CINEMA"];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removePopup)];
    [tapGR setNumberOfTapsRequired:1];
    [_maskView addGestureRecognizer:tapGR];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self reloadView];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self setMovieInfo:nil];
    [_popupView loadViewWithData:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setTrailerButton:nil];
    [self setShowTimeButton:nil];
    [self setScrollView:nil];
    [self setTextView:nil];
    [self setTableView:nil];
    [self setPopupView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - actions 

- (IBAction)showTrailer:(id)sender 
{
    //Create a view to play trailer    
    TrailerController * trailerController = [[TrailerController alloc] initWithNibName:@"TrailerView" bundle:nil];
    NSString * trailerUrl = [[NSString alloc] initWithFormat:@"%@",[_movieInfo trailerUrl]];
    [trailerController createYouTubePlayer:[NSURL URLWithString:trailerUrl]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Back" 
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    [self.navigationController pushViewController:trailerController animated:YES];
}

- (IBAction)showShowTime:(id)sender 
{
    if(_countCinemas > 0)
    {
        [[self view] addSubview:_maskView];
        [[self view] addSubview:_popupView];
        [_popupView popUp];
    }
    else 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Sorry, there is no cinema show this movie" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)removePopup
{
    [_maskView removeFromSuperview];
    [_popupView popDown:nil];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath{
    
    if(5 == indexPath.row)
        return 300.0f;
    return CELL_HEIGHT;
}

-(UITextView *) modifyTextViewOfACell:(UITextView *) cellTextView withText:(NSString *) text
{
    [cellTextView setText:text];
    [cellTextView setFont:[UIFont fontWithName:_fontName size:_fontSize]];
    [cellTextView setEditable:NO];
    [cellTextView setBackgroundColor:[UIColor clearColor]];
    [cellTextView setScrollEnabled:NO];
    
    return cellTextView;
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    
    // Configure the cell...
    if(0 == indexPath.row)
    {
        NSString * genreStr = [[NSString alloc] initWithFormat:@"GENRE: %@",[_movieInfo genre]];
        UITextView * cellTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT)];
        
        [cell addSubview:[self modifyTextViewOfACell:cellTextView withText:genreStr]];
        
    }
    if(1 == indexPath.row)
    {
        NSString * castStr = [[NSString alloc] initWithFormat:@"DIRECTOR: %@",[_movieInfo director]];
        UITextView * cellTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT)];
        
        [cell addSubview:[self modifyTextViewOfACell:cellTextView withText:castStr]];
    }
    if(2 == indexPath.row)
    {
        NSString * castStr = [[NSString alloc] initWithFormat:@"CAST: %@",[_movieInfo cast]];
        UITextView * cellTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT)];
        
        [cell addSubview:[self modifyTextViewOfACell:cellTextView withText:castStr]];
    }
    if(3 == indexPath.row)
    {
        NSString * durationStr = [[NSString alloc] initWithFormat:@"DURATION: %@",[_movieInfo duration]];
        UITextView * cellTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT)];
        
        [cell addSubview:[self modifyTextViewOfACell:cellTextView withText:durationStr]];
    }
    if(4 == indexPath.row)
    {
        NSString * versionStr = [[NSString alloc] initWithFormat:@"VERSION: %@",[_movieInfo version]];
        UITextView * cellTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT)];
        
        [cell addSubview:[self modifyTextViewOfACell:cellTextView withText:versionStr]];
    }
    if(5 == indexPath.row)
    {
        NSString * descriptionStr = [[NSString alloc] initWithFormat:@"%@",[_movieInfo movieDescription]];
        UITextView * cellTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, 300)];
        
        [cell addSubview:[self modifyTextViewOfACell:cellTextView withText:descriptionStr]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
}

#pragma mark SGNCustomPopupDelegate

- (void)SGNCustomPopupTap:(SGNCustomPopup*)customPopup withObject:(id)object
{
    [_maskView removeFromSuperview];
    ShowtimesController *showtimesController = [[ShowtimesController alloc] initWithNibName:@"ShowTimesView" 
                                                                                     bundle:nil];
    Cinema *cinema = (Cinema*)object;
    [showtimesController setCinemaObjectId:[cinema cinemaId].intValue];
    [showtimesController setMovieObjectId:[_movieInfo movieId].intValue];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Back" 
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    [[self navigationController]pushViewController:showtimesController animated:YES];
}

#pragma mark ReloadView
-(void) reloadView
{
    NSLog(@"RELOAD DATA");
    [self showLastUpdateOnNavigationBarWithTitle:@"MOVIE DETAIL"];
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    _movieInfo = [Movie selectByMovieId:_movieObjectId context:context];
    
    NSArray *cinemaIds = [Sessiontime selectCinemaIdsByMovieId:[_movieInfo movieId].intValue context:context];
    NSArray *cinemaObjects = [Cinema selectByArrayIds:[cinemaIds valueForKey:@"cinemaId"] context:context];
    [self setCountCinemas:[cinemaIds count]];
    [_popupView loadViewWithData:cinemaObjects];
    if(_movieInfo != nil)
    {
        NSString *hostUrl = [[[[AppDelegate currentDelegate] rightMenuController] provider] hostUrl];
        NSString *urlString = [hostUrl stringByAppendingString:[_movieInfo imageUrl]];
        SGNManagedImage * asynchcImage = [[SGNManagedImage alloc] initWithFrame:CGRectMake(ImageX,ImageY,ImageWidth,ImageHeight)];
        [asynchcImage setUrl:[NSURL URLWithString:urlString]];
        [asynchcImage setImageContentMode:UIViewContentModeScaleToFill];
        [asynchcImage showLoadingWheel];
        
        //Remove old HJManageImageV
        UIView * subview = [[_scrollView subviews] objectAtIndex:4];
        {
            [subview removeFromSuperview];
        }
        
        [self.scrollView addSubview:asynchcImage];
        [[HJCache sharedInstance].hjObjManager manage:asynchcImage];
        
        [_trailerButton setTitle:@"TRAILER" forState:UIControlStateNormal];
        [_showTimeButton setTitle:@"SHOWTIME" forState:UIControlStateNormal];
        
        [_textView setText:[_movieInfo valueForKey:@"Title"]];
        [_textView setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20.f]];
        [_textView setEditable:NO];
        [_textView setScrollEnabled:NO];
        
        [_tableView reloadData];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update Data" 
                                                        message:@"New Data was updated" 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
        
    }
    
}

#pragma mark SGNRepositoryDelegate

- (void)RepositoryStartUpdate:(Repository *)repository
{
    NSLog(@"DELEGATE START");
}

- (void)RepositoryFinishUpdate:(Repository *)repository
{
    if([Repository sharedInstance].isUpdateMovie == YES)
        [self reloadView];
    NSLog(@"DELEGATE FINISH");
}

#pragma mark UIAlertViewDelegate

//after click on alert notice "data were updated"
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(_movieInfo == nil)
    {
        [[AppDelegate currentDelegate].navigationController popToRootViewControllerAnimated:YES];
    }
    
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
