//
//  Share.m
//  HenryHub
//
//  Created by Ohyoon Kwon on 11. 5. 10..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HubPieceView.h"
#import "HubXMLConnection.h"
#import "TBXML.h"
#import "HubPiece.h"
#import "InSide.h"

@implementation HubPieceView

@synthesize pieceConnection = _pieceConnection;
@synthesize currentPiece = _currentPiece;
@synthesize hub_title = _hub_title;
@synthesize backgroundImage = _backgroundImage;
@synthesize infoToggle = _infoToggle;
@synthesize hub_description = _hub_description;
@synthesize hub_info = _hub_info;
@synthesize backButton = _backButton;

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
    NSLog(@"Loaded content:\n%@\n\nPretty nice :)", self.pieceConnection.stringXML);
    
    // Parsing the XML data
    //
    TBXML *tbxml = [[TBXML tbxmlWithXMLString:self.pieceConnection.stringXML] retain];
    
    // Get the piece XML
    TBXMLElement *rootElement = tbxml.rootXMLElement;
    TBXMLElement *pieceXML = [TBXML childElementNamed:@"piece" parentElement:rootElement];
    
    // STORING values
    self.currentPiece = [[HubPiece alloc] init];
    
    // ID
    self.currentPiece.piece_id = [NSNumber numberWithInt:
                                  [[TBXML valueOfAttributeNamed:@"id" forElement:pieceXML] intValue]];
    NSLog(@"This objects id is: %@", [self.currentPiece.piece_id stringValue]);
    
    // Title
    TBXMLElement *titleXML = [TBXML childElementNamed:@"title" parentElement:pieceXML];
    self.currentPiece.name = [NSString stringWithString:[TBXML textForElement:titleXML]];
    if(self.currentPiece.name)
    {
        self.hub_title.text = self.currentPiece.name;
        NSLog(@"This objects name is: %@", self.currentPiece.name);         
    }
    
    // Main image
    // TODO: change if statement to test on if the image is there and loop all siblings
    TBXMLElement *imageXML = [TBXML childElementNamed:@"image" parentElement:[TBXML childElementNamed:@"images" parentElement:pieceXML]];
    NSString *backgroundImageURL = [TBXML textForElement:
                                    [TBXML childElementNamed:@"url" parentElement:imageXML]];
    if(backgroundImageURL)
    {
        self.backgroundImage.image = [UIImage imageWithData:
                                      [NSData dataWithContentsOfURL:
                                       [NSURL URLWithString:backgroundImageURL]]];
    } else {
        NSLog(@"No image URL");
    }
    
    // Description
    TBXMLElement *descriptionXML = [TBXML childElementNamed:@"asset_description" parentElement:pieceXML];
    NSLog(@"got description");
    NSString *descriptionString;
    if(descriptionXML) {
        descriptionString = [TBXML textForElement:descriptionXML];
        NSLog(@"There was a description:\n%@", descriptionString);
        // Add description to UITextView inside the information
        self.hub_description.text = descriptionString;
    }
    else
    {
        NSLog(@"No description");
    }
    
    // Show the UI controls that are hiding before everything has loaded
    self.infoToggle.hidden = NO;
    self.backButton.hidden = NO;
    
    [tbxml release];
    
    // iterating over a named list of children:
    // http://stackoverflow.com/questions/4014704/tbxml-while-problem
}

- (IBAction)showInformation:(id)sender
{
    NSLog(@"Show info");
    self.hub_info.hidden = !self.hub_info.hidden;
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
    [self.pieceConnection release];
    [self.hub_title release];
    [self.hub_info release];
    [self.hub_description release];
    [self.currentPiece release];
    [self.backButton release];
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
