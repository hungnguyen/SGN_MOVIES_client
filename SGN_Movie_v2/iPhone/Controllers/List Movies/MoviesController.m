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
@synthesize isToggled = _isToggled;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
       
    [self showLastUpdateOnNavigationBarWithTitle:@"NOW SHOWING"];
    [self.navigationController setTitle:@"NOW SHOWING"];
    
    UIButton* menuButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [menuButton setTag:1];
    [menuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setImage:[UIImage imageNamed:@"Menu.png"] forState:UIControlStateNormal];
    
    UIButton* rightMenuButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightMenuButton setTag:2];
    [rightMenuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [rightMenuButton setImage:[UIImage imageNamed:@"Menu.png"] forState:UIControlStateNormal];
    
    UINavigationItem *navigationItem = [self navigationItem];
    [navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightMenuButton]];
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
    if(_isToggled == 0)
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
        [self setIsToggled:0];
    }
}

#pragma mark - Create posters
- (void)CreatePosters:(UIScrollView *)scrollView moviesContainer:(NSArray *)moviesContainer
{
    //Add posters to Scrollview
    for (int i = 0; i<moviesContainer.count; i++)
    {
        int Ypos = (i/2)* POSTER_HEIGHT + 15*(i/2) + 5;
        int Xpos = (i - (i/2)*2)* POSTER_WIDTH + 15;
        if(i%2==1)
            Xpos = Xpos +10;
        //Create  a poster
        UIButton *poster = [[UIButton alloc] initWithFrame:CGRectMake(Xpos,Ypos,POSTER_WIDTH,POSTER_HEIGHT)];
     
        Movie *movie = [moviesContainer objectAtIndex:i];
        
        [poster setTag :[[movie movieId] intValue]];
        [poster addTarget:self action:@selector(tapPoster:) forControlEvents:UIControlEventTouchUpInside];
        
        SGNManagedImage * asynchcImage = [[SGNManagedImage alloc] initWithFrame:CGRectMake(0,0,POSTER_WIDTH,POSTER_HEIGHT)];
        
        NSString *hostUrl = [[[[AppDelegate currentDelegate] rightMenuController] provider] hostUrl];
        NSString * urlString = [hostUrl stringByAppendingString:[movie imageUrl]];
        [asynchcImage setUrl:[NSURL URLWithString:urlString]];
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
    Provider *provider = [[[AppDelegate currentDelegate] rightMenuController] provider];
    if(moviesContainerindex == 0)
    {
        NSArray *items = [Movie selectByProviderId:[[provider providerId] intValue] 
                                       isNowShowing:YES 
                                            context:context];
        [self setNowShowingMovies:items];
        [self CreatePosters:scrollView moviesContainer:_nowShowingMovies];
        scrollView.contentSize = CGSizeMake( 320, (_nowShowingMovies.count + 1) / 2 * (POSTER_HEIGHT + 15));
    }
    if(moviesContainerindex == 1)
    {
        NSArray *items = [Movie selectByProviderId:[[provider providerId] intValue] isNowShowing:NO context:context];
        [self setComingSoonMovies:items];
        [self CreatePosters:scrollView moviesContainer:_comingSoonMovies];
        scrollView.contentSize = CGSizeMake( 320, (_comingSoonMovies.count + 1) / 2 * (POSTER_HEIGHT + 15));
    }

}

#pragma mark - action of navigation bar 's buttons

-(void) showMenu:(id)sender
{
    if([sender tag] == 1)
        [[AppDelegate currentDelegate].deckController toggleLeftView];
    else if([sender tag] == 2)
        [[AppDelegate currentDelegate].deckController toggleRightView];
    
    if(_isToggled == 0)
    {
        [self setIsToggled:[sender tag]];
    }
    else 
    {
        [self setIsToggled:0];
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

@end
