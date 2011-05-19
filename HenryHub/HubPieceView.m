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

@implementation HubPieceView

@synthesize pieceConnection = _pieceConnection;
@synthesize currentPiece = _currentPiece;
@synthesize hub_title = _hub_title;
@synthesize backgroundImage = _backgroundImage;
@synthesize infoToggle = _infoToggle;
@synthesize hub_description = _hub_description;
@synthesize hub_info = _hub_info;
@synthesize movingMenu=_movingMenu;
@synthesize sub_menu=_sub_menu;
@synthesize video_view=_video_view;
@synthesize menu_layer=_menu_layer;
@synthesize show_video=_show_video;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Something
    }
    return self;
}

- (void)useLoadedXML:(NSNotification *) notification
{
    // Parsing the XML data
    //
    TBXML *tbxml = [[TBXML tbxmlWithXMLString:self.pieceConnection.stringXML] retain];
    
    // Get the piece XML
    TBXMLElement *rootElement = tbxml.rootXMLElement;
    TBXMLElement *pieceXML = [TBXML childElementNamed:@"piece" parentElement:rootElement];
    
    // Create the HubPiece data from the XML file
    self.currentPiece = [[HubPiece alloc] initWithXML:pieceXML];

    if(self.currentPiece.name) // Add title to UI
        self.hub_title.text = self.currentPiece.name;
    
    // Main image
    if([self.currentPiece.images count] > 0)
    {
        HubPieceImage *tmpImage = [self.currentPiece.images objectAtIndex:0];
        if(tmpImage.asset_url)
        {
            self.backgroundImage.image = [UIImage imageWithData:
                                          [NSData dataWithContentsOfURL: tmpImage.asset_url]];
        } else {
            NSLog(@"No image URL! No first image?? Error.");
        }
    }
    
    // Add description to UI
    self.hub_description.text = self.currentPiece.description;
    
    // Show the UI controls that are hiding before everything has loaded
    self.infoToggle.hidden = NO;
    
    [tbxml release];
}

- (IBAction)showInformation:(id)sender
{
    NSLog(@"Show info");
    self.hub_info.hidden = !self.hub_info.hidden;
}


- (IBAction)offMenu:(id)sender

{
    
    CGFloat distance = 100;
    
    if(self.movingMenu){
        
        self.movingMenu = FALSE;
        
        distance = -100;
        
    } 
    
    else
        
    {
        
        self.movingMenu = TRUE;
        
    }
    
    NSLog(@"Off Menu");
    
    
    
    CGRect viewFrame = self.sub_menu.frame;
    
    viewFrame.origin.y += distance;
    
    
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [UIView setAnimationDuration:0.2];
    
    
    [self.sub_menu setFrame:viewFrame];
    
    self.video_view.view.hidden = YES;
    
    
    [UIView commitAnimations];
       
    
    self.menu_layer.hidden = !self.menu_layer.hidden;
    
}

/*
-(void)showAlertMessage:(NSString *)alertTitle Message:(NSString *)alertMessage CancelButtonTitle:(NSString *)cancelTitle{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
													message:alertMessage
												   delegate:self 
										  cancelButtonTitle:cancelTitle otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}
*/

- (IBAction)flipVideo:(id)sender
{
    NSLog(@"Video View");
    //[self showAlertMessage:@"Tien testing" Message:@"Testing" CancelButtonTitle:@"Nil"];
    //self.video_view.hidden = !self.video_view.hidden;
    
    self.video_view = [[Video alloc] initWithNibName:@"Video" bundle:nil];
    self.video_view.view.frame = CGRectMake(10,50,300,350);
    
    self.video_view.view.hidden = NO;
    
    [self.view addSubview:self.video_view.view];
    
}


- (IBAction)backToScan:(id)sender
{
    NSLog(@"Switching back");
    InSide *inView = [[InSide alloc]initWithNibName:@"InSide" bundle:nil];
    
    [UIView beginAnimations:@"In Side From Object" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown 
                           forView:self.view cache:YES];
    [self.view.superview addSubview:inView.view];
    [UIView commitAnimations];
}


// UIViewControlle standard methods

- (void)dealloc
{
    [self.show_video release];
    [self.menu_layer release];
    [self.movingMenu release];
    [self.sub_menu release];
    [self.pieceConnection release];
    [self.hub_title release];
    [self.hub_info release];
    [self.hub_description release];
    [self.currentPiece release];
    [self.video_view release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(useLoadedXML:) 
     name:@"HubXMLLoaded" 
     object:nil ];
    
    self.menu_layer.hidden = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
