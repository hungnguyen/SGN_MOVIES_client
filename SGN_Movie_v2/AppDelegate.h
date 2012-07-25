//
//  AppDelegate.h
//  SGN_Movie_v2
//
//  Created by vnicon on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MoviesController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MoviesController *viewController;

@property (strong, nonatomic) UINavigationController *moviesNavigationController;

@property (strong, nonatomic) UINavigationController *cinemasNavigationController;

@property (strong, nonatomic) UITabBarController *tabbarController;


@end
