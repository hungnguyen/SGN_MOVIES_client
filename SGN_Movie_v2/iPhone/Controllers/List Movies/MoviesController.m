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
             movieDetailController.movieInfo = [_nowShowingMovies objectAtIndex:sender.tag];
          //   NSLog(@"%@",[movieDetailController.movieInfo valueForKey:@"Id"]);
                                                
         }
         else
         {
             movieDetailController.movieInfo = [_comingSoonMovies objectAtIndex:sender.tag];
         
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
        [poster setTag :i];
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
    //Get  movies
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) 
    {
        if(moviesContainerindex == 0)
        {
            _nowShowingMovies = (NSArray*) [JSON objectForKey:@"Data"];

            [self CreatePosters:scrollView moviesContainer:_nowShowingMovies];
            
            scrollView.contentSize = CGSizeMake( 320, (((_nowShowingMovies.count/2)+(_nowShowingMovies.count%2))*POSTER_WIDTH)+POSTER_HEIGHT+200);
        }
        else
        {
            _comingSoonMovies = (NSArray*) [JSON objectForKey:@"Data"];

            [self CreatePosters:scrollView moviesContainer:_comingSoonMovies];            
             scrollView.contentSize = CGSizeMake( 320, (((_comingSoonMovies.count/2)+(_comingSoonMovies.count%2))*POSTER_WIDTH)+POSTER_HEIGHT+200);
        }
        
    } 
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) 
    {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 320, 400.0)];
        myLabel.font = [UIFont fontWithName:@"Arial" size: 12.0];
        myLabel.textColor = [UIColor redColor];
        myLabel.textAlignment = UITextAlignmentCenter;
        myLabel.text = @"SORRY,THE DEVICE CAN'T LOAD DATA";
        
        [_scrollViewMain addSubview:scrollView];
        [scrollView addSubview:myLabel];
    }];
    
    [operation start];
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

@end
