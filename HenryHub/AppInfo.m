//
//  InSide.m
//  HHub
//
//  Created by Jeroen van den Eijkhof, jeroen@uw.edu on 11. 5. 9..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppInfo.h"
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

@implementation AppInfo

@synthesize idString=_idString;

// History controls
@synthesize historyLabel = _historyLabel;
@synthesize historyModal = _historyModal;
@synthesize historyModalArrow = _historyModalArrow;
@synthesize historyDismissLayer = _historyDismissLayer;
@synthesize historyTableView = _historyTableView;
@synthesize historyObjects = _historyObjects;
@synthesize historyCell = _historyCell;
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

-(IBAction)toggleHistory:(id)sender
{
    // Tell the history modal where to animate to
    CGRect viewFrame = self.historyModal.frame;
    if(self.historyModal.frame.origin.y > 200)
    {
        viewFrame.origin.y = 70; 
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
                                       [AppInfo getDurationStringFromSeconds:[timeElapsed doubleValue]] ];

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
        NSLog(@"%i items in history", count);
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
    [[self.backButton layer] setCornerRadius:3];
    [self.backButton setClipsToBounds:YES];
    [[self.historyModal layer] setCornerRadius:3];
    [self.historyModal setClipsToBounds:YES];
    
    // Setup scroll view
    self.infoScroll.contentSize = CGSizeMake(319, 154);
    self.infoScroll.scrollEnabled = YES;
    self.infoScroll.pagingEnabled = YES; // Snaps it
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    NSLog(@"InSide view did UN-load");
    
    self.historyObjects = nil;
    self.idString = nil;
    
    [self toggleHistory: nil];
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [self.idString release];
    [self.historyObjects release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end