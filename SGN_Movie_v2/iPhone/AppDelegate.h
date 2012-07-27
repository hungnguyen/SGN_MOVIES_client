//
//  AppDelegate.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"

@class MoviesController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MoviesController *viewController;

@property (strong, nonatomic) UINavigationController *moviesNavigationController;

@property (strong, nonatomic) UINavigationController *cinemasNavigationController;

@property (strong, nonatomic) UITabBarController *tabbarController;

@property (strong, nonatomic) IIViewDeckController* deckController;

+(AppDelegate *) currentDelegate;

@end

static AppDelegate * appDelegate;
