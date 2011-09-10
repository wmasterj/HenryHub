//
//  HHubViewController.m
//  HHub
//
//  Created by Ohyoon Kwon on 11. 5. 9..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "HHubViewController.h"
#import "OutSide.h"
#import "AppInfo.h"
#import "HenryHubAppDelegate.h"
#import "HubPieceView.h"

@implementation HHubViewController

@synthesize labelExplore = _labelExplore;
@synthesize visitButton = _visitButton;
@synthesize scanButton = _scanButton;
@synthesize reader = _reader;

-(IBAction)InSideView
{
    AppInfo *inView = [[AppInfo alloc]initWithNibName:@"AppInfo" bundle:nil];
    
    [UIView beginAnimations:@"AppInfo enterance" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [self.view addSubview:inView.view];
    [UIView commitAnimations];
}   

-(IBAction)OutSideView
{
    OutSide *outView = [[OutSide alloc]initWithNibName:@"OutSide" bundle:nil];
    
    [UIView beginAnimations:@"Out Side" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [self.view addSubview:outView.view];
    [UIView commitAnimations];
}

#pragma mark - SCANNING

- (IBAction)openScanner:(id)sender
{
    NSLog(@"Open scanner");
    
    // Create the reader
    self.reader = [ZBarReaderViewController new];
    self.reader.readerDelegate = self;
    
    // Create image for adding a logo :)
    UIImage *image = [UIImage imageNamed:@"scan_bg.png"];
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
    // ADD sound here
    
    // Hide the scanner
    [self.reader dismissModalViewControllerAnimated:YES];
    
    NSLog(@"Scanned :)");
    
    // Store result in a variable
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    NSLog(@"Data scanned: %@", symbol.data);
    
    // Check if the piece exists in the database
    // Setup the environment for dealing with Core Data and HubPiece entities
    HenryHubAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityHubPiece = [NSEntityDescription entityForName:@"HubPiece" 
                                                      inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityHubPiece];
    
    NSPredicate *findMatchPredicate = [NSPredicate predicateWithFormat:@"(piece_id == %@)", symbol.data];
    [fetchRequest setPredicate:findMatchPredicate];
    
    NSError *error;
    NSArray *requestResult = [context executeFetchRequest:fetchRequest error:&error];
    
    // Create the view to be displayed if everything turns out right
    HubPieceView *pieceView = [[HubPieceView alloc] 
                               initWithNibName:@"HubPieceView" bundle:nil];
    
    if([requestResult count] > 0) 
    {
        NSLog(@"Found %i match(s)", [requestResult count]);
        pieceView.currentPiece = (HubPiece *)[requestResult lastObject];
        pieceView.pieceLoaded = YES;
        
        // Show the actual hub piece
        [self.view addSubview:pieceView.view];
    }
    else
    {
        NSLog(@"No match found, let's fetch it from the big internet");
        
        // Instatiate connection class
        HubXMLConnection *aConnection = [[HubXMLConnection alloc] init];    
        aConnection.delegate = pieceView;
        
        // Connect
        BOOL success = [aConnection connect:symbol.data];
        
        // If the connection was successful then load the actual HubPieceView
        if(success) {
            NSLog(@"Connected, getting the stuff...");
            pieceView.pieceConnection = aConnection;
            //pieceView.currentPiece.piece_last_viewed = [[NSNumber alloc] initWithDouble:[[NSDate date] timeIntervalSince1970]];
            //[context save:&error];
            // Show the actual hub piece
            [self.view addSubview:pieceView.view];
        }
        else
        {
            NSLog(@"WARNING! Something wrong with the connection.");
        }
        
        [aConnection release];
    }
    
    [fetchRequest release];
    //[pieceView release];
}

- (void)readerControllerDidFailToRead:(ZBarReaderController *)reader withRetry:(BOOL)retry
{
    NSLog(@"SCANNING: Something went wrong!");
}

#pragma mark - Misc

- (void)dealloc
{
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
    [super viewDidLoad];
    
    [[self.visitButton layer] setCornerRadius:3];
    [self.visitButton setClipsToBounds:YES];
    [[self.scanButton layer] setCornerRadius:3];
    [self.scanButton setClipsToBounds:YES];

}

- (void)viewDidUnload
{
    self.reader = nil;
    
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
