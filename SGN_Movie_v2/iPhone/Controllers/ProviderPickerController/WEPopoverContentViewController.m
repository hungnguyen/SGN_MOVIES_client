//
//  WEPopoverContentViewController.m
//  WEPopover
//
//  Created by Werner Altewischer on 06/11/10.
//  Copyright 2010 Werner IT Consultancy. All rights reserved.
//

#import "WEPopoverContentViewController.h"


@implementation WEPopoverContentViewController
@synthesize providers = _providers;
@synthesize delegate = _delegate;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    
    }
    return self;
}

- (id) initwithStyle:(UITableViewStyle)style andCount:(int)count
{
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) 
    {
        self.contentSizeForViewInPopover = CGSizeMake(140, count * 44 + 1);
    }
    return self;

}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.contentSizeForViewInPopover = CGSizeMake(10, 50);

    self.tableView.rowHeight = 44.0;
	self.view.backgroundColor = [UIColor clearColor];
    [self.tableView setScrollEnabled:NO];
    [self.tableView setDelegate:self];
   
   /* NSManagedObjectContext *context = [[DataService sharedInstance] managedObjectContext];
    _providers = [Provider selectAllInContext:context];
    NSLog(@"%@",_providers);
    [self.tableView reloadData];*/
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated {
      [self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(_providers && [_providers count])
    {
        
//        Provider * temp = [_providers objectAtIndex:0];
//        NSLog(@"%@",temp.name);
        return [_providers count];
    }
    else
    {
        return 0;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    Provider * provider = [_providers objectAtIndex:indexPath.row]; 
    [cell.textLabel setText:[provider name]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
   
    if([[Repository sharedInstance] currentProviderId] == (indexPath.row+1))
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 0, 30, 30)];
        [imageView setImage:[UIImage imageNamed:@"CheckIcon.png"]];
        [cell addSubview:imageView];
        
    }
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
    Provider * provider = [_providers objectAtIndex:indexPath.row];
    [[Repository sharedInstance] setCurrentProviderId:[provider providerId].intValue];
    [[Repository sharedInstance] setCurrentURL:[provider hostUrl]];
    [_delegate providerSelect:[provider name]];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end

