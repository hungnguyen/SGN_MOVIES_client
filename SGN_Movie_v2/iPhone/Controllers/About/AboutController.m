//
//  AboutController.m
//  SGN_Movie_v2
//
//  Created by vnicon on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutController.h"

@implementation AboutController
@synthesize isToggled = _isToggled;

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
    [self setTitle:@"ABOUT"];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"about.png"]]];
    
    UIButton* menuButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 30)];
    menuButton.tag = 1;
    [menuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setImage:[UIImage imageNamed:@"btn_nav.png"] forState:UIControlStateNormal];
    
    UINavigationItem *navigationItem = [self navigationItem];
    navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [[AppDelegate currentDelegate].deckController toggleLeftView];
//    [self setIsToggled:0];
//
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark Action

- (void)showMenu:(id)sender
{
    [[AppDelegate currentDelegate].deckController toggleLeftView];
    if(_isToggled == 0)
    {
        [self setIsToggled:1];
    }
    else 
    {
        [self setIsToggled:0];
    }
}

@end
