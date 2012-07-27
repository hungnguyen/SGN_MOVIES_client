//
//  AppDelegate.m
//  SGN_Movie_v2
//
//  Created by vnicon on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MoviesController.h"

#import "CinemasController.h"

#import "AFNetworking.h"

#import "MenuController.h"


static AppDelegate * appDelegate;

@implementation AppDelegate

@synthesize window = _window;
@synthesize moviesController = _viewController;
@synthesize moviesNavigationController = _moviesNavigationController;
@synthesize cinemasNavigationController = _cinemasNavigationController
;
@synthesize deckController;

+(AppDelegate*) currentDelegate
{
    return appDelegate;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
      appDelegate = self;
    
    //Make Movies Screen
    _moviesNavigationController = [[UINavigationController alloc] init];
    [_moviesNavigationController setTitle:@"NOW SHOWING"];
    _moviesNavigationController.tabBarItem.image = [UIImage imageNamed:@"movie"];
    _viewController = [[MoviesController alloc] initWithNibName:@"MoviesView" bundle:nil];
    _moviesNavigationController.viewControllers = [NSArray arrayWithObjects:_viewController,nil];
    
    //Make Cinemas Screen
    _cinemasNavigationController = [[UINavigationController alloc] init];
    [_cinemasNavigationController setTitle:@"CINEMAS"];
    _cinemasNavigationController.tabBarItem.image = [UIImage imageNamed:@"widescreen"];
    CinemasController * cinemasController = [[CinemasController alloc] initWithNibName:@"CinemasView" bundle:nil];
    _cinemasNavigationController.viewControllers = [NSArray arrayWithObjects:cinemasController, nil];
    
    //Make Menu View
    MenuController *menuController = [[MenuController alloc] initWithNibName:@"MenuView" bundle:nil];
    
    //Make View Deck
    IIViewDeckController* deckController1 = [[IIViewDeckController alloc] initWithCenterViewController:_moviesNavigationController leftViewController:menuController];
    deckController1.rightLedge = 50;
    deckController = deckController1;
    [deckController1 setEnabled:FALSE];
    self.window.rootViewController = deckController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
