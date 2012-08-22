//
//  SGNCustomPopup.h
//  SGN_MOVIE_v2
//
//  Created by TPL2806 on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGNCustomPopup;

@protocol SGNCustomPopupDelegate <NSObject>
@optional
- (void)SGNCustomPopupTap:(SGNCustomPopup*)customPopup withObjectIndex:(int)ObjectIndex;
@end

@interface SGNCustomPopup : UIView

@property (nonatomic, assign) id<SGNCustomPopupDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIScrollView *srollView;
@property (nonatomic, strong) IBOutlet UILabel *title;

- (id)initWithNibName:(NSString*)nibNameOrNil;
- (void)loadViewWithData:(NSArray*)data;
- (void)popUp;
- (void)popDown:(id)sender;
@end
