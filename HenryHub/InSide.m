//
//  InSide.m
//  HHub
//
//  Created by Jeroen van den Eijkhof, jeroen@uw.edu on 11. 5. 9..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InSide.h"
#import "InSideView.h"
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

@implementation InSide

@synthesize idString=_idString;
@synthesize reader=_reader;
@synthesize scanButton = _scanButton;

// History controls
@synthesize historyLabel = _historyLabel;
@synthesize historyModal = _historyModal;
@synthesize historyModalArrow = _historyModalArrow;
@synthesize historyDismissLayer = _historyDismissLayer;
@synthesize historyTableView = _historyTableView;
@synthesize historyObjects = _historyObjects;
@synthesize historyCell = _historyCell;

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
        //pieceView.currentPiece.piece_last_viewed = [[NSNumber alloc] initWithDouble:[[NSDate date] timeIntervalSince1970]];
        //[context save:&error];
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

-(IBAction)toggleHistory:(id)sender
{
    // Tell the history modal where to animate to
    CGRect viewFrame = self.historyModal.frame;
    if(self.historyModal.frame.origin.y > 200)
    {
        viewFrame.origin.y = 98; 
        self.historyDismissLayer.hidden = NO;
        self.historyModalArrow.highlighted = YES; // down arrow
        NSUInteger *historyCount = (NSUInteger *)[self.historyObjects count];
        if(historyCount == 1)
        {
            self.historyLabel.text = [NSString stringWithFormat:@"%i art object", historyCount];
        } 
        else
        {
            self.historyLabel.text = [NSString stringWithFormat:@"%i art objects", historyCount];
        }
    }
    else
    {
        viewFrame.origin.y = 439;
        self.historyDismissLayer.hidden = YES;
        self.historyModalArrow.highlighted = NO; // up arrow
        if([self.historyObjects count] > 0)
        {
            HubPiece *lastPiece = [self.historyObjects objectAtIndex:0];
            self.historyLabel.text = [NSString stringWithFormat:@"%@", lastPiece.piece_name];
        }
        else
        {
            self.historyLabel.text = [NSString stringWithFormat:@"no history"];
        }
        
    }
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  
    [UIView setAnimationDuration:0.25];
    
    [self.historyModal setFrame:viewFrame];
    
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

#pragma mark - UITableView delegate methods

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Row count: %i", [self.historyObjects count]);
    return [self.historyObjects count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 91; // Need to change this if historyCell changes it's size
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSLog(@"Selected row at index: %i", row);
    
    // Check if the piece exists in the database
    // Setup the environment for dealing with Core Data and HubPiece entities    
    [self toggleHistory:nil];
    
    HubPieceView *pieceView = [[HubPieceView alloc] init];
    pieceView.currentPiece = [self.historyObjects objectAtIndex:row];
    
    pieceView.pieceLoaded = YES;
    [self.view addSubview:pieceView.view];
    //[pieceView release];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HistoryCellIdentifier = @"HistoryCellIdentifier";
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:HistoryCellIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryCell" 
                                                     owner:self 
                                                   options:nil];
        if([nib count] > 0)
        {
            cell = self.historyCell;
        } 
        else
        {
            NSLog(@"Failed to load historyCell nib file!");
        }
    }
    
    // Get the correct object
    NSUInteger row = [indexPath row];
    NSLog(@"...at row: %i", row);
    HubPiece *piece = [self.historyObjects objectAtIndex:row];
    
    // Title
    UILabel *historyItemTitleLabel = (UILabel *)[cell viewWithTag:kTitleValueTag];
    historyItemTitleLabel.text = [NSString stringWithFormat:@"%@", piece.piece_name];
    
    // Description
    UILabel *historyItemArtistLabel = (UILabel *)[cell viewWithTag:kArtistValueTag];
    historyItemArtistLabel.text = [NSString stringWithFormat:@"%@", piece.piece_artist];
    
    // Calculate time
    UILabel *historyItemLastViewedLabel = (UILabel *)[cell viewWithTag:kLastViewedValueTag];
    NSNumber *timeElapsed = [NSNumber numberWithInt:
                             floor(((double)[[NSDate date] timeIntervalSince1970]) - [piece.piece_last_viewed doubleValue])];
    
    historyItemLastViewedLabel.text = [NSString stringWithFormat:@"%@", 
                                       [InSide getDurationStringFromSeconds:[timeElapsed doubleValue]] ];

    // Image
    UIImageView *historyItemImageView = (UIImageView *)[cell viewWithTag:kImageValueTag];
    HubPieceImage *tmpImage = [piece.images anyObject];
    [historyItemImageView setImageWithURL:[NSURL URLWithString:tmpImage.image_asset_url] ];
    historyItemImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    return cell;

}

