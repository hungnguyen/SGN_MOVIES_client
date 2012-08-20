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
#import "AFNetworking.h"
#import "Cinema.h"
#import "Movie.h"
#import "DataService.h"
#import "Sessiontime.h"
#import "AppDelegate.h"

@interface ShowtimesController ()

@property (strong, nonatomic) NSMutableArray *showtimesObjects;
@property (strong, nonatomic) Cinema *cinemaObject;
@property (strong, nonatomic) Movie *movieObject;
@property (strong, nonatomic) NSString *cinemaWebId;
@property (strong, nonatomic) NSString *movieWebId;

@end

@implementation ShowtimesController

@synthesize comboView = _comboView;
@synthesize cinemaObjectId = _cinemaObjectId;
@synthesize movieObjectId = _movieObjectId;
@synthesize movieObject = _movieObject;
@synthesize cinemaObject = _cinemaObject;
@synthesize movieWebId = _movieWebId;
@synthesize cinemaWebId = _cinemaWebId;
@synthesize tableView = _tableView;
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
    [self setTitle:@"SHOWTIMES"];
    [_tableView setRowHeight:60];
    
    [self setCinemaWebId:nil];
    [self setMovieWebId:nil];
    [self updateData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self reloadData];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self setMovieObject:nil];
    [self setCinemaObject:nil];
    [self setShowtimesObjects:nil];
    [self setCinemaWebId:nil];
    [self setMovieWebId:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setTableView:nil];
    [self setComboView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableViewDataSource

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

#pragma mark UITableViewDelegate

- (UITableViewCell*)tableView:(UITableView*)objTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [objTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary *showtime = (NSDictionary*)[_showtimesObjects objectAtIndex:[indexPath row]];
   // [[cell textLabel]setText:[showtime objectForKey:@"Date"]];
   // [[cell detailTextLabel]setText:[showtime objectForKey:@"Time"]];
    UITextView * cellTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    UITextView * cellDetailTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 30, 320, 60)];
    
    //Add text view for Date
    [cellTextView setText:[showtime objectForKey:@"Date"]];
    [cellTextView setFont:[UIFont boldSystemFontOfSize:19]];
    [cellTextView setEditable:NO];
    [cellTextView setScrollEnabled:NO];
    [cell addSubview:cellTextView];
    
    //Add text view for Time
    [cellDetailTextView setText:[showtime objectForKey:@"Time"]];
    [cellDetailTextView setFont:[UIFont fontWithName:@"Times New Roman" size:19]];
    [cellDetailTextView setEditable:NO];
    [cellDetailTextView setScrollEnabled:NO];
    [cell addSubview:cellDetailTextView];

    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath{
    
  //  if(5 == indexPath.row)
        return 91;
   
}


#pragma mark Utils

//create showtimes format to show in view 
- (void)createShowtimes:(NSArray*)data
{
    self.showtimesObjects = [[NSMutableArray alloc]init];
    NSString *date = @"";
    NSString *time = @"";
    NSString *curDate = @"";
    for (NSInteger i = 0; i < [data count]; ++i) 
    {
        Sessiontime *item = [data objectAtIndex:i];
        curDate = [item date];
        if([date isEqualToString: @""] == YES)
        {
            date = curDate;
            time = [item time];
        }
        else if([date isEqualToString:curDate] == YES)
        {
            time  = [NSString stringWithFormat:@"%@ | %@", time,[item time]];
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

- (void)reloadView
{
    [_tableView reloadData];
    [_comboView fillWithCinema:_cinemaObject andMovie:_movieObject];
}
#pragma mark CoreData

//get data from db, in case data was not exist in db or not map with data on view, show alert and rollback to root view
- (void)reloadData
{
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    [self setCinemaObject:[Cinema selectByCinemaId:_cinemaObjectId context:context]];
    [self setMovieObject:[Movie selectByMovieId:_movieObjectId context:context]];
    if(_cinemaObject == nil || _movieObject == nil 
       || (_cinemaWebId != nil && ![_cinemaWebId isEqualToString:[_cinemaObject cinemaWebId]])
       || (_movieWebId != nil && ![_movieWebId isEqualToString:[_movieObject movieWebId]]))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update Data" 
                                                        message:@"New Data was updated" 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    //add webid to compare in next time reload
    [self setCinemaWebId:[_cinemaObject cinemaWebId]];
    [self setMovieWebId:[_movieObject movieWebId]];
    
    NSArray *items = [Sessiontime selectByMovieId:_movieObjectId cinemaId:_cinemaObjectId context:context];
    [self createShowtimes:items];
    
    [self reloadView];
}

//update new data from server
- (void)updateData
{
    [[Repository sharedInstance]updateEntityWithUrlString:UPDATE_ALL_URL];
}

#pragma mark SGNRepositoryDelegate

- (void)RepositoryStartUpdate:(Repository *)repository
{
    NSLog(@"DELEGATE START");
}

- (void)RepositoryFinishUpdate:(Repository *)repository
{
    if([repository isUpdateCinema] == YES || [repository isUpdateMovie] == YES || [repository isUpdateSessiontime] == YES)
        [self reloadData];
    NSLog(@"DELEGATE FINISH");
}

#pragma mark UIAlertViewDelegate

//after click on alert notice "data were updated"
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[AppDelegate currentDelegate].navigationController popToRootViewControllerAnimated:YES];
    
}

@end
