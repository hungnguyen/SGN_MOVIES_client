//
//  ShowTimesController.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h> 
#import "ShowtimesController.h"
#import "HJCache.h"
#import "SGNCinemaMovieCell.h"
#import "AFNetworking.h"

@interface ShowtimesController ()

@property (strong, nonatomic) NSMutableArray *showtimesObjects;
- (void)CreateShowtimesFromJSON:(NSArray*)data;

@end

@implementation ShowtimesController

@synthesize cinemaObject = _cinemaObject;
@synthesize movieObject = _movieObject;
@synthesize buttonCinemaMovie = _buttonCinemaMovie;
@synthesize tableViewShowtimes = _tableViewShowtimes;
@synthesize showtimesObjects = _showtimesObjects;

#pragma mark Init
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
    
    CGRect rect = _buttonCinemaMovie.bounds;
    SGNCinemaMovieCell *cinemaMovieButton = [[SGNCinemaMovieCell alloc]initWithFrame:rect];
    [cinemaMovieButton fillWithCinema:_cinemaObject andMovie:_movieObject];
    cinemaMovieButton.userInteractionEnabled = NO;
    [_buttonCinemaMovie addSubview:cinemaMovieButton];
    [_tableViewShowtimes setRowHeight:60];
    
    int cinemaId = (int)[_cinemaObject valueForKey:@"Id"];
    int movieId = (int)[_movieObject valueForKey:@"Id"];
    NSString *url = [NSString stringWithFormat:@"http://sgn-m.apphb.com/session/list?cinemaid=%@&movieid=%@",cinemaId, movieId]; 
    [self getShowtimesFromUrl:url];
    
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

#pragma mark Manage Tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_showtimesObjects && [_showtimesObjects count]) 
    {
        return [_showtimesObjects count];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView*)objTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [objTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary *showtime = (NSDictionary*)[_showtimesObjects objectAtIndex:[indexPath row]];
    [[cell textLabel]setText:[showtime objectForKey:@"Date"]];
    [[cell detailTextLabel]setText:[showtime objectForKey:@"Time"]];
    
    return cell;
}

#pragma mark Action

- (IBAction)setCinemaMovie:(id)sender 
{
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"set data" message:@"set movie cinema" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

#pragma mark JSON

- (void)getShowtimesFromUrl:(NSString*)urlString
{
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [self CreateShowtimesFromJSON:(NSArray*) [JSON objectForKey:@"Data"]];
                                                                                            [_tableViewShowtimes reloadData];
                                                                                        } 
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Request Failed with Error: %@, %@", error, [error userInfo]);
                                                                                        }
                                         ];
    [operation start];

}

- (void)CreateShowtimesFromJSON:(NSArray*)data
{
    self.showtimesObjects = [[NSMutableArray alloc]init];
    NSString *date = @"";
    NSString *time = @"";
    NSString *curDate = @"";
    for (NSInteger i = 0; i < [data count]; ++i) 
    {
        curDate = [[data objectAtIndex:i] objectForKey:@"Date"];
        if([date isEqualToString: @""] == YES)
        {
            date = curDate;
            time = [[data objectAtIndex:i] objectForKey:@"Time"];
        }
        else if([date isEqualToString:curDate] == YES)
        {
            time  = [NSString stringWithFormat:@"%@ | %@", time,[[data objectAtIndex:i] objectForKey:@"Time"]];
        }
        else
        {
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys: date, @"Date", time, @"Time", nil];
            [_showtimesObjects addObject:dict];
            date = @"";
            time = @"";
        }
    }
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys: date, @"Date", time, @"Time", nil];
    [_showtimesObjects addObject:dict];
}

@end
