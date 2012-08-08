//
//  MapKitDisplayController.m
//  SGN_Movie_v2
//
//  Created by vnicon on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapKitDisplayController.h"

@interface MapKitDisplayController ()

@end

@implementation MapKitDisplayController

@synthesize mapView = _mapView;
@synthesize cinemaObject = _cinemaObject;

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
    [self setTitle:[_cinemaObject valueForKey:@"Name"]];
    [_mapView setMapType:MKMapTypeStandard];
	[_mapView setZoomEnabled:YES];
	[_mapView setScrollEnabled:YES];
	MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } }; 
  
    //Convert from NSString to NSNumber
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * latitudeNumber = [f numberFromString:[NSString stringWithFormat:@"%@",[_cinemaObject valueForKey:@"Latitude"]]];
    NSNumber * longitudeNumber = [f numberFromString:[NSString stringWithFormat:@"%@",[_cinemaObject valueForKey:@"Longitude"]]];

    region.center.latitude = latitudeNumber.floatValue;
	region.center.longitude = longitudeNumber.floatValue;
    region.span.longitudeDelta = 0.01f;
	region.span.latitudeDelta = 0.01f;
	[_mapView setRegion:region animated:YES]; 
    _mapView.showsUserLocation = YES;
	[_mapView setDelegate:self];
    
    //Add a ann to map
	DisplayMap *ann = [[DisplayMap alloc] init]; 
	ann.title = [_cinemaObject valueForKey:@"Name"];
	ann.subtitle = [_cinemaObject valueForKey:@"Address"]; 
	ann.coordinate = region.center; 
	[_mapView addAnnotation:ann];
    
    [self.view addSubview:_mapView];
    
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
