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
#import "HubPiece.h"
#import "InSide.h"
#import "Video.h"
#import "Related.h"

#import "UIImageView+WebCache.h"
#import "TBXML.h"
#import "FBConnect.h"

// Facebook Connect variables
NSString *const kAppId = @"154049007996025";
NSString *const kAppKey = @"f5c29dab6560b715d6864cd4fd3eb6d1";
NSString *const kAppSecret = @"8f3c6c6457d882065a253e036ce0e66a";

@implementation HubPieceView

@synthesize pieceConnection = _pieceConnection, currentPiece = _currentPiece;
@synthesize hub_title = _hub_title, hub_artist = _hub_artist;
@synthesize backgroundImage = _backgroundImage, menu_overlay = _menu_overlay;
@synthesize hub_description = _hub_description, hub_info = _hub_info;
@synthesize backButton = _backButton, backButtonView = _backButtonView;
@synthesize movingMenu = _movingMenu,sub_menu = _sub_menu;
@synthesize video_view = _video_view, related_view = _related_view;
@synthesize contentViewFrame = _contentViewFrame, spinner = _spinner;
@synthesize facebook = _facebook, showingBackground = _showingBackground;
@synthesize pieceLoaded = _pieceLoaded;
@synthesize relatedButton = _relatedButton;
@synthesize videoButton = _videoButton;
@synthesize infoButton = _infoButton;
@synthesize shareButton = _shareButton;
@synthesize hub_likes = _hub_likes;
@synthesize fb_icon = _fb_icon;


#pragma mark -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // do stuff
    }
    return self;
}

#pragma mark - HttpDataDelegate callbacks

/**
 * Called from HubXMLConnection.m when it has received all data
 */
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

/**
 * Display the data when self.currentPiece has been loaded correctly
 */
-(void)displayInformation
{
    // Add title to UI
    self.hub_title.text = self.currentPiece.piece_name;
    
    // Add artist name
    self.hub_artist.text = self.currentPiece.piece_artist;
    
    // Add likes
    NSLog(@"Likes: %@", self.currentPiece.piece_likes);
    self.hub_likes.text = self.currentPiece.piece_likes;
    
    // Main image 
    HubPieceImage *tmpImage;
    if((tmpImage = [self.currentPiece.images anyObject]))
    {
        if(tmpImage.image_asset_url)
        {
            [self.backgroundImage setImageWithURL:[NSURL URLWithString:tmpImage.image_asset_url] ];
        } else {
            NSLog(@"ERROR: No image URL!");
        }
    }
    
    // Add description to UI
    self.hub_description.text = self.currentPiece.piece_description;
    
    // Show the UI controls that are hiding before everything has loaded
    // TODO: Animate these into the view
    self.sub_menu.hidden = NO;
    
    self.backButtonView.hidden = NO;
    [self hideBackButton:NO];
    [self hideHeader:NO];
    
    [self.spinner stopAnimating];
    
    NSNumber *videoCount = [NSNumber numberWithUnsignedInteger:[self.currentPiece.videos count]];
    if([videoCount intValue] < 1) 
    {
        // NSLog(@"NO VIDEOS");
        [self.videoButton setEnabled:NO];
    }
    
    NSNumber *relatedCount = [NSNumber numberWithUnsignedInteger:[self.currentPiece.related count]];
    if([relatedCount intValue] < 1) 
    {
        // NSLog(@"NO RELATED CONTENT");
        [self.relatedButton setEnabled:NO];
    }
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

/**
 * This animates the menu buttons wrapper view up and down
 */
- (void)hideMenu: (BOOL)doHide
{
    // Tell the menu where to animate to
    CGRect viewFrame = self.sub_menu.frame;
    if(doHide)
    {
        viewFrame.origin.y = 435;
    }
    else
    {
        viewFrame.origin.y = 384;
    }
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:MENU_ANIMITATION_DURATION];
    
    [self.sub_menu setFrame:viewFrame];
    
    [UIView commitAnimations];
    
    [self hideAllViews:nil];
}

-(IBAction)toggleBackground:(id)sender {
    if(!self.menu_overlay.hidden) {
        [self hideBackground:YES];
    }
    else
    {
        [self hideBackground:NO];
    }
}

/**
 * This gets called when the background image is tapped or any of the 
 * bottom menu items is pressed. It reveals the background image by 
 * hiding the views that overlay it.
 */
-(void)hideBackground:(BOOL) doHide
{
    if(doHide)
    {
        [self hideMenu:NO];
        [self.video_view closeYoutubeVideo:nil];
        [self hideHeader:NO];
        [self hideBackButton:NO];
        self.menu_overlay.hidden = YES;
        self.showingBackground = !self.showingBackground;
    } 
    else 
    {
        [self hideMenu:YES];
        [self hideBackButton:YES];
        [self hideHeader:YES];
        self.menu_overlay.hidden = NO;
        self.showingBackground = !self.showingBackground;
        [self hideAllViews:nil];
    }
}

- (IBAction)toggleInformation:(id)sender
{
    // Show/hide information
    if(self.hub_info.hidden == NO)
    {
        // Hide menu, this also hides all content views
        [self hideBackground:YES];
        self.hub_info.hidden = YES;
    }        
    else   
    {
        // Show info content view
        [self hideBackground:NO];
        self.hub_info.hidden = NO;
    }
}