-(void)loadObjectsToTableView
{
    // Setup the environment for dealing with Core Data and HubPiece entities
    HenryHubAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityHubPiece = [NSEntityDescription entityForName:@"HubPiece" 
                                                      inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityHubPiece];
    
    NSError *error;
    self.historyObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSUInteger count = [self.historyObjects count];
    
    if(self.historyObjects == nil)
    {
        NSLog(@"There was an error fetching history objects.");
        self.historyLabel.text = @"Error fetching history";
    } 
    else if (count == 0)
    {   
        NSLog(@"No items in history");
        self.historyLabel.text = @"no history";
        [self.historyModal setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] ];
        self.historyLabel.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
        self.historyLabel.shadowColor = [UIColor clearColor];
    }
    else
    {
        NSLog(@"%i iitems in history", count);
        HubPiece *lastPiece = [self.historyObjects objectAtIndex:0];
        self.historyLabel.text = [NSString stringWithFormat:@"%@", lastPiece.piece_name];
        [self.historyModal setBackgroundColor:[UIColor colorWithRed:0.917 green:0.909 blue:0.902 alpha:1.0] ];
        self.historyLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        self.historyLabel.shadowColor = [UIColor whiteColor];
    }
    
    [fetchRequest release];
    [self.historyTableView reloadData];
}

#pragma mark - Misch

+ (NSString *) getDurationStringFromSeconds: (double)seconds;
{
    if(seconds)
    {
        int tmpMinutes = floor(seconds/60);
        int tmpHours = floor(tmpMinutes/60);
        int tmpDays = floor(tmpHours/24);
        if(tmpMinutes <= 1) 
        {
            return [NSString stringWithFormat:@"1 minute ago"];
        } 
        else if(tmpMinutes >= 2 && tmpMinutes < 59) 
        {
            return [NSString stringWithFormat:@"%i minutes ago", tmpMinutes];
        } 
        else if(tmpHours <= 1)
        {
            return [NSString stringWithFormat:@"1 hour ago"];
        } 
        else if(tmpHours > 1 && tmpHours <24)
        {
            return [NSString stringWithFormat:@"%i hours ago", tmpHours];
        } 
        else if(tmpDays <= 1)
        {
            return [NSString stringWithFormat:@"1 day ago"];
        }
    }
    return nil;
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

- (void) viewWillAppear:(BOOL)animated
{
    [self loadObjectsToTableView];
}

- (void)viewDidLoad
{
    NSLog(@"InSide view did load");
    
    // Load objects from database
    [self loadObjectsToTableView];
    self.historyDismissLayer.hidden = YES;
    
    self.historyTableView.separatorColor = [UIColor clearColor];
    
    // Rounded corners
    [[self.scanButton layer] setCornerRadius:3];
    [self.scanButton setClipsToBounds:YES];
    
    // Not sure who to deal with this warning, but it works, darn...
    InSideView *thisView = (InSideView *)self.view; 
    thisView.parentController = self;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    NSLog(@"InSide view did UN-load");
    
    self.historyObjects = nil;
    self.idString = nil;
    self.reader = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [self.idString release];
    [self.reader release];
    [self.historyObjects release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end