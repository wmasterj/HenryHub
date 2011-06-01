//
//  Share.m
//  HenryHub
//
//  Created by Ohyoon Kwon on 11. 5. 10..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HubPieceView.h"
#import "HubXMLConnection.h"
#import "HubPieceImage.h"
#import "TBXML.h"
#import "HubPiece.h"
#import "InSide.h"
#import "Video.h"
#import "Related.h"
#import "FBConnect.h"

// Facebook Connect variables
NSString *const kAppId = @"154049007996025";
NSString *const kAppKey = @"f5c29dab6560b715d6864cd4fd3eb6d1";
NSString *const kAppSecret = @"8f3c6c6457d882065a253e036ce0e66a";

@implementation HubPieceView

@synthesize pieceConnection = _pieceConnection, currentPiece = _currentPiece;
@synthesize hub_title = _hub_title, hub_artist = _hub_artist;
@synthesize backgroundImage = _backgroundImage, menu_layer = _menu_layer;
@synthesize hub_description = _hub_description, hub_info = _hub_info;
@synthesize backButton = _backButton, movingMenu = _movingMenu,sub_menu = _sub_menu;
@synthesize video_view = _video_view, related_view = _related_view;
@synthesize contentViewFrame = _contentViewFrame, spinner = _spinner;
@synthesize facebook = _facebook, showingBackground = _showingBackground;
@synthesize pieceLoaded = _pieceLoaded;

#pragma mark -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // do stuff
    }
    return self;
}

#pragma mark - Data event callbacks

