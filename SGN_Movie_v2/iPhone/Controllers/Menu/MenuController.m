//
//  MenuController.m
//  SGN_Movie_v2
//
//  Created by vnicon on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuController.h"
#import "AboutController.h"
#import "MoviesController.h"
#import "CinemasController.h"
#import "Repository.h"

@interface MenuController ()

@end

@implementation MenuController
@synthesize tableView = _tableView;
@synthesize lastUpdateLabel = _lastUpdateLabel;

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
    
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self showLastUpdate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return 3;
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
    
    
    if(0==indexPath.row)
    {
        [cell.imageView setImage:[UIImage imageNamed:@"movie"]];
        [cell.textLabel setText:@"MOVIES"];
    }
    else if(1==indexPath.row)
    {
        [cell.imageView setImage:[UIImage imageNamed:@"widescreen"]];
        [cell.textLabel setText:@"CINEMAS"];
    }
    else
    {
        [cell.imageView setImage:[UIImage imageNamed:@"AboutIcon"]];
        [cell.textLabel setText:@"ABOUT"];
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //get top view controller
    UINavigationController * navigationController = (UINavigationController *) AppDelegate.currentDelegate.deckController.centerController;
    UIViewController *controller = [navigationController topViewController];
    
    if(0==indexPath.row)
    {
        //choose movie again
        if([controller isMemberOfClass:[MoviesController class]])
        {
            MoviesController * moviesController = (MoviesController *) controller;
            [moviesController setIsToggled:0];
        }
        //new choose movie
        else 
        {
            MoviesController *movieController = [[MoviesController alloc] initWithNibName:@"MoviesView" bundle:nil];
            [navigationController setViewControllers:[NSArray arrayWithObjects:movieController, nil]];
        }
    }
    else if(1==indexPath.row)
    {
        if([controller isMemberOfClass:[CinemasController class]])
        {
            CinemasController * cinemasController = (CinemasController *) controller;
            [cinemasController setIsToggled:0];
        }
        else 
        {
            CinemasController *cinemaController = [[CinemasController alloc] initWithNibName:@"CinemasView" 
                                                                                      bundle:nil];
            [navigationController setViewControllers:[NSArray arrayWithObjects:cinemaController, nil]];
        }
        
    }
    else
    {
        if([controller isMemberOfClass:[AboutController class]])
        {
            AboutController * aboutController = (AboutController *) controller;        
            [aboutController setIsToggled:0];
        }
        else
        {
            AboutController * aboutController = [[AboutController alloc] init];
            [navigationController setViewControllers:[NSArray arrayWithObjects:aboutController, nil]];
        }
    }
    [[AppDelegate currentDelegate].deckController toggleLeftView];
    
}

-(void) showLastUpdate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];    
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [formatter setDateFormat:@"HH:mm - dd/MM/yyyy"];
    NSString *lastUpdate = [formatter stringFromDate:[[Repository sharedInstance] readLastUpdated]];
    _lastUpdateLabel.text = [NSString stringWithFormat:@"Last update:%@",lastUpdate];
}

@end
