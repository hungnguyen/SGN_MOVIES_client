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

#define CELL_WIDTH 320
#define CELL_HEIGHT 60
#define TABLEVIEW_Ypos 293

@interface MovieDetailController ()
{
    int fonSize;
    NSString * fontName;
}

@end

@implementation MovieDetailController
@synthesize scrollView = _scrollView;
@synthesize showTimeButton = _showTimeButton;
@synthesize trailerButton = _trailerButton;
@synthesize tableView = _tableView;
@synthesize movieInfo = _movieInfo;
@synthesize textView = _textView;


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
    [[HJCache getHJObjManager] manage:asynchcImage];
        
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)showTrailer:(id)sender 
{
    /*NSString * filepath = [[NSString alloc] initWithFormat:@"%@",[_movieInfo valueForKey:@"TrailerUrl"]];
    NSURL * url = [NSURL fileURLWithPath:filepath];
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [moviePlayer.view setFrame:self.view.bounds];
    moviePlayer.useApplicationAudioSession=YES;
    [self.view addSubview:moviePlayer.view];    
    [moviePlayer play];*/
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
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
        UITextView * textView1 = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT)];
        textView1.text = genreStr;
        [textView1 setFont:[UIFont fontWithName:fontName size:fonSize]];
        [textView1 setEditable:NO];
        [textView1 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:textView1];

    }
    if(1 == indexPath.row)
    {
        NSString * castStr = [[NSString alloc] initWithFormat:@"CAST: %@",[_movieInfo valueForKey:@"Cast"]];
        UITextView * textView1 = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT)];
        textView1.text = castStr;
        [textView1 setFont:[UIFont fontWithName:fontName size:fonSize]];
        [textView1 setEditable:NO];
        [textView1 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:textView1];
    }
    if(2 == indexPath.row)
    {
        NSString * durationStr = [[NSString alloc] initWithFormat:@"DURATION: %@",[_movieInfo valueForKey:@"Duration"]];
        UITextView * textView1 = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT)];
        textView1.text = durationStr;
        [textView1 setFont:[UIFont fontWithName:fontName size:fonSize]];
        [textView1 setEditable:NO];
        [textView1 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:textView1];
    }
    if(3 == indexPath.row)
    {
        NSString * versionStr = [[NSString alloc] initWithFormat:@"VERSION: %@",[_movieInfo valueForKey:@"Version"]];
        UITextView * textView1 = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT)];
        textView1.text = versionStr;
        [textView1 setFont:[UIFont fontWithName:fontName size:fonSize]];
        [textView1 setEditable:NO];
        [textView1 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:textView1];
    }
    if(4 == indexPath.row)
    {
        NSString * descriptionStr = [[NSString alloc] initWithFormat:@"%@",[_movieInfo valueForKey:@"Description"]];
        UITextView * cellTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, 250)];
        cellTextView.text = descriptionStr;
        [cellTextView setFont:[UIFont fontWithName:fontName size:fonSize]];
        [cellTextView setEditable:NO];
        [cellTextView setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:cellTextView];
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



@end
