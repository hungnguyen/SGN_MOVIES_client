//
//  WEPopoverContentViewController.h
//  WEPopover
//
//  Created by Werner Altewischer on 06/11/10.
//  Copyright 2010 Werner IT Consultancy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repository.h"
#import "Provider.h"
#import "DataService.h"
@protocol WEPopoverContentDelegate <NSObject>
-(void) providerSelect:(NSString *) providerName;
@end

@interface WEPopoverContentViewController : UITableViewController {

}
@property (strong, nonatomic) NSArray * providers;
@property (assign, nonatomic) id <WEPopoverContentDelegate> delegate;
@end
