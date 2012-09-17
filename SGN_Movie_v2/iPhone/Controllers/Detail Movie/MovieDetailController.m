//
//  MovieDetailController.m
//  SGN_Movie_v2
//
//  Created by vnicon on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MovieDetailController.h"
#import "TrailerController.h"
#import "ShowtimesController.h"
#import "MovieGalleryController.h"

#import "SGNDataService.h"
#import "MovieGallery.h"
#import "Sessiontime.h"

#import "SGNTableViewCellStyleBasic.h"
#import "SGNTableViewCellStyleDefault.h"
#import "SGNTableViewCellStyleValue2.h"
#import "SGNTableViewCellStyleImage.h"

@interface MovieDetailController ()
@property (strong, nonatomic) Movie *movieObject;
@property (assign, nonatomic) bool isFirstLoad;
@property (assign, nonatomic) int countCinemas;
@end

@implementation MovieDetailController

@synthesize tableView = _tableView;
@synthesize popupView = _popupView;
@synthesize maskView = _maskView;
@synthesize movieObject = _movieObject;
@synthesize movieObjectId = _movieObjectId;
@synthesize countCinemas = _countCinemas;
@synthesize isFirstLoad = _isFirstLoad;

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
    
    self.title = @"DETAIL MOVIE";
    self.isFirstLoad = true;
    
    //create popup view
    self.popupView = [[SGNCustomPopup alloc] initWithNibName:@"SGNCustomPopup"];
    _popupView.delegate = self;
    _popupView.carousel.type = iCarouselTypeRotary;
    
    //add gesture for mask view
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removePopup)];
    tapGR.numberOfTapsRequired = 1;
    [_maskView addGestureRecognizer:tapGR];
    
    //update data
    [[SGNRepository sharedInstance]updateEntityWithUrlString:UPDATE_ALL_URL];
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
    self.tableView = nil;
    [self.popupView loadViewWithData:nil isMovie:false];
    self.popupView = nil;
    self.maskView = nil;
    self.movieObject = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)reloadInputViews
{
    NSLog(@"DETAIL MOVIE  - RELOAD DATA");
    NSManagedObjectContext *context = [SGNDataService defaultContext];
    self.movieObject = [Movie selectByMovieId:_movieObjectId context:context];
    
    if(_movieObject != nil)
    {
        [_tableView reloadData];
        NSLog(@"DETAIL MOVIE - TABLE - RELOAD DATA");
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update Data" 
                                                        message:@"New Data was updated" 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark Actions 

- (void)showTrailer
{
    //Create a view to play trailer    
    TrailerController * trailerController = [[TrailerController alloc] initWithNibName:@"TrailerView" bundle:nil];
    NSString * trailerUrl = [[NSString alloc] initWithFormat:@"%@",[_movieObject trailerUrl]];
    [trailerController createYouTubePlayer:[NSURL URLWithString:trailerUrl]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Back" 
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    self.navigationItem.backBarButtonItem = backButton;
    [self.navigationController pushViewController:trailerController animated:YES];
}

- (void)showShowTime
{
    NSManagedObjectContext *context = [SGNDataService defaultContext];
    NSArray *cinemaIds = [Sessiontime selectCinemaIdsByMovieId:[_movieObject movieId].intValue context:context];
    NSArray *cinemaObjects = [Cinema selectByArrayIds:[cinemaIds valueForKey:@"cinemaId"] context:context];
    self.countCinemas = [cinemaIds count];
    
    if(_countCinemas > 0)
    {
        [_popupView loadViewWithData:cinemaObjects isMovie:false];
        [[self view] addSubview:_maskView];
        [[self view] addSubview:_popupView];
        [_popupView popUp];
    }
    else 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Sorry, there is no cinema show this movie" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)showGallery
{
    MovieGalleryController *movieGalleryController = [[MovieGalleryController alloc] initWithNibName:@"MovieGalleryView" 
                                                                                              bundle:nil];
    movieGalleryController.movieObjectId = _movieObjectId;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Back" 
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    self.navigationItem.BackBarButtonItem = backButton;
    [self.navigationController pushViewController:movieGalleryController animated:YES];
    
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
    return 14;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    if(row == 1 || row == 3 || row == 7 || row == 12)
    {
        //cell uses like 'section'
        return TABLE_SECTION_FOOTER_HEIGHT;
    }
    else if(row == 0)
    {
        //image cell
        return TABLE_CELLIMAGE_HEIGHT;
    }
    else if(row == 13)
    {
        //description cell
        CGSize size = CGSizeMake(_tableView.bounds.size.width, 9999);
        //increase font to 2point to get bigger label size
        UIFont *font = [UIFont fontWithName:TABLE_CELL_FONTNAME size:TABLE_CELL_FONTSIZE + 2];
        
        CGSize expectedLabelSize = [_movieObject.movieDescription sizeWithFont:font
                                                             constrainedToSize:size
                                                                 lineBreakMode:UILineBreakModeWordWrap];  
        return expectedLabelSize.height; 
    }
    else 
    {
        //normal cell
        return TABLE_CELLDEFAULT_HEIGHT;
    }
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_movieObject == nil)
        return nil;
    
    static NSString *cellStyle2 = @"SGNTableViewCellStyleValue2";
    static NSString *cellStyleImage = @"SGNTableViewCellStyleImage";
    static NSString *cellStyleBasic = @"SGNTableViewCellStyleBasic";
    static NSString *cellStyleDefault = @"SGNTableViewCellStyleDefault";
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
            NSString *image_url = [hostUrl stringByAppendingString:_movieObject.imageUrl];
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
            }
            
            UIFont *font = cell.contentLabel.font;
            cell.contentLabel.font = [UIFont fontWithName:font.fontName size:17];
            cell.contentLabel.textAlignment = UITextAlignmentCenter;
            cell.contentLabel.textColor = cell.contentColor;
            NSLog(@"%@", cell.contentColor);
            cell.contentLabel.text = [_movieObject.title uppercaseString];
            return cell;
            break;
        }
        case 4: case 5: case 6:
        {
            SGNTableViewCellStyleDefault *cell = [_tableView dequeueReusableCellWithIdentifier:cellStyleDefault];
            if(cell == nil)
            {
                cell = [[SGNTableViewCellStyleDefault alloc] initWithNibName:cellStyleDefault];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.iconImageView.imageContentMode = UIViewContentModeScaleAspectFit;
                UIFont *font = cell.contentLabel.font;
                cell.contentLabel.font = [UIFont fontWithName:font.fontName size:15];
            }
            
            if(indexPath.row == 4)
            {   
                [cell.iconImageView setImageFromURL:@"trailer.png"];
                cell.contentLabel.text = @"TRAILER";
            }
            else if(indexPath.row == 5)
            {
                [cell.iconImageView setImageFromURL:@"gallery.png"];
                cell.contentLabel.text = @"GALLERY";
            }
            else if(indexPath.row == 6)
            {
                [cell.iconImageView setImageFromURL:@"showtimes.png"];
                cell.contentLabel.text = @"SHOWTIMES";
            }
            return cell;
            break;
        }
        case 8: case 9: case 10: case 11:
        {
            SGNTableViewCellStyleValue2 *cell = [_tableView dequeueReusableCellWithIdentifier:cellStyle2];
            if(cell == nil)
            {
                cell = [[SGNTableViewCellStyleValue2 alloc] initWithNibName:cellStyle2];
            }
            
            if(indexPath.row == 8)
            {
                cell.titleLabel.text = @"The loai";
                cell.contentLabel.text = _movieObject.genre;
            }
            else if(indexPath.row == 9)
            {
                cell.titleLabel.text = @"Phien ban";
                cell.contentLabel.text = _movieObject.version;
            }
            
            if(indexPath.row == 10)
            {
                cell.titleLabel.text = @"Dien vien";
                cell.contentLabel.text = _movieObject.cast;
            }
            else if(indexPath.row == 11)
            {
                cell.titleLabel.text = @"Dao dien";
                cell.contentLabel.text = _movieObject.director;
            }
            return cell;
            break;
        }
        case 13:
        {
            SGNTableViewCellStyleBasic *cell = [_tableView dequeueReusableCellWithIdentifier:cellStyleBasic];
            if(cell == nil)
            {
                cell = [[SGNTableViewCellStyleBasic alloc] initWithNibName:cellStyleBasic];
            }
            UIFont *font = cell.contentLabel.font;
            cell.contentLabel.font = [UIFont fontWithName:font.fontName size:13];
            cell.contentLabel.textAlignment = UITextAlignmentLeft;
            cell.contentLabel.textColor = cell.titleColor;
            NSLog(@"%@", cell.titleColor);
            cell.contentLabel.text = _movieObject.movieDescription;
            return cell;
            break;
        }
        default:
        {
            UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellStyleSection];
            if(cell == nil)
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
        [self showTrailer];
    }
    else if(row == 5)
    {
        [self showGallery];
    }
    else if(row == 6)
    {
        [self showShowTime];
    }
}

