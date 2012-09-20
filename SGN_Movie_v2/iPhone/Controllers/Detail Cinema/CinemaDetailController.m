//
//  DetaiCinemaController.m
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "CinemaDetailController.h"
#import "ShowtimesController.h"
#import "CinemaGalleryController.h"
#import "MapKitDisplayController.h"

#import "SGNDataService.h"
#import "Cinema.h"
#import "Movie.h"
#import "Sessiontime.h"

#import "SGNTableViewCellStyleDefault.h"
#import "SGNTableViewCellStyleImage.h"
#import "SGNTableViewCellStyleValue2.h"
#import "SGNTableViewCellStyleBasic.h"

#import "SGNBannerView.h"

@interface CinemaDetailController ()
@property (strong, nonatomic) Cinema *cinemaObject;
@property (assign, nonatomic) bool isFirstLoad;
@end


@implementation CinemaDetailController

@synthesize popupView = _popupView;
@synthesize tableView = _tableView;
@synthesize maskView = _maskView;
@synthesize cinemaObjectId = _cinemaObjectId;
@synthesize cinemaObject = _cinemaObject;
@synthesize isFirstLoad = _isFirstLoad;

#pragma mark Initialization
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
	
    self.title = @"DETAIL CINEMA";
    self.isFirstLoad = true;
    
    //create pop up view
    [self setPopupView:[[SGNCustomPopup alloc] initWithNibName:@"SGNCustomPopup"]];
    _popupView.delegate = self;
    
    //add gesture for mask view
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removePopup)];
    [tapGR setNumberOfTapsRequired:1];
    [_maskView addGestureRecognizer:tapGR];
    
    //update data
    [[SGNRepository sharedInstance]updateEntityWithUrlString:UPDATE_ALL_URL];
    
    //Google AdMob
    SGNBannerView *bannerView = [[SGNBannerView alloc] initWithNibName:@"SGNBannerView"];
    [self.view addSubview:bannerView];
    [bannerView start];
}

