//
//  CinemaController.m
//  SGN_Movie_v2
//
//  Created by vnicon on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CinemasController.h"
#import "AppDelegate.h"
#import "HJCache.h"
#import "SGNCinemasListCell.h"

@interface CinemasController ()
{
    bool isToggled;
}

-(void) showMenu;
-(void) showInfo;

@end

@implementation CinemasController

@synthesize tableView = _tableView;
@synthesize listCinemas = _listCinemas;

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
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];    
    [infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* menuButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setImage:[UIImage imageNamed:@"Menu.png"] forState:UIControlStateNormal];
    
    UINavigationItem *navigationItem = [self navigationItem];
    [navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:infoButton]];
    [navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:menuButton]];
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background8.jpg"]]];      
    
    [self setTitle:@"CINEMAS"];

    [self getListCinemas:@"http://sgn-m.apphb.com/cinema/list"];
    [[self tableView]setRowHeight: HEIGHT_CINEMAS_LIST_CELL];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setTableView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

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

- (UITableViewCell*)tableView:(UITableView*)objTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SGNCinemasListCell *cell= [objTableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = [[SGNCinemasListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:@"cell"];
    }
    NSArray *cinema = [_listCinemas objectAtIndex:[indexPath section]];
    [cell fillWithData:cinema];
    return cell;
}

- (void) getListCinemas:(NSString*)urlString
{
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            self.listCinemas = (NSMutableArray*) [JSON objectForKey:@"Data"];
                                                                                            [[self tableView] reloadData];
                                                                                        } 
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
                                                                                        }
                                         ];
    [operation start];
}

- (void)showMenu
{
    [[AppDelegate currentDelegate].deckController toggleLeftView];
    if(!isToggled)
    {
        isToggled = TRUE;
    }
    else 
    {
        isToggled = FALSE;
    }
}

- (void)showInfo
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"About" message:@"This is About box" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
