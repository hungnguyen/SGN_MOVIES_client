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
#define POSTER_WIDTH 150

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self setTitle:@"NOW SHOWING"];
    [self.navigationController setTitle:@"NOW SHOWING"];
    
    isToggled = FALSE;
    
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];    
    [infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    
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
    [self getSpecifiedMoviesAndShowThem:@"http://sgnm-server.apphb.com/movie/list?type=nowshowing" 
                   moviesContainerIndex:0 
                             scrollView:scrollviewNoSh];
    
    //Get coming soon movies
    [self getSpecifiedMoviesAndShowThem:@"http://sgnm-server.apphb.com/movie/list?type=comingsoon" 
                   moviesContainerIndex:1 
                             scrollView:scrollviewCoSo];
    
    [_scrollViewMain addSubview:scrollviewNoSh];
    [_scrollViewMain addSubview:scrollviewCoSo];

    //modify main scrollview
    [_scrollViewMain setContentSize:CGSizeMake(parentView.size.width * 2, parentView.size.height)];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self reloadView];
}

- (void)viewDidUnload
{
    [self setNowShowingMovies:nil];
    [self setComingSoonMovies:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setScrollViewMain:nil];
    [self setPageControl:nil];
    
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
        [self setTitle:@"COMING SOON"];
    }
    else
    {
        [self setTitle:@"NOW SHOWING"];
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
        
        if([self title] == @"NOW SHOWING")
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
        int Xpos = (i - (i/2)*2)* POSTER_WIDTH + 10;
        
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
        [poster addSubview:asynchcImage];
        [scrollView addSubview:poster];
        
        [[HJCache sharedInstance].hjObjManager manage:asynchcImage];
    }
}


#pragma mark - get movies from JSON

- (void) getSpecifiedMoviesAndShowThem:(NSString*) urlString 
                  moviesContainerIndex:(int) moviesContainerindex 
                            scrollView:(UIScrollView *) scrollView 
{
       
    NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    
    if(moviesContainerindex == 0)
    {
        NSArray *items = [Movie selectByProviderId:1 isNowShowing:YES context:context];
        [self setNowShowingMovies:items];
        [self CreatePosters:scrollView moviesContainer:_nowShowingMovies];
        scrollView.contentSize = CGSizeMake( 320, (((_nowShowingMovies.count/2)+(_nowShowingMovies.count%2))*POSTER_WIDTH)+POSTER_HEIGHT+200);
    }
    if(moviesContainerindex == 1)
    {
        NSArray *items = [Movie selectByProviderId:1 isNowShowing:NO context:context];
        [self setComingSoonMovies:items];
        [self CreatePosters:scrollView moviesContainer:_comingSoonMovies];
        scrollView.contentSize = CGSizeMake( 320, (((_comingSoonMovies.count/2)+(_comingSoonMovies.count%2))*POSTER_WIDTH)+POSTER_HEIGHT+200);
    }

}

#pragma mark - action of navigation bar 's buttons

-(void) showInfo
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Back" 
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];

    [self.navigationController pushViewController:[[AboutController alloc] init] animated:YES];
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
    [self getSpecifiedMoviesAndShowThem:@"http://sgnm-server.apphb.com/movie/list?type=nowshowing" 
                   moviesContainerIndex:0 
                             scrollView:scrollviewNoSh];
    
    //Get coming soon movies
    [self getSpecifiedMoviesAndShowThem:@"http://sgnm-server.apphb.com/movie/list?type=comingsoon" 
                   moviesContainerIndex:1 
                             scrollView:scrollviewCoSo];

}
@end
