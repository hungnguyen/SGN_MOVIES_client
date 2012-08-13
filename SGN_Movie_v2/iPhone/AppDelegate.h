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
#import <CoreData/CoreData.h>

#define PROVIDER_URL @"http://www.galaxycine.vn/"

@class MoviesController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) IIViewDeckController *deckController;

+(AppDelegate *) currentDelegate;
- (NSURL *)applicationDocumentsDirectory;

@end

