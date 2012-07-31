//
//  AppDelegate.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "MoviesController.h"
#import "CinemasController.h"
#import "AFNetworking.h"
#import "MenuController.h"
#define PROVIDER_URL @"http://www.galaxycine.vn/"

@class MoviesController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MoviesController *moviesController;
//@property (strong, nonatomic) MoviesController *cinemasController;
//@property (strong, nonatomic) MenuController *menuController;
@property (strong, nonatomic) UINavigationController *moviesNavigationController;
//@property (strong, nonatomic) UINavigationController *cinemasNavigationController;
@property (strong, nonatomic) IIViewDeckController *deckController;

+(AppDelegate *) currentDelegate;

@end