#pragma mark SGNCustomPopupDelegate

- (void)SGNCustomPopupTap:(SGNCustomPopup*)customPopup withObject:(id)object
{
    [_maskView removeFromSuperview];
    ShowtimesController *showtimesController = [[ShowtimesController alloc] initWithNibName:@"ShowTimesView" 
                                                                                     bundle:nil];
    Cinema *cinema = (Cinema*)object;
    showtimesController.cinemaObjectId = [cinema cinemaId].intValue;
    showtimesController.movieObjectId = [_movieObject movieId].intValue;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Back" 
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    [[self navigationController]pushViewController:showtimesController animated:YES];
}

#pragma mark SGNRepositoryDelegate

- (void)RepositoryStartUpdate:(SGNRepository *)repository
{
    NSLog(@"DETAIL MOVIE - DELEGATE START");
}

- (void)RepositoryFinishUpdate:(SGNRepository *)repository
{
    if(repository.isUpdateMovie == YES)
    {
        [self reloadInputViews];
        repository.isUpdateMovie = NO;
    }
    NSLog(@"DETAIL MOVIE - DELEGATE FINISH");
}

#pragma mark UIAlertViewDelegate

//after click on alert notice "data were updated"
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(_movieObject == nil)
    {
        [[AppDelegate currentDelegate].navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
