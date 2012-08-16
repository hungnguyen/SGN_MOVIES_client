//
//  MenuController.m
//  SGN_Movie_v2
//
//  Created by vnicon on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuController.h"

@interface MenuController ()

@end

@implementation MenuController
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
    
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return 2;
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
    else 
    {
        [cell.imageView setImage:[UIImage imageNamed:@"widescreen"]];
        [cell.textLabel setText:@"CINEMAS"];
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
    
    if(0==indexPath.row)
    {
        UINavigationController * navigationController = (UINavigationController *) AppDelegate.currentDelegate.deckController.centerController;
        if(navigationController.title == @"NOW SHOWING" || navigationController.title == @"COMING SOON")
        {
            MoviesController * moviesController = (MoviesController *) [navigationController.viewControllers objectAtIndex:0];
            if(!moviesController->isToggled)
            {
                moviesController->isToggled = TRUE;
            }
            else 
            {
                moviesController->isToggled = FALSE;
            }
            [[AppDelegate currentDelegate].deckController toggleLeftView];
        }
        else 
        {
            [[AppDelegate currentDelegate].deckController toggleLeftView];
            MoviesController *movieController = [[MoviesController alloc] initWithNibName:@"MoviesView" bundle:nil];
            [navigationController setViewControllers:[NSArray arrayWithObjects:movieController, nil]];
        }
        
    }
    else
    {
        UINavigationController * navigationController = (UINavigationController *) AppDelegate.currentDelegate.deckController.centerController;
        if(navigationController.title == @"CINEMAS")
        {
            CinemasController * cinemasController = (CinemasController *) [navigationController.viewControllers objectAtIndex:0];
            if(![cinemasController isToggled])
            {
                [cinemasController setIsToggled:TRUE];
            }
            else 
            {
                [cinemasController setIsToggled:FALSE];
            }
            [[AppDelegate currentDelegate].deckController toggleLeftView];
        }
        else 
        {
            [[AppDelegate currentDelegate].deckController toggleLeftView];
            CinemasController *cinemaController = [[CinemasController alloc] initWithNibName:@"CinemasView" bundle:nil];
            [navigationController setViewControllers:[NSArray arrayWithObjects:cinemaController, nil]];
        }
        
    }
    
    
}


@end
