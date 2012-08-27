//
//  ViewController.m
//  SGN_Movie_v2
//
//  Created by vnicon on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MoviesController.h"
#import "AFNetworking.h"
#import "MenuController.h"
#import "AppDelegate.h"

#define POSTER_HEIGHT 200
#define POSTER_WIDTH 140

#define PopOver_WIDHT 140
#define PopOver_HEIGHT 45
#define PopOverX 240
#define PopOverY -55

@interface MoviesController ()
{
}
@property (strong,nonatomic)  NSArray * nowShowingMovies;
@property (strong,nonatomic)  NSArray * comingSoonMovies;
- (void) tapPoster:(UIButton*) sender;


@end

@implementation MoviesController
@synthesize scrollViewMain = _scrollViewMain;
@synthesize pageControl = _pageControl;
@synthesize nowShowingMovies = _nowShowingMovies;
@synthesize comingSoonMovies = _comingSoonMovies;
@synthesize popOverController = _popOverController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
       
    [self showLastUpdateOnNavigationBarWithTitle:@"NOW SHOWING"];
    [self.navigationController setTitle:@"NOW SHOWING"];
    
    isToggled = FALSE;
    
    UIButton* infoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];    
    [infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    [infoButton setImage:[UIImage imageNamed:@"Provider"] forState:UIControlStateNormal];
    
    UIButton* menuButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setImage:[UIImage imageNamed:@"Menu.png"] forState:UIControlStateNormal];
    
    UINavigationItem *navigationItem = [self navigationItem];
    [navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:infoButton]];
    [navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:menuButton]];

    CGRect parentView = self.scrollViewMain.frame;
    UIScrollView * scrollviewNoSh = [[UIScrollView alloc]initWithFrame:parentView];
    parentView.origin.x = 320;
    UIScrollView * scrollviewCoSo = [[UIScrollView alloc]initWithFrame:parentView];
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background8.jpg"]]];
    
    //Update Data
    [self updateData];
   
    //Get now showing movies
    [self getSpecifiedMoviesAndShowThemWithmoviesContainerIndex:0 
                             scrollView:scrollviewNoSh];
    
    //Get coming soon movies
    [self getSpecifiedMoviesAndShowThemWithmoviesContainerIndex:1 
                                                     scrollView:scrollviewCoSo];
    
    [_scrollViewMain addSubview:scrollviewNoSh];
    [_scrollViewMain addSubview:scrollviewCoSo];

    //modify main scrollview
    [_scrollViewMain setContentSize:CGSizeMake(parentView.size.width * 2, parentView.size.height)];
    
    NSManagedObjectContext * context = [[DataService sharedInstance] managedObjectContext];
    NSArray * providerList = [Provider selectAllInContext:context];
    WEPopoverContentViewController * contentViewController = [[WEPopoverContentViewController alloc] initwithStyle:UITableViewStylePlain andCount:[providerList count]];
    [contentViewController setProviders:[Provider selectAllInContext:context]];
    [contentViewController setDelegate:self];
    _popOverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];

}

