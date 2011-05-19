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
#import "ZBarSDK.h"

@implementation InSide

@synthesize idString=_idString;
@synthesize reader=_reader;

-(IBAction)backToStart
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
    BOOL success = [aConnection connect:self.idString.text];
    
    // If the connection was successful then load the actual HubPieceView
    if(success) {
        HubPieceView *pieceView = [[HubPieceView alloc] initWithNibName:@"HubPieceView" bundle:nil];
        
        pieceView.pieceConnection = aConnection;
        
        // Animate transition
//        [UIView beginAnimations:@"showPiece" context:nil];
//        [UIView setAnimationDuration:0.5];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view.superview cache:YES];
        [self.view.superview addSubview:pieceView.view];
        [self.view removeFromSuperview];
//        [UIView commitAnimations];
    }
    [aConnection release];
}

- (IBAction)textEditingDone:(id)sender
{
    
}

- (IBAction)openScanner:(id)sender
{
    NSLog(@"Open scanner");

    // Create the reader
    self.reader = [ZBarReaderViewController new];
    self.reader.readerDelegate = self;
    
    // Create image for adding a logo :)
    UIImage *image = [UIImage imageNamed:@"scan_logo.png"];
    UIImageView *henryLogo = [[UIImageView alloc] initWithImage:image];
    henryLogo.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Configure reader
    self.reader.cameraOverlayView = henryLogo;
    [self.reader.scanner setSymbology:0 config:ZBAR_CFG_ENABLE to:0];
    [self.reader.scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:1];
    self.reader.readerView.zoom = 1.0;
    
    [self presentModalViewController:self.reader animated:YES];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Hide the scanner
    [self.reader dismissModalViewControllerAnimated:YES];
    
    NSLog(@"Scanned :)");
    
    // Store result in a variable
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    NSLog(@"Data scanned: %@", symbol.data);
    
    // OPEN HUB PIECE
    HubXMLConnection *aConnection = [[HubXMLConnection alloc] init];    
    // Connect
    BOOL success = [aConnection connect:symbol.data];
    
    // If the connection was successful then load the actual HubPieceView
    if(success) {
        HubPieceView *pieceView = [[HubPieceView alloc] initWithNibName:@"HubPieceView" bundle:nil];
        pieceView.pieceConnection = aConnection;
        
        // Animate transition
//        [UIView beginAnimations:@"showPiece" context:nil];
//        [UIView setAnimationDuration:0.5];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view.superview cache:YES];
        [self.view addSubview:pieceView.view];
        //[self.view removeFromSuperview];
//        [UIView commitAnimations];
    }
    else
    {
        NSLog(@"WARNING! Something wrong with the connection.");
    }
        
    [aConnection release];
}

- (void)readerControllerDidFailToRead:(ZBarReaderController *)reader withRetry:(BOOL)retry
{
    NSLog(@"Something went wrong!");
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
    [self.idString release];
    [self.reader release];
    
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
    NSLog(@"InSide view did load");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    NSLog(@"InSide view did UN-load");
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
