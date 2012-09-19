//
//  CinemaController.m
//  SGN_Movie_v2
//
//  Created by vnicon on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "CinemasController.h"
#import "CinemaDetailController.h"

#import "SGNDataService.h"
#import "Cinema.h"

#import "SGNBannerView.h"
#import "SGNTableViewCellStyleDefault.h"

@interface CinemasController ()
@property (assign, nonatomic) bool isFirstLoad;
@property (strong, nonatomic) NSArray *listCinemas;
@end

@implementation CinemasController

@synthesize listCinemas = _listCinemas;
@synthesize tableView = _tableView;
@synthesize isToggled = _isToggled;
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
    
    self.title = @"LIST CINEMAS";
    self.isFirstLoad = true;
    
    UIButton* menuButton = [[UIButton alloc]initWithFrame:MENU_BUTTON_RECT];
    menuButton.tag = 1;
    [menuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setImage:[UIImage imageNamed:@"btn_nav.png"] forState:UIControlStateNormal];
    
    UIButton* rightMenuButton = [[UIButton alloc]initWithFrame:MENU_BUTTON_RECT];
    rightMenuButton.tag = 2;
    [rightMenuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [rightMenuButton setImage:[UIImage imageNamed:@"btn_nav.png"] forState:UIControlStateNormal];
    
    UINavigationItem *navigationItem = [self navigationItem];
    navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightMenuButton];
    navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    //set rowheight for custom view cell: SGNCinemaListCell
    //[_tableView setRowHeight: TABLE_CELLDEFAULT_HEIGHT];
    
    //update Data
    [[SGNRepository sharedInstance]updateEntityWithUrlString:UPDATE_ALL_URL];
    
    //Google AdMob
    SGNBannerView *bannerView = [[SGNBannerView alloc] initWithNibName:@"SGNBannerView"];
    [self.view addSubview:bannerView];
    [bannerView start];
}

//auto update data when re-show view
- (void)viewWillAppear:(BOOL)animated
{
    if(_isFirstLoad)
        [self reloadInputViews];
    _isFirstLoad = false;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    self.listCinemas = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) reloadInputViews
{
    NSManagedObjectContext *context = [SGNDataService defaultContext];
    Provider *provider = [[[AppDelegate currentDelegate]rightMenuController]provider];
    [self setListCinemas: [Cinema selectByProviderId:[provider.providerId intValue] context:context]];
    
    [_tableView reloadData];
    NSLog(@"LIST CINEMA - TABLE RELOAD");
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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

#pragma mark UITableViewDelegate

- (UITableViewCell*)tableView:(UITableView*)objTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{      
    static NSString *cellIndentifier = @"SGNTableViewCellStyleDefault";
    
    SGNTableViewCellStyleDefault *cell= [objTableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell == nil)
    {
        cell = [[SGNTableViewCellStyleDefault alloc] initWithNibName:cellIndentifier];
        cell.iconImageView.imageContentMode = UIViewContentModeScaleAspectFill;
        cell.iconImageView.frame = CGRectInset(cell.iconImageView.frame, 2, 2);        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Cinema *cinema = [_listCinemas objectAtIndex:[indexPath row]];
    NSString *urlHost = [[[[AppDelegate currentDelegate] rightMenuController] provider] hostUrl];
    NSString *image_url = [urlHost stringByAppendingString:[cinema imageUrl]];
    
    cell.contentLabel.text = cinema.name;
    [cell.iconImageView setImageFromURL:image_url];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isToggled == 0)
    {
        CinemaDetailController *cinemaDetailController = [[CinemaDetailController alloc]initWithNibName:@"CinemaDetailView"
                                                                                                 bundle:nil];
        Cinema *cinema = [_listCinemas objectAtIndex:[indexPath row]];
        [cinemaDetailController setCinemaObjectId:[cinema cinemaId].intValue];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                       initWithTitle: @"Back" 
                                       style: UIBarButtonItemStyleBordered
                                       target: nil action: nil];
        [self.navigationItem setBackBarButtonItem: backButton];
        
        [[self navigationController] pushViewController:cinemaDetailController animated:YES];
    }
    else if(_isToggled == 1)
    {
        [[AppDelegate currentDelegate].deckController toggleLeftView];
        self.isToggled = 0;
    }
    else if(_isToggled == 2)
    {
        [[AppDelegate currentDelegate].deckController toggleRightView];
        self.isToggled = 0;
    }
}

#pragma mark - Scrollview Delegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView*)scrollView
{
    if(_isToggled == 0)
    {
        return;
    }
    else if(_isToggled == 1)
    {
        [[AppDelegate currentDelegate].deckController toggleLeftView];
        self.isToggled = 0;
    }
    else if(_isToggled == 2)
    {
        [[AppDelegate currentDelegate].deckController toggleRightView];
        self.isToggled = 0;
        
    }
}

#pragma mark Action

- (void)showMenu:(id)sender
{
    if([sender tag] == 1)
        [[AppDelegate currentDelegate].deckController toggleLeftView];
    else if([sender tag] == 2)
        [[AppDelegate currentDelegate].deckController toggleRightView];
    
    self.isToggled = (_isToggled == 0) ? [sender tag] : 0;
}

#pragma mark SGNRepositoryDelegate

- (void)RepositoryStartUpdate:(SGNRepository *)repository
{
    NSLog(@"LIST CINEMAS - DELEGATE START");
}

//check if has new data of cinemas
- (void)RepositoryFinishUpdate:(SGNRepository *)repository
{
    if([repository isUpdateCinema] == YES)
    {
        [self reloadInputViews];    
        [SGNRepository sharedInstance].isUpdateCinema = NO;
    }
    NSLog(@"LIST CINEMAS - DELEGATE FINISH");
}

@end
