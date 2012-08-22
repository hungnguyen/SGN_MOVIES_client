//
//  MapKitDisplayController.h
//  SGN_Movie_v2
//
//  Created by vnicon on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DisplayMap.h"
#import "Cinema.h"
#import "Repository.h"


@interface MapKitDisplayController : UIViewController <MKMapViewDelegate>
@property (strong, nonatomic) NSString * cinemaName;
@property (strong, nonatomic) NSString * cinemaAddress;
@property (strong, nonatomic) NSNumber * latitude;
@property (strong, nonatomic) NSNumber * longitude;
@end
