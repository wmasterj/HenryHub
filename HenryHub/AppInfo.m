//
//  InSide.m
//  Henry Hi
//
//  Created by Jeroen van den Eijkhof, jeroen@uw.edu on 11. 5. 9..
//

#import "AppInfo.h"
#import "HubXMLConnection.h"
#import "HubPieceView.h"
#import "HubPieceImage.h"
#import "HubPiece.h"
#import "Video.h"
#import "HenryHubAppDelegate.h"

#import "ZBarSDK.h"
#import "Finch.h"
#import "Sound.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>

@implementation AppInfo

@synthesize backButton = _backButton;
@synthesize infoScroll = _infoScroll;

-(IBAction)backToStart
{
    [UIView beginAnimations:@"back" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view.superview cache:YES];
    if(self.view == nil) NSLog(@"self.view not there");
    [self.view removeFromSuperview];
    [UIView commitAnimations];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UIView methods

- (void)didReceiveMemoryWarning
{
    NSLog(@">>  InSide: Memory warning! <<");
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    // Rounded corners
    [[self.backButton layer] setCornerRadius:3];
    [self.backButton setClipsToBounds:YES];
    
    // Setup CREDITS/THANKS scroll view
    self.infoScroll.contentSize = CGSizeMake(319, 154);
    self.infoScroll.scrollEnabled = YES;
    self.infoScroll.pagingEnabled = YES; // Snaps it
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    NSLog(@"InSide view did UN-load");
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end