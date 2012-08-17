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
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];    
    [infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* menuButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setImage:[UIImage imageNamed:@"Menu.png"] forState:UIControlStateNormal];
    
    UINavigationItem *navigationItem = [self navigationItem];
    [navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:infoButton]];
    [navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:menuButton]];
    
   // [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background8.jpg"]]];      
    
    [self setTitle:@"CINEMAS"];
    [[self navigationController] setTitle:@"CINEMAS"];
    
    //set rowheight for custom view cell: SGNCinemaListCell
    [_tableView setRowHeight: HEIGHT_CINEMAS_LIST_CELL];
    
    //for problem in iOS4.3: when choose UITableGroupView
    //table still has 4 black rectangle corner instead of round one's
    [_tableView setBackgroundColor:[UIColor clearColor]];
    
    //set delegate to start and finish update
    [[Repository sharedInstance] setDelegate:self];
    
    //get list cinemas from database
    [self reloadData];
    
    //update list cinemas to database
    [self updateData];
}

//auto update data when re-show view
- (void)viewWillAppear:(BOOL)animated
{
        [self reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setTableView:nil];
    [self setIsToggled:nil];
    [self setListCinemas:nil];
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
    [[Repository sharedInstance] setDelegate:nil];
    CinemaDetailController *cinemaDetailController = [[CinemaDetailController alloc]initWithNibName:@"CinemaDetailView"
                                                                                             bundle:nil];
    [cinemaDetailController setCinemaObject: [_listCinemas objectAtIndex:[indexPath section]]];
 
    [[self navigationController] pushViewController:cinemaDetailController animated:YES];
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
    [[self navigationController] pushViewController:[[AboutController alloc] init] animated:YES];
}


#pragma mark CoreData

- (void) reloadData
{
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    NSEntityDescription *entityDescription = [Cinema entityInManagedObjectContext:context];
    NSArray *sort = [Cinema sortIdAscending];
    NSArray *items = [[Repository sharedInstance] selectDataInEntity:entityDescription
                                                                predicate:nil
                                                           sortDescriptor:sort];
    [self setListCinemas: items];
    [_tableView reloadData];
}

- (void) updateData
{
    
    [[Repository sharedInstance]updateEntityWithurlString:UPDATE_ALL_URL];
}

#pragma mark SGNRepositoryDelegate

- (void)SGNRepositoryStartUpdate:(Repository *)repository
{
    NSLog(@"DELEGATE START");
}

- (void)SGNRepositoryFinishUpdate:(Repository *)repository
{
    [self reloadData];
    NSLog(@"DELEGATE FINISH");
}

@end
