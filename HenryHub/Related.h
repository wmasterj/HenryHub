//
//  Related.h
//  HenryHub
//
//  Created by Jeroen van den Eijkhof, jeroen@uw.edu on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HubPieceView.h"

#define kTitleValueTag    1
#define kArtistValueTag   2
#define kLikeValueTag     3
#define kImageValueTag    4  

@interface Related : UIViewController {
    
}

@property (nonatomic, retain) NSArray *relatedListData; // Will hold HubPieceRelated objects
@property (nonatomic, retain) IBOutlet UITableView *relatedTableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *relatedTableViewCell;
@property (nonatomic, retain) HubPieceView *parentPiece;
@property (nonatomic, retain) HubPieceView *subPieceView;
@property (nonatomic, retain) IBOutlet UIView *relatedTableViewContainer;
@property (nonatomic, retain) IBOutlet UIButton *closeButton;

-(IBAction)closeRelatedView:(id)sender;

@end
