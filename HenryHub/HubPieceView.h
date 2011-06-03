//
//  Share.h
//  HenryHub
//
//  Created by Ohyoon Kwon on 11. 5. 10..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HubXMLConnection.h" // Imports "HttpDataDelegate"
#import "FBConnect.h"
#import "TBXML.h"

@class Related;
@class Video;
@class HubXMLConnection;
@class HubPiece;
@class HubPieceImage;

#define MENU_ANIMITATION_DURATION 0.25

@interface HubPieceView : UIViewController <HttpDataDelegate, FBDialogDelegate, FBSessionDelegate, UIActionSheetDelegate> {

}

// Content views
//
@property (nonatomic, retain) IBOutlet Video *video_view;
@property (nonatomic, retain) IBOutlet Related *related_view;

// Data & connection
//
@property (nonatomic, retain) HubXMLConnection *pieceConnection;
@property (nonatomic, retain) HubPiece *currentPiece;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, assign) BOOL pieceLoaded;

// Hub Piece elements
//
@property (nonatomic, retain) IBOutlet UILabel *hub_title;
@property (nonatomic, retain) IBOutlet UILabel *hub_artist;
@property (nonatomic, retain) IBOutlet UILabel *hub_likes;
@property (nonatomic, retain) IBOutlet UIImageView *fb_icon;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
// Information
@property (nonatomic, retain) IBOutlet UIView *hub_info;
@property (nonatomic, retain) IBOutlet UITextView *hub_description;
// Other UI elements
@property (nonatomic, assign) CGRect contentViewFrame;
@property (nonatomic, retain) IBOutlet UIControl *backButtonView;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
// Moving UIView
@property (nonatomic, retain) IBOutlet UIView *sub_menu; // 6 button menu
@property (nonatomic, retain) IBOutlet UIButton *menu_layer; // menu bottom tap overlay
@property (nonatomic, retain) IBOutlet UIButton *videoButton;
@property (nonatomic, retain) IBOutlet UIButton *relatedButton;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) IBOutlet UIButton *shareButton;

// Toggles
@property (nonatomic, assign) BOOL showingBackground;
@property (nonatomic, assign) BOOL movingMenu; 

// Methods
//
- (IBAction) toggleInformation: (id) sender;
- (IBAction) backToScan: (id) sender;
- (IBAction) backTouched: (id) sender;
- (IBAction) flipVideo: (id) sender;
- (IBAction) flipRelated: (id) sender;
- (IBAction) hideAllViews: (id) sender;
- (IBAction) hideMenu: (id) sender;
- (IBAction) showMenu: (id) sender;
- (IBAction) showBackground: (id) sender;
- (void) hideHeader: (BOOL) hide;
- (void) hideBackButton: (BOOL) doHide;
- (void) displayInformation;
// Social
- (IBAction) doShare: (id)sender;
- (IBAction) shareOnFacebook: (id)sender;
- (void) refreshFacebookStatus;

@end
