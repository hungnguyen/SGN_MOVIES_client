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

#define CELL_WIDTH 320
#define CELL_HEIGHT 60
#define TABLEVIEW_Ypos 293

@interface MovieDetailController ()
{
    int fonSize;
    NSString * fontName;
}
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MovieDetailController
@synthesize scrollView = _scrollView;
@synthesize showTimeButton = _showTimeButton;
@synthesize trailerButton = _trailerButton;
@synthesize movieInfo = _movieInfo;
@synthesize textView = _textView;
@synthesize tableView = _tableView;


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
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"MOVIE DETAIL"];
    fonSize = 14;
    fontName = @"Arial-BoldMT";
    
    NSString * urlString = [[NSString alloc] initWithString:[_movieInfo valueForKey:@"ImageUrl"]];
    HJManagedImageV * asynchcImage = [[HJManagedImageV alloc] initWithFrame:CGRectMake(-39,43,200,190)];
    [asynchcImage setUrl:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",PROVIDER_URL,urlString]]];
    [asynchcImage showLoadingWheel];
    [self.scrollView addSubview:asynchcImage];
    [[HJCache sharedInstance].hjObjManager manage:asynchcImage];
    
    [_trailerButton setTitle:@"TRAILER" forState:UIControlStateNormal];
    [_showTimeButton setTitle:@"SHOWTIME" forState:UIControlStateNormal];
    
    [_textView setText:[_movieInfo valueForKey:@"Title"]];
    [_textView setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20.f]];
    [_textView setEditable:NO];
    
    [_tableView setFrame:CGRectMake(0, TABLEVIEW_Ypos, CELL_WIDTH, CELL_HEIGHT*4 + 250)];
    [_scrollView setContentSize:CGSizeMake(320, TABLEVIEW_Ypos + (CELL_HEIGHT*4 + 250))];
    [_scrollView setBounces:NO];
}

- (void)viewDidUnload
{
    
    [self setTrailerButton:nil];
    [self setShowTimeButton:nil];
    [self setScrollView:nil];
    [self setTextView:nil];
    [self setTableView:nil];
    [self setMovieInfo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - actions of buttons

- (IBAction)showTrailer:(id)sender 
{
    //Create a view to play trailer    
    TrailerController * trailerController = [[TrailerController alloc] initWithNibName:@"TrailerView" bundle:nil];
    NSString * trailerUrl = [[NSString alloc] initWithFormat:@"%@",[_movieInfo valueForKey:@"TrailerUrl"]];
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
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

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
        NSString * genreStr = [[NSString alloc] initWithFormat:@"GENRE: %@",[_movieInfo valueForKey:@"Genre"]];
        UITextView * cellTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT)];
        
        [cell addSubview:[self modifyTextViewOfACell:cellTextView withText:genreStr]];
        
    }
    if(1 == indexPath.row)
    {
        NSString * castStr = [[NSString alloc] initWithFormat:@"CAST: %@",[_movieInfo valueForKey:@"Cast"]];
        UITextView * cellTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT)];
        
        [cell addSubview:[self modifyTextViewOfACell:cellTextView withText:castStr]];
    }
    if(2 == indexPath.row)
    {
        NSString * durationStr = [[NSString alloc] initWithFormat:@"DURATION: %@",[_movieInfo valueForKey:@"Duration"]];
        UITextView * cellTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT)];
        
        [cell addSubview:[self modifyTextViewOfACell:cellTextView withText:durationStr]];
    }
    if(3 == indexPath.row)
    {
        NSString * versionStr = [[NSString alloc] initWithFormat:@"VERSION: %@",[_movieInfo valueForKey:@"Version"]];
        UITextView * cellTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT)];
        
        [cell addSubview:[self modifyTextViewOfACell:cellTextView withText:versionStr]];
    }
    if(4 == indexPath.row)
    {
        NSString * descriptionStr = [[NSString alloc] initWithFormat:@"%@",[_movieInfo valueForKey:@"Description"]];
        UITextView * cellTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, 250)];
        
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
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath{
    
    if(4 == indexPath.row)
        return 250.0f;
    return CELL_HEIGHT;
}

-(UITextView *) modifyTextViewOfACell:(UITextView *) cellTextView withText:(NSString *) text
{
    cellTextView.text = text;
    [cellTextView setFont:[UIFont fontWithName:fontName size:fonSize]];
    [cellTextView setEditable:NO];
    [cellTextView setBackgroundColor:[UIColor clearColor]];
    [cellTextView setScrollEnabled:NO];
    
    return cellTextView;
}

@end
