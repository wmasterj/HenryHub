//
//  Related.m
//  HenryHub
//
//  Created by Jeroen van den Eijkhof, jeroen@uw.edu on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Related.h"
#import "RelatedView.h"
#import "HubPieceRelated.h"
#import "HenryHubAppDelegate.h"
#import "HubPieceView.h"

#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"

@implementation Related

@synthesize relatedTableViewCell = _relatedTableViewCell;
@synthesize relatedTableView = _relatedTableView;
@synthesize relatedListData = _relatedListData;
@synthesize parentPiece = _parentPiece;
@synthesize subPieceView = _subPieceView;
@synthesize relatedTableViewContainer = _relatedTableViewContainer;

-(IBAction)closeRelatedView:(id)sender
{
    NSLog(@"Close related view");
    [self.parentPiece showPieceControls:YES];
}

#pragma mark - Table view delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"How many related items do I have? Count: %i", [self.relatedListData count]);
    return [self.relatedListData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *VideoTableViewCellIdentifier = @"RelatedCellIdentifier";
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:VideoTableViewCellIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RelatedCell" 
                                                     owner:self 
                                                   options:nil];
        if([nib count] > 0)
        {
            cell = self.relatedTableViewCell;
        } 
        else
        {
            NSLog(@"Failed to load videoTableViewCell nig file!");
        }
    }
    
    // Get the correct video
    NSUInteger row = [indexPath row];
    NSLog(@"...at row: %i", row);
    
    HubPieceRelated *related = [self.relatedListData objectAtIndex:row];
    
    // Title
    UILabel *relatedTitleLabel = (UILabel *)[cell viewWithTag:kTitleValueTag];
    relatedTitleLabel.text = [NSString stringWithFormat:@"%@", related.piece_name];
    
    // Artist
    UILabel *relatedDescriptionTextView = (UILabel *)[cell viewWithTag:kArtistValueTag];
    relatedDescriptionTextView.text = [NSString stringWithFormat:@"%@", related.piece_artist];
    
    // Likes
    UILabel *relatedDurationLabel = (UILabel *)[cell viewWithTag:kLikeValueTag];
    relatedDurationLabel.text = [NSString stringWithFormat:@"%@", related.piece_likes];
    
    // Thumbnail image 
    HubPieceImage *tmpImage;
    if((tmpImage = [related.images anyObject]))
    {
        if(tmpImage.image_asset_thumb_url)
        {
            UIImageView *relatedImageView = (UIImageView *)[cell viewWithTag:kImageValueTag];
            [relatedImageView setImageWithURL:[NSURL URLWithString:tmpImage.image_asset_thumb_url] ];
        } else {
            NSLog(@"ERROR: No related image URL!");
        }
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 91; // Change this when the cell size changes
}

/**
 * A related piece has been tapped, open it up overlaying the entire screen.
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    HubPieceRelated *related = [self.relatedListData objectAtIndex:row];
    
    NSLog(@"Open related piece on row %i", row);
    
    // ## Check if the piece exists in the database
    // Setup the environment for dealing with Core Data and HubPiece entities
    HenryHubAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityHubPiece = [NSEntityDescription entityForName:@"HubPiece" 
                                                      inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityHubPiece];
    
    NSPredicate *findMatchPredicate = [NSPredicate predicateWithFormat:@"(piece_id == %@)", related.piece_id];
    [fetchRequest setPredicate:findMatchPredicate];
    
    NSError *error;
    NSArray *requestResult = [context executeFetchRequest:fetchRequest error:&error];
    
    // Create the view to be displayed if everything turns out right
    HubPieceView *pieceView = [[HubPieceView alloc] 
                               initWithNibName:@"HubPieceView" bundle:nil];
    
    if([requestResult count] > 0) 
    {
        NSLog(@"Found %i match(s)", [requestResult count]);
        //HubPiece *tmpPIece = (HubPiece *)[requestResult lastObject];
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
        BOOL success = [aConnection connect:related.piece_id];
        
        // If the connection was successful then load the actual HubPieceView
        if(success) {
            NSLog(@"Connected, getting the stuff...");
            pieceView.pieceConnection = aConnection;
            
            //[self.parentPiece hideMenu:NO];
            
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
    
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Overlay and show the related hubpiece
    [self.view addSubview:pieceView.view];

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
    self.relatedTableView.separatorColor = [UIColor clearColor];
    
    RelatedView *thisView = (RelatedView *)self.view;
    thisView.parentController = self;
    
    [[self.relatedTableViewContainer layer] setCornerRadius:3];
    [self.relatedTableViewContainer setClipsToBounds:YES];
    
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