- (void) viewWillAppear:(BOOL)animated
{
    if(_isFirstLoad)
        [self reloadInputViews];
    _isFirstLoad = false;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.popupView loadViewWithData:nil isMovie:true];
    self.popupView = nil;
    self.maskView = nil;
    self.tableView = nil;
    self.cinemaObject = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)reloadInputViews
{
    NSManagedObjectContext *context = [SGNDataService defaultContext];
    
    [self setCinemaObject:[Cinema selectByCinemaId:_cinemaObjectId context:context]];
    if(_cinemaObject == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update Data" 
                                                        message:@"New Data was updated" 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    [_tableView reloadData];
    NSLog(@"DETAIL CINEMA - TABLE RELOAD");
}

#pragma mark Actions

- (void)showGallery
{
    CinemaGalleryController *cinemaGalleryController = [[CinemaGalleryController alloc] initWithNibName:@"CinemaGalleryView" 
                                                                                                 bundle:nil];
    cinemaGalleryController.cinemaObjectId = _cinemaObjectId;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Back" 
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    [self.navigationController pushViewController:cinemaGalleryController animated:YES];
}

- (void)showPopup
{
    NSManagedObjectContext *context = [SGNDataService defaultContext];
    NSArray *movieIds = [Sessiontime selectMovieIdsByCinemaId:[_cinemaObject cinemaId].intValue context:context];
    NSArray *movieObject = [Movie selectByArrayIds:[movieIds valueForKey:@"movieId"] context:context];
    
    //reload Data for list poster movies
    [_popupView loadViewWithData:movieObject isMovie:true];
    
    [[self view] addSubview:_maskView];
    [[self view] addSubview:_popupView];
    [_popupView popUp];
}

- (void)showMap
{
    MapKitDisplayController * mapKitController = [[MapKitDisplayController alloc] initWithNibName:@"MapKitDisplayView" bundle:nil];
    [mapKitController setCinemaName:[_cinemaObject name]];
    [mapKitController setCinemaAddress:[_cinemaObject address]];
    [mapKitController setLatitude:[_cinemaObject latitude]];
    [mapKitController setLongitude:[_cinemaObject longitude]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Back" 
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    [[self navigationController] pushViewController:mapKitController animated:YES];
}

- (void)removePopup
{
    [_maskView removeFromSuperview];
    [_popupView popDown:nil];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;    
    if(row == 1 || row == 3 || row == 6)
    {
        //cell use like 'section'
        return TABLE_SECTION_FOOTER_HEIGHT;
    }
    else if(row == 0)
    {
        return TABLE_CELLIMAGE_HEIGHT;
    }
    else 
    {
        return TABLE_CELLDEFAULT_HEIGHT;
    }
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_cinemaObject == nil)
        return nil;
    
    static NSString *cellStyleImage = @"SGNTableViewCellStyleImage";
    static NSString *cellStyleDefault = @"SGNTableViewCellStyleDefault";
    static NSString *cellStyleBasic = @"SGNTableViewCellStyleBasic";
    static NSString *cellStyleSection = @"UITableViewCell";
    
    switch (indexPath.row) 
    {
        case 0:
        {
            SGNTableViewCellStyleImage *cell = [_tableView dequeueReusableCellWithIdentifier:cellStyleImage];
            if(cell == nil)
            {
                cell = [[SGNTableViewCellStyleImage alloc] initWithNibName:cellStyleImage];
                cell.movieImage.imageContentMode = UIViewContentModeScaleAspectFill;
            }
            
            NSString *hostUrl = [AppDelegate currentDelegate].rightMenuController.provider.hostUrl;
            NSString *image_url = [hostUrl stringByAppendingString:_cinemaObject.imageUrl];
            [cell.movieImage setImageFromURL:image_url];
            
            return cell;
            break;
        }
        case 2:
        {
            SGNTableViewCellStyleBasic *cell = [_tableView dequeueReusableCellWithIdentifier:cellStyleBasic];
            if(cell == nil)
            {
                cell = [[SGNTableViewCellStyleBasic alloc] initWithNibName:cellStyleBasic];
                UIFont *font = cell.contentLabel.font;
                cell.contentLabel.font = [UIFont fontWithName:font.fontName size:17];
            }
            cell.contentLabel.textAlignment = UITextAlignmentCenter;
            cell.contentLabel.textColor = COLOR_CONTENT;
            cell.contentLabel.text = [_cinemaObject.name uppercaseString];
            return cell;
            break;        
        }
        case 4: case 5: case 7: case 8:
        {
            SGNTableViewCellStyleDefault *cell = [_tableView dequeueReusableCellWithIdentifier:cellStyleDefault];
            if(cell == nil)
            {
                cell = [[SGNTableViewCellStyleDefault alloc] initWithNibName:cellStyleDefault];
                cell.iconImageView.imageContentMode = UIViewContentModeScaleAspectFit;
            }
            
            if(indexPath.row == 4)
            {
                [cell.iconImageView setImageFromURL:@"address.png"];
                cell.contentLabel.text = _cinemaObject.address;
                UIFont *font = cell.contentLabel.font;
                cell.contentLabel.font = [UIFont fontWithName:font.fontName size:13];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else if(indexPath.row == 5)
            {
                [cell.iconImageView setImageFromURL:@"phone.png"];
                cell.contentLabel.text = _cinemaObject.phone;
                UIFont *font = cell.contentLabel.font;
                cell.contentLabel.font = [UIFont fontWithName:font.fontName size:15];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            if(indexPath.row == 7)
            {
                [cell.iconImageView setImageFromURL:@"gallery.png"];
                UIFont *font = cell.contentLabel.font;
                cell.contentLabel.font = [UIFont fontWithName:font.fontName size:15];
                cell.contentLabel.text = @"GALLERY";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;                
            }
            else if(indexPath.row == 8)
            {
                [cell.iconImageView setImageFromURL:@"showtimes.png"];
                UIFont *font = cell.contentLabel.font;
                cell.contentLabel.font = [UIFont fontWithName:font.fontName size:15];
                cell.contentLabel.text = @"SHOWTIMES";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;             
            }
            
            return cell;
            break;
        }
        default:
        {
            UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellStyleSection];
            if(cell ==nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStyleSection];
                cell.contentView.backgroundColor = [UIColor blackColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    
    if(row == 4)
    {
        [self showMap];
        
    }
    else if(indexPath.row == 7)
    {
        [self showGallery];
        
    }
    else if(row == 8)
    {
        [self showPopup];
    }
}

#pragma mark UIAlertViewDelegate

//after click on alert notice "data were updated"
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[AppDelegate currentDelegate].navigationController popToRootViewControllerAnimated:YES];
    
}
#pragma mark SGNRepositoryDelegate

- (void)RepositoryStartUpdate:(SGNRepository *)repository
{
    NSLog(@"DETAIL CINEMA - DELEGATE START");
}

- (void)RepositoryFinishUpdate:(SGNRepository *)repository
{
    if([repository isUpdateMovie] == YES || [repository isUpdateCinema] == YES)
    {
        [self reloadInputViews];
        repository.isUpdateCinema = false;
    }
    NSLog(@"DETAIL CINEMA - DELEGATE FINISH");
}

#pragma mark SGNCustomPopupDelegate

- (void)SGNCustomPopupTap:(SGNCustomPopup*)customPopup withObject:(id)object
{
    [_maskView removeFromSuperview];
    ShowtimesController *showtimesController = [[ShowtimesController alloc] initWithNibName:@"ShowTimesView" 
                                                                                     bundle:nil];
    Movie *movie = (Movie*)object;
    [showtimesController setCinemaObjectId:[_cinemaObject cinemaId].intValue];
    [showtimesController setMovieObjectId:[movie movieId].intValue];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Back" 
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    [[self navigationController]pushViewController:showtimesController animated:YES];
}

@end
