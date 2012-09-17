//
//  ViewController.m
//  SGN_Movie_v2
//
//  Created by vnicon on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MoviesController.h"
#import "MovieDetailController.h"

#import "SGNDataService.h"
#import "Movie.h"

#import "SGNCollectionViewCell.h"

@interface MoviesController ()
@property (assign, nonatomic) bool isFirstLoad;
@property (strong, nonatomic)  NSArray * nowShowingMovies;
@property (strong, nonatomic)  NSArray * comingSoonMovies;
@property (strong, nonatomic) PSCollectionView *PSNowShowing;
@property (strong, nonatomic) PSCollectionView *PSCommingSoon;
@end

@implementation MoviesController

@synthesize scrollViewMain = _scrollViewMain;
@synthesize pageControl = _pageControl;
@synthesize nowShowingMovies = _nowShowingMovies;
@synthesize comingSoonMovies = _comingSoonMovies;
@synthesize PSNowShowing = _PSNowShowing;
@synthesize PSCommingSoon = _PSCommingSoon;
@synthesize isToggled = _isToggled;
@synthesize isFirstLoad = _isFirstLoad;

#pragma mark Init

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"NOW SHOWING";
    self.isFirstLoad = true;
    
    UIButton* menuButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 30)];
    menuButton.tag = 1;
    [menuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setImage:[UIImage imageNamed:@"btn_nav.png"] forState:UIControlStateNormal];
    
    UIButton* rightMenuButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 30)];
    rightMenuButton.tag = 2;
    [rightMenuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [rightMenuButton setImage:[UIImage imageNamed:@"btn_nav.png"] forState:UIControlStateNormal];
    
    UINavigationItem *navigationItem = [self navigationItem];
    navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightMenuButton];
    navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    //create 2 PSCollectionView
    CGRect mainFrame = self.scrollViewMain.bounds;
    self.PSNowShowing = [[PSCollectionView alloc] initWithFrame:mainFrame];
    _PSNowShowing.tag = 1;
    _PSNowShowing.delegate = self;
    _PSNowShowing.collectionViewDelegate = self;
    _PSNowShowing.collectionViewDataSource = self;
    _PSNowShowing.numColsPortrait = 2;
    _PSNowShowing.numColsLandscape = 2;
    
    mainFrame.origin.x = 320;
    self.PSCommingSoon = [[PSCollectionView alloc]initWithFrame:mainFrame];
    _PSCommingSoon.tag = 2;
    _PSCommingSoon.delegate = self;
    _PSCommingSoon.collectionViewDelegate = self;
    _PSCommingSoon.collectionViewDataSource = self;
    _PSCommingSoon.numColsPortrait = 2;
    _PSCommingSoon.numColsLandscape = 2;
    
    //modify main scrollview
    _scrollViewMain.contentSize = CGSizeMake(mainFrame.size.width * 2, mainFrame.size.height);
    [_scrollViewMain addSubview:_PSNowShowing];
    [_scrollViewMain addSubview:_PSCommingSoon];
    
    //Update Data
    [[SGNRepository sharedInstance] updateEntityWithUrlString:UPDATE_ALL_URL];
}

- (void) viewWillAppear:(BOOL)animated
{
    if(_isFirstLoad)
        [self reloadInputViews];
    _isFirstLoad = false;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.scrollViewMain = nil;
    self.pageControl = nil;
    self.nowShowingMovies = nil;
    self.comingSoonMovies = nil;
    self.PSNowShowing = nil;
    self.PSCommingSoon = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)reloadInputViews
{
    NSManagedObjectContext *context = [SGNDataService defaultContext];
    Provider *provider = [AppDelegate currentDelegate].rightMenuController.provider;
    self.nowShowingMovies = [Movie selectByProviderId:provider.providerId.intValue 
                                         isNowShowing:YES
                                              context:context];
    self.comingSoonMovies = [Movie selectByProviderId:provider.providerId.intValue 
                                         isNowShowing:NO
                                              context:context];
    
    [_PSCommingSoon reloadData];
    [_PSNowShowing reloadData];
    
    NSLog(@"LIST MOVIE - RELOAD DATA");
}

#pragma mark - PSCollectionViewDataSource

- (NSInteger)numberOfViewsInCollectionView:(PSCollectionView *)collectionView 
{
    if(collectionView.tag == 1)
        return _nowShowingMovies.count;
    else if(collectionView.tag == 2)
        return _comingSoonMovies.count;
    else 
        return 0;
}

- (CGFloat)heightForViewAtIndex:(NSInteger)index 
{
    return POSTER_HEIGHT;
}

#pragma mark - PSCollectionViewDelegate

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView 
                             viewAtIndex:(NSInteger)index 
{
    Movie *movie = nil;
    if(collectionView.tag == 1)
        movie = (Movie*)[_nowShowingMovies objectAtIndex:index];
    else if (collectionView.tag == 2)
        movie = (Movie*)[_comingSoonMovies objectAtIndex:index];
    else
        return nil;
    
    SGNCollectionViewCell *view = (SGNCollectionViewCell*)[collectionView dequeueReusableView];
    if(view == nil)
    {
        view = [[SGNCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, POSTER_WIDTH, POSTER_HEIGHT)];
    }
    [view fillViewWithObject:movie];
    return view;
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectView:(PSCollectionViewCell *)view atIndex:(NSInteger)index 
{
    //check if menu is toggled
    if(_isToggled == 0)
    {
        MovieDetailController *movieDetailController = [[MovieDetailController alloc] initWithNibName:@"MovieDetailView" bundle:nil];
        
        Movie *movie = nil;
        if(collectionView.tag == 1)
            movie = (Movie*)[_nowShowingMovies objectAtIndex:index];
        else if (collectionView.tag == 2)
            movie = (Movie*)[_comingSoonMovies objectAtIndex:index];           
        
        movieDetailController.movieObjectId = movie.movieId.intValue;
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                       initWithTitle: @"Back" 
                                       style: UIBarButtonItemStyleBordered
                                       target: nil action: nil];
        
        self.navigationItem.backBarButtonItem = backButton;
        [self.navigationController pushViewController:movieDetailController animated:YES];        
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    CGFloat pageWidth = _scrollViewMain.frame.size.width;
    int page = _scrollViewMain.contentOffset.x / pageWidth;
    _pageControl.currentPage = page;
    
    self.title = (page == 0) ? @"NOW SHOWING" : @"COMING SOON";
}    

#pragma mark - Action 

-(void) showMenu:(id)sender
{
    if([sender tag] == 1)
        [[AppDelegate currentDelegate].deckController toggleLeftView];
    else if([sender tag] == 2)
        [[AppDelegate currentDelegate].deckController toggleRightView];
    
    self.isToggled = (_isToggled == 0) ? [sender tag] : 0;
}

- (IBAction)pageChange:(id)sender
{
    NSLog(@"%i", _pageControl.currentPage);
    CGRect frame = _scrollViewMain.frame;
    frame.origin.x = frame.size.width * _pageControl.currentPage;
    frame.origin.y = 0;
    [_scrollViewMain scrollRectToVisible:frame animated:YES];
}

#pragma mark SGNRepositoryDelegate

- (void)RepositoryStartUpdate:(SGNRepository *)repository
{
    NSLog(@"LIST MOVIE - DELEGATE START");
}

- (void)RepositoryFinishUpdate:(SGNRepository *)repository
{
    if([SGNRepository sharedInstance].isUpdateMovie == YES)
    {   
        [self reloadInputViews];   
        [SGNRepository sharedInstance].isUpdateMovie = NO;
    }
    NSLog(@"LIST MOVIE - DELEGATE FINISH");
}

@end