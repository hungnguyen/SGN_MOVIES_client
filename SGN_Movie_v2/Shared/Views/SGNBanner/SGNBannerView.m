//
//  SGNAdmob.m
//  admob
//
//  Created by TPL2806 on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGNBannerView.h"
#import "AppDelegate.h"

@interface SGNBannerView ()
@end

@implementation SGNBannerView

@synthesize gAdBannerView = _gAdBannerView;
@synthesize closeImageView = _closeImageView;
@synthesize closeView = _closeView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
    }
    return self;
}

- (id)initWithNibName:(NSString*)nibNameOrNil
{
    //load default NibName if does not have
    if(nibNameOrNil == nil || [nibNameOrNil isEqualToString:@""])
        nibNameOrNil = @"SGNBannerView";
    self = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] objectAtIndex:0];
    
    if(self)
    {
        _gAdBannerView.adUnitID = @"/6253334/dfp_example_ad";
        _gAdBannerView.delegate = self;
        _gAdBannerView.rootViewController = [AppDelegate currentDelegate].navigationController;
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAd)];
        tapGR.numberOfTapsRequired = 1;
        _closeImageView.userInteractionEnabled = true;
        [_closeImageView addGestureRecognizer:tapGR];

        CGRect frame =  self.frame;
        frame.origin.y = 416;
        self.frame = frame;
    }
    return self;
}

- (void)start
{
    [NSTimer scheduledTimerWithTimeInterval:2.0                          
                                     target:self            
                                   selector:@selector(startAd)             
                                   userInfo:nil                          
                                    repeats:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0                          
                                     target:self            
                                   selector:@selector(loadRequest)             
                                   userInfo:nil                          
                                    repeats:NO];
}

- (void)startAd
{
    [UIView beginAnimations:@"bannerOn" context:NULL];
    self.frame = CGRectOffset(self.frame, 0, -self.frame.size.height);
    [UIView commitAnimations];

}
- (void)closeAd
{
    [UIView beginAnimations:@"bannerOff" context:NULL];
    self.frame = CGRectOffset(self.frame, 0, self.frame.size.height);
    [UIView commitAnimations];
}

- (void) loadRequest
{
    [_gAdBannerView loadRequest:[GADRequest request]];
}

- (void) adViewDidReceiveAd:(GADBannerView *)banner
{
    [UIView beginAnimations:@"addOn" context:NULL];
    _gAdBannerView.frame = CGRectOffset(_gAdBannerView.frame, -_gAdBannerView.frame.size.width, 0);
    [UIView commitAnimations];

}

- (void) adView:(GADBannerView *)banner didFailToReceiveAdWithError:(GADRequestError *)error
{
    [UIView beginAnimations:@"bannerOff" context:NULL];
    self.frame = CGRectOffset(self.frame, 0, self.frame.size.height);
    [UIView commitAnimations];
}

@end
