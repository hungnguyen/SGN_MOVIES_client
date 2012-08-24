//
//  CinemaController.m
//  SGN_Movie_v2
//
//  Created by vnicon on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CinemasController.h"
#import "CinemaDetailController.h"
#import "AppDelegate.h"
#import "HJCache.h"
#import "SGNCinemasListCell.h"
#import "AFNetworking.h"
#import "Cinema.h"
#import "DataService.h"

//define height of cell in view List Cinemas
#define HEIGHT_CINEMAS_LIST_CELL 130

@interface CinemasController ()

@property (strong, nonatomic) NSArray *listCinemas;
-(void) showMenu;
-(void) showInfo;

@end

@implementation CinemasController

@synthesize listCinemas = _listCinemas;
@synthesize tableView = _tableView;
@synthesize isToggled = _isToggled;
@synthesize popOverController = _popOverController;

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
    
    [self setIsToggled:FALSE];
    
    
    // Do any additional setup after loading the view from its nib.
    UIButton* infoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];    
    [infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    [infoButton setImage:[UIImage imageNamed:@"Provider"] forState:UIControlStateNormal];
    
    UIButton* menuButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setImage:[UIImage imageNamed:@"Menu.png"] forState:UIControlStateNormal];
    
    UINavigationItem *navigationItem = [self navigationItem];
    [navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:infoButton]];
    [navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:menuButton]];
    
    [self showLastUpdateOnNavigationBarWithTitle:@"CINEMAS"];
    [self.navigationController setTitle:@"CINEMAS"];

    
    //set rowheight for custom view cell: SGNCinemaListCell
    [_tableView setRowHeight: HEIGHT_CINEMAS_LIST_CELL];
    
    //for problem in iOS4.3: when choose UITableGroupView
    //table still has 4 black rectangle corner instead of round one's
    [_tableView setBackgroundColor:[UIColor clearColor]];
    
    WEPopoverContentViewController * contentViewController = [[WEPopoverContentViewController alloc] initWithStyle:UITableViewStylePlain];
    NSManagedObjectContext * context = [[DataService sharedInstance] managedObjectContext];
    [contentViewController setProviders:[Provider selectAllInContext:context]];
    [contentViewController setDelegate:self];
    _popOverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];

    
    [self updateData];
}

//auto update data when re-show view
- (void)viewWillAppear:(BOOL)animated
{
    [self showLastUpdateOnNavigationBarWithTitle:@"CINEMAS"];
    [self reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setListCinemas:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setTableView:nil];
    [self setIsToggled:nil];
    [self setPopOverController:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	if (_listCinemas && [_listCinemas count]) 
    {
        return [_listCinemas count];
    }
    else
    {
        return 0;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark UITableViewDelegate

- (SGNCinemasListCell*)tableView:(UITableView*)objTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SGNCinemasListCell *cell= [objTableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = [[SGNCinemasListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:@"cell"];
    }
    Cinema *cinema = [_listCinemas objectAtIndex:[indexPath section]];
    [cell fillWithData:cinema];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_isToggled)
    {
        CinemaDetailController *cinemaDetailController = [[CinemaDetailController alloc]initWithNibName:@"CinemaDetailView"
                                                                                             bundle:nil];
        Cinema *cinema = [_listCinemas objectAtIndex:[indexPath section]];
        [cinemaDetailController setCinemaObjectId:[cinema cinemaId].intValue];
    
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Back" 
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
        [self.navigationItem setBackBarButtonItem: backButton];
    
        [[self navigationController] pushViewController:cinemaDetailController animated:YES];
    }
    else
    {
        [[AppDelegate currentDelegate].deckController toggleLeftView];
        [self setIsToggled:FALSE];
    }
}

#pragma mark Action

- (void)showMenu
{
    [[AppDelegate currentDelegate].deckController toggleLeftView];
    if(!_isToggled)
    {
        [self setIsToggled:TRUE];
    }
    else 
    {
        [self setIsToggled:FALSE];
    }
}

- (void)showInfo
{        
    [_popOverController presentPopoverFromRect:CGRectMake(240, -100,140 , 90) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark CoreData

//query data from db
- (void) reloadData
{
    [self showLastUpdateOnNavigationBarWithTitle:@"CINEMAS"];
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    int currentProviderId = [[Repository sharedInstance] currentProviderId];
    [self setListCinemas: [Cinema selectByProviderId:currentProviderId context:context]];
    WEPopoverContentViewController * contentViewController = [[WEPopoverContentViewController alloc] initWithStyle:UITableViewStylePlain];
    [contentViewController setProviders:[Provider selectAllInContext:context]];
    [contentViewController setDelegate:self];
    _popOverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
    [_tableView reloadData];
}

//get new data from sever
- (void) updateData
{
    [[Repository sharedInstance]updateEntityWithUrlString:UPDATE_ALL_URL];
}

#pragma mark SGNRepositoryDelegate

- (void)RepositoryStartUpdate:(Repository *)repository
{
    NSLog(@"DELEGATE START");
}

//check if has new data of cinemas
- (void)RepositoryFinishUpdate:(Repository *)repository
{
    if([repository isUpdateCinema] == YES)
        [self reloadData];
    
    NSLog(@"DELEGATE FINISH");
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

#pragma mark WEPopover delegate
-(void) providerSelect:(NSString *) providerName
{
    [_popOverController dismissPopoverAnimated:YES];
    [self reloadData];
    NSLog(@"%@",providerName);
}


@end
