//
//  RightMenuController.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RightMenuController.h"
#import "CinemasController.h"
#import "MoviesController.h"

#import "SGNDataService.h"
#import "AppDelegate.h"

@interface RightMenuController ()
@property (strong, nonatomic) NSArray *listProviders;
@property (assign, nonatomic) int currentRow;
@end

@implementation RightMenuController

@synthesize tableView = _tableView;
@synthesize listProviders = _listProviders;
@synthesize provider = _provider;
@synthesize currentRow = _currentRow;

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
    // Do any additional setup after loading the view from its nib.
    [self reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark CoreData

//query data from db
- (void) reloadData
{
    NSManagedObjectContext *context = [SGNDataService defaultContext];
    [self setListProviders: [Provider selectAllInContext:context]];
    
    //exist data in list provider, based on current row
    if([_listProviders count] > 0 && [_listProviders count] >= _currentRow)
    {
        _provider = [_listProviders objectAtIndex:_currentRow];
    }
    //exist data but total less than current row
    else if([_listProviders count] > 0)
    {
        _currentRow = 0;
        _provider = [_listProviders objectAtIndex:_currentRow];
    }
    [_tableView reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_listProviders && [_listProviders count]) 
    {
        return [_listProviders count];
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
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:CellIdentifier];
    }
    Provider *provider = [_listProviders objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[provider name]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //toggle right menu
    AppDelegate *curAppDelegate = [AppDelegate currentDelegate];
    UIViewController *controller = [[curAppDelegate navigationController] topViewController];
    [[curAppDelegate deckController] toggleRightView];
    
    //set toggle
    if([controller isMemberOfClass:[CinemasController class]])
    {
        CinemasController *cinemaController = (CinemasController*)controller;
        [cinemaController setIsToggled:0];
    }
    else if([controller isMemberOfClass:[MoviesController class]])
    {
        MoviesController *movieController = (MoviesController*)controller;
        [movieController setIsToggled:0];
    }
    
    //check if current row is changed
    if(_currentRow != [indexPath row])
    {
        //apply new current row and update current provider
        _currentRow = [indexPath row];
        _provider = [_listProviders objectAtIndex:_currentRow];
        
        //reload data when change provider
        [controller reloadInputViews];
    }
}

@end