- (void) viewWillAppear:(BOOL)animated
{
    [self reloadView];
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setNowShowingMovies:nil];
    [self setComingSoonMovies:nil];
    [self setScrollViewMain:nil];
    [self setPageControl:nil];
    [self setPopOverController:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - Scrollview Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender 
{
    CGFloat pageWidth = _scrollViewMain.frame.size.width;
    int page = floor((_scrollViewMain.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if(page == 1)
    {
        [self showLastUpdateOnNavigationBarWithTitle:@"COMING SOON"];
    }
    else
    {
        [self showLastUpdateOnNavigationBarWithTitle:@"NOW SHOWING"];

    }
    
    [_pageControl setCurrentPage:page];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}


#pragma mark - actions of buttons
- (void) tapPoster:(UIButton*) sender
{
    if(!isToggled)
    {
       
        
        MovieDetailController *movieDetailController = [[MovieDetailController alloc] initWithNibName:@"MovieDetailView" bundle:nil];
        NSRange aRange = [[self title] rangeOfString:@"NOW SHOWING"];
      
        if(aRange.location!=NSNotFound)
         {
             [movieDetailController setMovieObjectId:sender.tag];
         }
         else
         {
             [movieDetailController setMovieObjectId:sender.tag];
         }
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                       initWithTitle: @"Back" 
                                       style: UIBarButtonItemStyleBordered
                                       target: nil action: nil];
        
        [self.navigationItem setBackBarButtonItem: backButton];
        [self.navigationController pushViewController:movieDetailController animated:YES];        
    }
    else
    {
        [[AppDelegate currentDelegate].deckController toggleLeftView];
        isToggled = FALSE;
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(isToggled)
    {
        [[AppDelegate currentDelegate].deckController toggleLeftView];
        isToggled = FALSE;
    }
}


#pragma mark - Create posters
- (void)CreatePosters:(UIScrollView *)scrollView moviesContainer:(NSArray *)moviesContainer
{
    //Add posters to Scrollview
    for (int i = 0; i<moviesContainer.count; i++)
    {
        NSString * urlString = [[NSString alloc] initWithString:[[moviesContainer objectAtIndex:i] 
                                                    valueForKey:@"ImageUrl"]];
        
        int Ypos = (i/2)* POSTER_HEIGHT + 15*(i/2) + 5;
        int Xpos = (i - (i/2)*2)* POSTER_WIDTH + 15;
        if(i%2==1)
            Xpos = Xpos +10;
        //Create  a poster
        UIButton *poster = [[UIButton alloc] initWithFrame:CGRectMake(Xpos,Ypos,POSTER_WIDTH,POSTER_HEIGHT)];
        
        //Convert movieId to int NSNumber type
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * myNumber = [f numberFromString:[NSString stringWithFormat:@"%@",[[moviesContainer objectAtIndex:i] valueForKey:@"movieId"]]];
        int movieId = myNumber.intValue;
        
        [poster setTag :movieId];
        [poster addTarget:self action:@selector(tapPoster:) forControlEvents:UIControlEventTouchUpInside];
        
        HJManagedImageV * asynchcImage = [[HJManagedImageV alloc] initWithFrame:CGRectMake(0,0,POSTER_WIDTH,POSTER_HEIGHT)];
        [asynchcImage setUrl:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",PROVIDER_URL,urlString]]];
        [asynchcImage showLoadingWheel];
        [asynchcImage setImageContentMode:UIViewContentModeScaleToFill];
        [poster addSubview:asynchcImage];
        [scrollView addSubview:poster];
        
        [[HJCache sharedInstance].hjObjManager manage:asynchcImage];
    }
}


#pragma mark - get movies from JSON

- (void) getSpecifiedMoviesAndShowThemWithmoviesContainerIndex:(int) moviesContainerindex 
                            scrollView:(UIScrollView *) scrollView 
{
       
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    int currentProviderId = [[Repository sharedInstance] currentProviderId];
    if(moviesContainerindex == 0)
    {
        NSArray *items = [Movie selectByProviderId:currentProviderId isNowShowing:YES context:context];
        [self setNowShowingMovies:items];
        [self CreatePosters:scrollView moviesContainer:_nowShowingMovies];
        scrollView.contentSize = CGSizeMake( 320, (((_nowShowingMovies.count/2)+(_nowShowingMovies.count%2))*POSTER_WIDTH)+POSTER_HEIGHT+200);
    }
    if(moviesContainerindex == 1)
    {
        NSArray *items = [Movie selectByProviderId:currentProviderId isNowShowing:NO context:context];
        [self setComingSoonMovies:items];
        [self CreatePosters:scrollView moviesContainer:_comingSoonMovies];
        scrollView.contentSize = CGSizeMake( 320, (((_comingSoonMovies.count/2)+(_comingSoonMovies.count%2))*POSTER_WIDTH)+POSTER_HEIGHT+200);
    }

}

#pragma mark - action of navigation bar 's buttons

-(void) showInfo
{
    [_popOverController presentPopoverFromRect:CGRectMake(PopOverX, PopOverY,PopOver_WIDHT ,PopOver_HEIGHT) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void) showMenu
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

#pragma mark SGNRepositoryDelegate

- (void)RepositoryStartUpdate:(Repository *)repository
{
    NSLog(@"DELEGATE START");
}

- (void)RepositoryFinishUpdate:(Repository *)repository
{
    if([Repository sharedInstance].isUpdateMovie == YES)
        [self reloadView];
    NSLog(@"DELEGATE FINISH");
}

#pragma mark Update Data
- (void) updateData
{
    [[Repository sharedInstance] updateEntityWithUrlString:UPDATE_ALL_URL];
}

#pragma mark ReloadView
-(void) reloadView
{

    NSLog(@"RELOAD VIEW");
    [self showLastUpdateOnNavigationBarWithTitle:self.navigationController.title];
    CGRect parentView = self.scrollViewMain.frame;
    UIScrollView * scrollviewNoSh = (UIScrollView*)[[_scrollViewMain subviews] objectAtIndex:0];
    parentView.origin.x = 320;
    UIScrollView * scrollviewCoSo = (UIScrollView*)[[_scrollViewMain subviews] objectAtIndex:1];
    
    for(UIView * subview in [scrollviewNoSh subviews])
    {
        [subview removeFromSuperview]; 
    }
    for(UIView * subview in [scrollviewCoSo subviews])
    {
        [subview removeFromSuperview]; 
    }
    
    
    //Get now showing movies
    [self getSpecifiedMoviesAndShowThemWithmoviesContainerIndex:0 
                                                     scrollView:scrollviewNoSh];
    
    //Get coming soon movies
    [self getSpecifiedMoviesAndShowThemWithmoviesContainerIndex:1 
                                                     scrollView:scrollviewCoSo];
    
    
    NSManagedObjectContext * context = [[DataService sharedInstance] managedObjectContext];
    NSArray * providerList = [Provider selectAllInContext:context];
    WEPopoverContentViewController * contentViewController = [[WEPopoverContentViewController alloc] initwithStyle:UITableViewStylePlain andCount:[providerList count]];
    [contentViewController setProviders:[Provider selectAllInContext:context]];
    [contentViewController setDelegate:self];
    _popOverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];


}

#pragma mark showLastUpdate
-(void) showLastUpdateOnNavigationBarWithTitle:(NSString*) title
{
    [self.navigationController setTitle:title];
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
    NSLog(@"%@",providerName);
    [self reloadView];
}

@end
