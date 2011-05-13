//
//  Share.h
//  HenryHub
//
//  Created by Ohyoon Kwon on 11. 5. 10..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HubXMLConnection;
@class HubPiece;

@interface HubPieceView : UIViewController {
    
}

@property (nonatomic, retain) HubXMLConnection *pieceConnection;
@property (nonatomic, retain) HubPiece *currentPiece;

// Hub Piece elements
@property (nonatomic, retain) IBOutlet UITextView *hub_title;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
// Information
@property (nonatomic, retain) IBOutlet UIView *hub_info;
@property (nonatomic, retain) IBOutlet UITextView *hub_description;

// Other UI elements
@property (nonatomic, retain) IBOutlet UIButton *infoToggle;
@property (nonatomic, retain) IBOutlet UIButton *backButton;


// Methods
//
-(IBAction)showInformation:(id)sender;
-(IBAction)backToScan:(id)sender;
@end