-(void)dataDidDownload:(BOOL)success // delegate set to this object from InSide.m
{
    NSLog(@"Data downloaded YEAY!");
    
    // Parsing the XML data
    //
    TBXML *tbxml = [[TBXML tbxmlWithXMLString:self.pieceConnection.stringXML] retain];
    
    // Get the piece XML
    TBXMLElement *rootElement = tbxml.rootXMLElement;
    TBXMLElement *pieceXML = [TBXML childElementNamed:@"piece" parentElement:rootElement];
    
    // Create the HubPiece data from the XML file
    if(self.currentPiece != nil){
        [self.currentPiece release];
    }
    
    self.currentPiece = [[HubPiece alloc] initWithXML:pieceXML]; // LEAKING a little
    
    // If it returns something with an ID, then go ahead and show the rest of the stuff
    if(self.currentPiece.piece_id) 
    {
        [self displayInformation];
    }
    else
    {
        NSLog(@"QR code invalid, didn't find an object matching the QR code.");
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Oops, wrong code"
                              message:@"It seems that you scanned a QR code that doesn't correspond to a Henry Art Gallery object. Please try again with another QR code."
                              delegate:self 
                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    [tbxml release];
}

/*!
 * @abstract: Display the data when self.currentPiece has been loaded
 */
-(void)displayInformation
{
    // Add title to UI
    self.hub_title.text = self.currentPiece.piece_name;
    
    // Add artist name
    self.hub_artist.text = self.currentPiece.piece_artist;
    
    // Main image 
    HubPieceImage *tmpImage;
    if((tmpImage = [self.currentPiece.images anyObject]))
    {
        if(tmpImage.image_asset_url)
        {
            self.backgroundImage.image = [UIImage imageWithData:
                                          [NSData dataWithContentsOfURL: 
                                           [NSURL URLWithString:tmpImage.image_asset_url]]];
        } else {
            NSLog(@"ERROR: No image URL!");
        }
    }
    
    // Add description to UI
    self.hub_description.text = self.currentPiece.piece_description;
    
    // Show the UI controls that are hiding before everything has loaded
    // TODO: Animate these into the view
    self.sub_menu.hidden = NO;
    
//    NSInvocation *invoc = [NSInvocation invocationWithMethodSignature:[HubPieceView instanceMethodSignatureForSelector:@selector(hideBackButton:)] ];                   
//    [invoc setTarget:self];
//    [invoc setSelector:@selector(hideBackButton:)];
//    [invoc setArgument:NO atIndex:2];
//    [NSTimer scheduledTimerWithTimeInterval:1 invocation:invoc repeats:NO];

//    
//    [NSTimer scheduledTimerWithTimeInterval:1 
//                                     target:self 
//                                   selector:@selector(hideHeader:NO) 
//                                   userInfo:nil 
//                                    repeats:NO];
    [self hideBackButton:NO];
    [self hideHeader:NO];
    
    [self.spinner stopAnimating];
    
    NSLog(@"All things are showing");
}

-(void)dataDidNotDownload:(BOOL)success // delegate set to this object from InSide.m
{
    NSLog(@"INTERNET: No connection!");
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"No internet connection"
                          message:@"You are not connected to the internet, make sure it isn't in Flight mode and that services for data transfer are turned on (3G, WiFi)."
                          delegate:self 
                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

-(void)dataResultInvalid:(BOOL)success
{
    NSLog(@"Returned data was to small of an amount to be valid");
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"Crazy failure"
                          message:@"Something seems to have gone wrong with reading the information, please try again."
                          delegate:self 
                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Connection was lost and after clicking this it goes back to the instruction page
    if(alertView.title == @"No internet connection")
        [self backToScan:nil];
    
    // The QR code scanned, but the returned data couldnt be parsed to return an id string.
    if(alertView.title == @"Oops, wrong code")
        [self backToScan:nil];
    
    // Returned data was to small of an amount to be valid
    if(alertView.title == @"Crazy failure")
        [self backToScan:nil];
}

#pragma mark - Showing And Hiding methods

- (IBAction)hideAllViews:(id)sender
{
    // Hide ALL content views
    self.video_view.view.hidden = YES;
    self.related_view.view.hidden = YES;
    self.hub_info.hidden = YES;
}

- (IBAction)hideMenu:(id)sender
{
    // Tell the menu where to animate to
    CGRect viewFrame = self.sub_menu.frame;
    viewFrame.origin.y = 430;
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:MENU_ANIMITATION_DURATION];
    
    [self.sub_menu setFrame:viewFrame];
    
    [UIView commitAnimations];
    
    [self hideBackButton:YES];
    [self hideHeader:YES];
    self.menu_layer.hidden = NO;
}

- (IBAction)showMenu:(id)sender
{
    // Tell the menu where to animate to
    CGRect viewFrame = self.sub_menu.frame;
    viewFrame.origin.y = 384;
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:MENU_ANIMITATION_DURATION];
    
    [self.sub_menu setFrame:viewFrame];
    
    [UIView commitAnimations];
    
    [self.video_view closeYoutubeVideo:nil];
    [self hideHeader:NO];
    [self hideBackButton:NO];
    self.menu_layer.hidden = YES;
    
    
    [self hideAllViews:sender];
}

-(IBAction)showBackground:(id)sender
{
    [self hideMenu:sender];
    if([self showingBackground])
    {
        /// do something 
    }
}

- (IBAction)toggleInformation:(id)sender
{
    // Show/hide information
    if(self.hub_info.hidden == NO)
    {
        // Hide menu, this also hides all content views
        [self showMenu:sender];
    }        
    else   
    {
        // Show info content view
        self.hub_info.hidden = NO;
        [self hideMenu:sender];
    }
}

- (IBAction)flipVideo:(id)sender
{
    // Hide menu
    [self hideMenu:sender];
    [self hideAllViews:sender];
    
    if(self.video_view == nil)
        self.video_view = [[Video alloc] initWithNibName:@"Video" bundle:nil];
    self.video_view.videoListData = [self.currentPiece.videos allObjects];
    self.video_view.view.frame = self.contentViewFrame;
    self.video_view.view.hidden = NO;
    
    [self.view addSubview:self.video_view.view];
    
}

- (IBAction)flipRelated:(id)sender
{
    // Hide menu
    [self hideMenu:sender];
    [self hideAllViews:sender];
    
    if(self.related_view == nil)
        self.related_view = [[Related alloc] initWithNibName:@"Related" bundle:nil];
    self.related_view.view.frame = self.contentViewFrame;
    self.related_view.view.hidden = NO;
    
    [self.view addSubview:self.related_view.view];
    
}

