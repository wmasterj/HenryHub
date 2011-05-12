//
//  InSide.m
//  HHub
//
//  Created by Ohyoon Kwon on 11. 5. 9..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InSide.h"
#import "HubXMLConnection.h"
#import "HubPieceView.h"

@implementation InSide

-(IBAction)InSideView
{
    [UIView beginAnimations:@"back" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view.superview cache:YES];
    [self.view removeFromSuperview];
    [UIView commitAnimations];
}

/*!
 This function creates a connection using the HubXMLConnection class and retrieves
 the XML for the given destination.
 
 TODO: Extend this to include a specific id.
 */
-(IBAction)scanTest
{
    HubXMLConnection *aConnection = [[HubXMLConnection alloc] init];    
    // Connect
    BOOL success = [aConnection connect];
    
    // If the connection was successful then load the actual HubPieceView
    if(success) {
        HubPieceView *pieceView = [[HubPieceView alloc] initWithNibName:@"HubPieceView" bundle:nil];
        
        pieceView.pieceConnection = aConnection;
        
        // Animate transition
        [UIView beginAnimations:@"showPiece" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view.superview cache:YES];
        [self.view.superview addSubview:pieceView.view];
        [self.view removeFromSuperview];
        [UIView commitAnimations];
    }
    [aConnection release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
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