- (IBAction)flipVideo:(id)sender
{
    // Hide stuff
    [self hideBackground:NO];
    
    if(self.video_view == nil)
        self.video_view = [[Video alloc] initWithNibName:@"Video" bundle:nil];
    self.video_view.videoListData = [self.currentPiece.videos allObjects];
    self.video_view.parentView = self;
    self.video_view.view.frame = self.contentViewFrame;
    self.video_view.view.hidden = NO;
    
    [self.view addSubview:self.video_view.view];
    
}

- (IBAction)flipRelated:(id)sender
{
    // Hide stuff
    [self hideBackground:NO];
    
    if(self.related_view == nil)
        self.related_view = [[Related alloc] initWithNibName:@"Related" bundle:nil];
    self.related_view.relatedListData = [self.currentPiece.related allObjects];
    self.related_view.parentPiece = self;
    self.related_view.view.frame = CGRectMake(0,0,320,480);
    self.related_view.view.hidden = NO;
    
    [self.view addSubview:self.related_view.view];
    
}

-(IBAction) backTouched:(id)sender
{
    self.backButton.highlighted = !self.backButton.highlighted;
}

-(void)hideBackButton:(BOOL)doHide
{
    // Tell the history modal where to animate to
    CGRect viewFrame = self.backButtonView.frame;
    if(!doHide)
    {
        viewFrame.origin.x = -27; 
    }
    else
    {
        viewFrame.origin.x = -95;
    }
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  
    [UIView setAnimationDuration:0.2];
    
    [self.backButtonView setFrame:viewFrame];
    
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
        self.hub_likes.hidden = NO;
        self.fb_icon.hidden = NO;
    }
    else
    {
        viewFrame.origin.y = -89;
        self.hub_artist.hidden = YES;
        self.hub_likes.hidden = YES;
        self.fb_icon.hidden = YES;
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
    [self hideBackground:YES];
    NSLog(@"FB: Shared? If so then give that feedback is possible.");
}

-(void)dialogDidNotComplete:(FBDialog *)dialog
{
    [self hideBackground:YES];
    NSLog(@"FB: dialogDidNotComplete");
}

-(void)refreshFacebookStatus
{
    // Set values according to what is stored in NSUserDefaults
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    self.facebook.accessToken = [prefs objectForKey:@"facebook-accessToken"];;
//    self.facebook.expirationDate = [prefs objectForKey:@"facebook-expirationDate"];
//    
//    if([self.facebook isSessionValid])
//    {
//        NSLog(@"Logged in");
//        // Show logout button
//    }
//    else
//    {
//        NSLog(@"Not logged in");
//        // Show login button
//    }
}

- (IBAction) doShare:(id)sender
{
    // open a dialog to give the user a choice of social network to share on
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share your experience:"
                                                             delegate:self 
                                                    cancelButtonTitle:@"Cancel" 
                                               destructiveButtonTitle:nil 
                                                    otherButtonTitles:@"Facebook", nil];
    
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];	// show from our table view (pops up in the middle of the table)
	[actionSheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) // Facebook
    { 
        [self shareOnFacebook:nil];
    } 
    else if (buttonIndex == 1) // Cancel
    { 
        //NSLog(@"Sharing canceled"); 
    }
}

- (IBAction)shareOnFacebook:(id)sender
{
    // Hide menu
    [self hideBackground:NO];
    
    // Open up a Facebook dialog here, will prompt for login
    HubPieceImage *fbImage = [self.currentPiece.images anyObject];
    NSString *fbTitle = [NSString stringWithFormat:@"Henry Art Gallery: %@", self.currentPiece.piece_name];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   kAppId, @"app_id",
                                   @"http://www.facebook.com/henryartgallery", @"link",
                                   fbImage.image_asset_url, @"picture",
                                   fbTitle, @"name",
                                   self.currentPiece.piece_share_copy, @"description",
                                   @"I'm at the Henry...",  @"message",
                                   nil];
    
    [self.facebook dialog:@"feed" andParams:params andDelegate:self];
}

- (void)fbDidLogin {
    //self.logoutButton.hidden = NO;
    NSLog(@"Logged in");
    
    // store the access token and expiration date to the user defaults
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:self.facebook.accessToken forKey:@"access_token"];
//    [defaults setObject:self.facebook.expirationDate forKey:@"expiration_date"];
//    [defaults synchronize];
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
    [self.menu_overlay release];
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

- (void)willRemoveSubView:(UIView *) subview {
    NSLog(@"willRemoveSubView: back to this view");
}

- (void)viewDidLoad
{    
    NSLog(@"viewDidLoad: HubPieceView");
    // Do some initial UI setup
    self.menu_overlay.hidden = YES;
    self.backButtonView.hidden = YES;
    self.contentViewFrame = CGRectMake(15,84,290,356);

    // Add a spinner for loading
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:self.spinner];
    [self.spinner setCenter:CGPointMake((320/2)-3, (480/2)+15)];
    [self.spinner startAnimating];
    
    
    // Setup facebook object
    self.facebook = [[Facebook alloc] initWithAppId:kAppId];
    // Update the visual feedback if the user is logged in or not
    [self refreshFacebookStatus];
    
    if(self.pieceLoaded) {
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
    self.menu_overlay    = nil;
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