//
//  AppDelegate.m
//  SGN_Movie_v2
//
//  Created by vnicon on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

static AppDelegate * appDelegate;

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize deckController = _deckController;

+ (AppDelegate*)currentDelegate
{
    return appDelegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //NSDate *future = [NSDate dateWithTimeIntervalSinceNow: 0.5];
    //[NSThread sleepUntilDate:future];
    [[Repository sharedInstance] setCurrentProviderId:1];
    [[Repository sharedInstance] setCurrentURL:@"http://www.galaxycine.vn"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIImage *backgroundImage = [UIImage imageNamed:@"Background8.jpg"];
    [self.window setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];      
   
    // Override point for customization after application launch.
      appDelegate = self;
    
    //Make Movies Screen
    [self setNavigationController:[[UINavigationController alloc] init]];
    MoviesController *moviesController = [[MoviesController alloc] initWithNibName:@"MoviesView"
                                                                           bundle:nil];
    [_navigationController setViewControllers:[NSArray arrayWithObjects:moviesController, nil]];
     
    //Make Menu View
    MenuController *menuController = [[MenuController alloc] initWithNibName:@"MenuView" bundle:nil];
    
    //Make View Deck
    [self setDeckController:[[IIViewDeckController alloc] initWithCenterViewController:_navigationController leftViewController:menuController]];
    [_deckController setRightLedge:40];
    [_deckController setEnabled:FALSE];
    
    self.window.rootViewController = _deckController;
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

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
