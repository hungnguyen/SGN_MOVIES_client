//
//  ShowTimesController.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "AppDelegate.h"
#import "ShowtimesController.h"

#import "SGNDataService.h"
#import "Sessiontime.h"
#import "Cinema.h"
#import "Movie.h"

#import "SGNTableViewCellStyleSubtitle.h"

@interface ShowtimesController () 

@property (strong, nonatomic) NSMutableArray *showtimesObjects;
@property (strong, nonatomic) Cinema *cinemaObject;
@property (strong, nonatomic) Movie *movieObject;
@property (strong, nonatomic) NSString *cinemaWebId;
@property (strong, nonatomic) NSString *movieWebId;
@property (nonatomic, assign) bool isFirstLoad;

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
@synthesize isFirstLoad = _isFirstLoad;

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
    self.isFirstLoad = true;
    self.cinemaWebId = nil;
    self.movieWebId = nil;
    
    _tableView.sectionFooterHeight = TABLE_SECTION_FOOTER_HEIGHT;
    _tableView.sectionHeaderHeight = TABLE_SECTION_HEADER_HEIGHT;
    
    [[SGNRepository sharedInstance]updateEntityWithUrlString:UPDATE_ALL_URL];
}

- (void) viewWillAppear:(BOOL)animated
{
    if(_isFirstLoad == true)
    {
        [self reloadInputViews];
        self.isFirstLoad = false;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.comboView = nil;
    self.movieObject = nil;
    self.cinemaObject = nil;
    self.tableView = nil;
    self.showtimesObjects = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)reloadInputViews
{
    NSLog(@"SHOWTIME - TABLE RELOAD");
    
    NSManagedObjectContext *context = [SGNDataService defaultContext];
    [self setCinemaObject:[Cinema selectByCinemaId:_cinemaObjectId context:context]];
    [self setMovieObject:[Movie selectByMovieId:_movieObjectId context:context]];
    
    //check if has new data
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
    
    [_tableView reloadData];
    [_comboView fillWithCinema:_cinemaObject andMovie:_movieObject];
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
        return [_showtimesObjects count] * 2;
    }
    else
    {
        return 0;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    if(indexPath.row % 2 != 0)
    {
        //cell uses like 'section'
        return TABLE_SECTION_FOOTER_HEIGHT;
    }
    else
    {
        //normal cell
        return TABLE_CELLSUBTITLE_HEIGHT;
    }
}

#pragma mark UITableViewDelegate

- (UITableViewCell*)tableView:(UITableView*)objTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SGNTableViewCellStyleSubtitle";
    static NSString *cellStyleSection = @"UITableViewCell";
    
    if(indexPath.row % 2 == 0)
    {
        SGNTableViewCellStyleSubtitle *cell = [objTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) 
        {
            cell = [[SGNTableViewCellStyleSubtitle alloc] initWithNibName:cellIdentifier];
        }
        NSArray *dateTime = [_showtimesObjects objectAtIndex:indexPath.row / 2];
        NSString *date = [dateTime objectAtIndex:0];
        NSString *time = [dateTime objectAtIndex:1];
        
        cell.titleLabel.text = date;
        cell.contentLabel.text = time;
        return cell;
    }
    else 
    {
        UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellStyleSection];
        if(cell ==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStyleSection];
            cell.contentView.backgroundColor = [UIColor blackColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Utils 

//create showtimes format to show in view 
- (void)createShowtimes:(NSArray*)data
{
    self.showtimesObjects = [[NSMutableArray alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    //format for getting Date
    NSDateFormatter *formatterDate = [[NSDateFormatter alloc] init];    
    [formatterDate setTimeZone:[NSTimeZone defaultTimeZone]];
    [formatterDate setDateFormat:@"dd.MM.yyyy"];
    
    //format for getting Time
    NSDateFormatter *formatterTime = [[NSDateFormatter alloc] init];    
    [formatterTime setTimeZone:[NSTimeZone defaultTimeZone]];
    [formatterTime setDateFormat:@"HH.mm"];
    
    NSString *date = @"";
    NSString *time = @"";
    
    for(NSInteger i = 0; i < [data count]; i++)
    {
        Sessiontime *item = [data objectAtIndex:i];
        date = [formatterDate stringFromDate:[item date]];
        time = [formatterTime stringFromDate:[item date]];
        
        //if current date is contain in dictionary
        if([dict objectForKey:date])
        {
            //insert new time
            NSString *curTime = (NSString*)[dict valueForKey:date];
            curTime = [NSString stringWithFormat:@"%@ | %@", curTime, time];
            [dict setValue:curTime forKey:date];
        }
        else 
        {
            //insert new date + time
            [dict setObject:time forKey:date];
        }
    }
    
    //sort _showtimeObject base on date
    NSArray *sortedKeys = [[dict allKeys] sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)];
    for (NSString *key in sortedKeys)
        [_showtimesObjects addObject:[NSArray arrayWithObjects:key, [dict valueForKey:key], nil]];
}

#pragma mark SGNRepositoryDelegate

- (void)RepositoryStartUpdate:(SGNRepository *)repository
{
    NSLog(@"SHOWTIME - DELEGATE START");
}

- (void)RepositoryFinishUpdate:(SGNRepository *)repository
{
    if([repository isUpdateCinema] == YES || [repository isUpdateMovie] == YES || [repository isUpdateSessiontime] == YES)
    {
        [self reloadInputViews];
        repository.isUpdateSessiontime = false;
    }
    NSLog(@"SHOWTIME - DELEGATE FINISH");
}

#pragma mark UIAlertViewDelegate

//after click on alert notice "data were updated"
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[AppDelegate currentDelegate].navigationController popToRootViewControllerAnimated:YES];
    
}

@end
