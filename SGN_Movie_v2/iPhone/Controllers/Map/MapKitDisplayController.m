//
//  MapKitDisplayController.m
//  SGN_Movie_v2
//
//  Created by vnicon on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapKitDisplayController.h"
#import "DisplayMap.h"
#import "Cinema.h"

#import "SGNBannerView.h"

@interface MapKitDisplayController ()
@property (strong,nonatomic) MKMapView * mapView;
@end

@implementation MapKitDisplayController
@synthesize cinemaName = _cinemaName;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize cinemaAddress = _cinemaAddress;
@synthesize mapView = _mapView;


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
    [self setTitle:_cinemaName];
    [_mapView setMapType:MKMapTypeStandard];
	[_mapView setZoomEnabled:YES];
	[_mapView setScrollEnabled:YES];
	MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } }; 
  
    //Convert from NSString to NSNumber
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    region.center.latitude = _latitude.floatValue;
	region.center.longitude = _longitude.floatValue;
    region.span.longitudeDelta = 0.01f;
	region.span.latitudeDelta = 0.01f;
	[_mapView setRegion:region animated:YES]; 
    _mapView.showsUserLocation = YES;
	[_mapView setDelegate:self];
    
    //Add a ann to map
	DisplayMap *ann = [[DisplayMap alloc] init]; 
	ann.title = _cinemaName;
	ann.subtitle = _cinemaAddress; 
	ann.coordinate = region.center;
    [_mapView addAnnotation:ann];
    
    [self.view addSubview:_mapView];
    
    //Google AdMob
    SGNBannerView *bannerView = [[SGNBannerView alloc] initWithNibName:@"SGNBannerView"];
    [self.view addSubview:bannerView];
    [bannerView start];
    
}
-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:
(id <MKAnnotation>)annotation {
	MKPinAnnotationView *pinView = nil; 
	if(annotation != _mapView.userLocation) 
	{
		static NSString *defaultPinID = @"com.invasivecode.pin";
		pinView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
		if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
                                         initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
		pinView.pinColor = MKPinAnnotationColorRed; 
		pinView.canShowCallout = YES;
		pinView.animatesDrop = YES;
    } 
	else {
		[_mapView.userLocation setTitle:@"I am here"];
	}
    
    return pinView;
    
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setCinemaName:nil];
    [self setCinemaAddress:nil];
    [self setLatitude:nil];
    [self setLongitude:nil];
    [self setMapView:nil];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark ReloadView
-(void) reloadView
{
    
}

@end
