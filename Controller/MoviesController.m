//
//  ViewController.m
//  SGN_Movie_v2
//
//  Created by vnicon on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MoviesController.h"
#import "AFNetworking.h"


@interface MoviesController ()

@end

@implementation MoviesController
@synthesize scrollView;
@synthesize pageControl;
@synthesize nowShowingMovies;
@synthesize comingSoonMovies;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setTitle:@"MOVIES"];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    
    
    nowShowingMovies = [[NSArray alloc] init];
    comingSoonMovies = [[NSArray alloc] init];
    
    UIScrollView * scrollview1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 450)];
    UIScrollView * scrollview2 = [[UIScrollView alloc]initWithFrame:CGRectMake(320, 0, 320, 450)];
    
   
   self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background8.jpg"]];        
   
    
    //Get now showing movies
    
    [self getSpecifiedMoviesAndShowThem:@"http://sgn-m.apphb.com/movie/list?type=nowshowing" moviesContainerIndex:0 
                             scrollView:scrollview1];
    
        
    
    
    //Get coming soon movies

    [self getSpecifiedMoviesAndShowThem:@"http://sgn-m.apphb.com/movie/list?type=comingsoon" moviesContainerIndex:1 
                             scrollView:scrollview2];
    
    
    
    
    //modify main scrollview
    
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*2, 300);
    
    
    scrollView.delegate = self;
    
    pageControl.numberOfPages = 2;
    
    pageControl.currentPage = 0;
    
    
    self.scrollView.pagingEnabled = true;
    
    self.scrollView.bounces = NO;

    

}



- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setPageControl:nil];
    [nowShowingMovies release];
    [comingSoonMovies release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [scrollView release];
    [pageControl release];
    [super dealloc];
}



- (void)scrollViewDidScroll:(UIScrollView *)sender {
	
    CGFloat pageWidth = self.scrollView.frame.size.width;
    
  //  NSLog(@"%f",self.scrollView.contentOffset.x);
    
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    
    if(page==1)
        self.title = @"COMING SOON";
    
    else {
        self.title = @"NOW SHOWING";
    }
    
    self.navigationController.title = @"MOVIES";
    
    self.pageControl.currentPage = page;
    
    self.scrollView.pagingEnabled = true;

    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}


- (void) tapPoster:(UIButton*) sender
{
    if(self.title == @"NOW SHOWING")
    {
        NSLog(@"NOW SHOWING:film %d",sender.tag);
    }
    else
    {
        NSLog(@"COMING SOON:film %d",sender.tag);
    }
}



- (void)CreatePosters:(UIScrollView *)scrollView1 moviesContainer1:(NSArray *)moviesContainer1
{
    
    
    //Add posters to Scrollview
    
   
    
    for (int i = 0; i<moviesContainer1.count;i++)
    {
        
       
        
        NSString * urlString = [[NSString alloc] initWithString:[[moviesContainer1 objectAtIndex:i] valueForKey:@"ImageUrl"]];
        
        int Ypos = (i/2)*150 + 15*(i/2) + 5;
        
        int Xpos = (i - (i/2)*2)*150 + 10;
        
        //Create poster
        
        UIButton *poster = [[UIButton alloc] initWithFrame:CGRectMake(Xpos,Ypos,150,150)];
        
        poster.tag = i;
        
        [poster addTarget:self action:@selector(tapPoster:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
        
        HJManagedImageV * asynchcImage = [[HJManagedImageV alloc] initWithFrame:CGRectMake(0,0,150,150)];
        
        asynchcImage.url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://www.galaxycine.vn/%@",urlString] ];
        
        
        [asynchcImage showLoadingWheel];
        
        
        
        [poster addSubview:asynchcImage];
        
        [scrollView1 addSubview:poster];
        
        
        [[HJCache getHJObjManager] manage:asynchcImage];
        
        
        [poster release];
        [urlString release];
        [asynchcImage release];
        
        
    }
    
    
}

- (void) getSpecifiedMoviesAndShowThem:(NSString*) urlString 
                  moviesContainerIndex:(int) moviesContainerindex 
                            scrollView:(UIScrollView *) scrollView1 
{
    
    
    
    
    //Get now showing movies
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        
        if(moviesContainerindex ==0 )
            
        {
            nowShowingMovies = (NSArray*) [JSON objectForKey:@"Data"];
            
                       
            [nowShowingMovies retain];
        
        
            [self CreatePosters:scrollView1 moviesContainer1:nowShowingMovies];
            
            scrollView1.contentSize = CGSizeMake( 320, (((nowShowingMovies.count/2)+(nowShowingMovies.count%2))*150)+150);
        }
        else
        {
            comingSoonMovies = (NSArray*) [JSON objectForKey:@"Data"];
            
            [comingSoonMovies retain];
            
            [self CreatePosters:scrollView1 moviesContainer1:comingSoonMovies];
            
             scrollView1.contentSize = CGSizeMake( 320, (((comingSoonMovies.count/2)+(comingSoonMovies.count%2))*150)+150);
        }
        
       // scrollView1.contentSize = CGSizeMake( 320, 900);
        
        [scrollView addSubview:scrollView1];
        
        [scrollView1 release];
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
        
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 320, 400.0)];
        myLabel.font = [UIFont fontWithName:@"Arial" size: 12.0];
        myLabel.textColor = [UIColor redColor];
       
        myLabel.textAlignment = UITextAlignmentCenter;
        
        
        myLabel.text = @"SORRY,THE DEVICE CAN'T LOAD DATA";
        

        
        
        [scrollView addSubview:scrollView1];

        [scrollView1 addSubview:myLabel];
        
        [myLabel release];
        
        [scrollView1 release];
        
    }];
    
    [operation start];
    
    [url release];

}



@end