- (IBAction)flipSharing:(id)sender
{
    // Hide menu
    [self hideMenu:sender];
    [self hideAllViews:sender];
    
    // Open up a Facebook dialog here, will prompt for login
    //<CHANGE>HubPieceImage *fbImage = [self.currentPiece.images objectAtIndex:0];
    NSString *fbTitle = [NSString stringWithFormat:@"Henry Art Gallery: %@", self.currentPiece.piece_name];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   kAppId, @"app_id",
                                   @"http://www.facebook.com/henryartgallery", @"link",
                                   @"", @"picture", //<CHANGE>
                                   fbTitle, @"name",
                                   self.currentPiece.piece_share_copy, @"description",
                                   @"I'm at the Henry...",  @"message",
                                   nil];
    
    [self.facebook dialog:@"feed" andParams:params andDelegate:self];
}

-(void)hideBackButton:(BOOL)doHide
{
    // Tell the history modal where to animate to
    CGRect viewFrame = self.backButton.frame;
    if(!doHide)
    {
        viewFrame.origin.x = -22; 
    }
    else
    {
        viewFrame.origin.x = -98;
    }
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  
    [UIView setAnimationDuration:0.2];
    
    [self.backButton setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(void)hideHeader:(BOOL)doHide
{
    // Tell the title where to animate
    CGRect viewFrame = self.hub_title.frame;
    if(!doHide)
    {
        viewFrame.origin.y = 11; 
        self.hub_artist.hidden = NO;
    }
    else
    {
        viewFrame.origin.y = -89;
        self.hub_artist.hidden = YES;
    }
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  
    [UIView setAnimationDuration:0.25];
    
    [self.hub_title setFrame:viewFrame];
    
    [UIView commitAnimations];
}

#pragma mark - Facebook

-(void)dialog:(FBDialog *)dialog didFailWithError:(NSError *)error
{
    NSLog(@"Facebook: Failed with error");
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"Facebook error"
                          message:@"There seems to be something wrong with sharing this art object using Facebook please try again."
                          delegate:self 
                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

-(void)dialogDidComplete:(FBDialog *)dialog
{
    [self showMenu:nil];
    NSLog(@"SHARED?!?! If so then give that feedback is possible.");
}

-(void)dialogDidNotComplete:(FBDialog *)dialog
{
    [self showMenu:nil];
}

#pragma mark - Navigation

- (IBAction)backToScan:(id)sender
{
    NSLog(@"Switching back");
    
    [UIView beginAnimations:@"In Side From Object" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown 
                           forView:self.view cache:YES];
    [self.view removeFromSuperview]; 
    [UIView commitAnimations];
}

#pragma mark - UIViewControl standard methods

- (void)dealloc
{
    [self.menu_layer release];
    [self.sub_menu release];
    [self.pieceConnection release];
    [self.hub_title release];
    [self.hub_info release];
    [self.hub_description release];
    [self.currentPiece release];
    [self.video_view release];
    [self.facebook release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    NSLog(@">>  HubPieceView: Memory warning! <<");
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{    
    NSLog(@"viewDidLoad: HubPieceView");
    // Do some initial UI setup
    self.menu_layer.hidden = YES;
    self.contentViewFrame = CGRectMake(20,84,280,334);

    // Add a spinner for loading
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:self.spinner];
    [self.spinner setCenter:CGPointMake((320/2)-5, (480/2)+30)];
    [self.spinner startAnimating];
    
    // Setup facebook object
    self.facebook = [[Facebook alloc] initWithAppId:kAppId];
    
    if(self.pieceLoaded) {
        // Doesn't have to load
        [self displayInformation];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    NSLog(@"HubPiece view did UN-load");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.menu_layer      = nil;
    self.sub_menu        = nil;
    self.pieceConnection = nil;
    self.hub_title       = nil;
    self.hub_info        = nil;
    self.hub_description = nil;
    self.currentPiece    = nil;
    self.video_view      = nil;
    self.facebook        = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end