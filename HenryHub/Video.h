//
//  Video.h
//  HenryHub
//
//  Created by Ohyoon Kwon on 11. 5. 17..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTitleValueTag          1
#define kDescriptionValueTag    2
#define kDurationValueTag       3
#define kImageValueTag          4  

@interface Video : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
}

// UI Elements
@property (nonatomic, retain) IBOutlet UIView *selected_video;
@property (nonatomic, retain) IBOutlet UIWebView *selected_videoWebView;
@property (nonatomic, retain) IBOutlet UILabel *selected_videoTitle;
@property (nonatomic, retain) IBOutlet UITextView *selected_videoDescription;
@property (nonatomic, retain) IBOutlet UILabel *selected_videoDuration;
@property (nonatomic, retain) IBOutlet UIButton *selected_videoClose;
@property (nonatomic, retain) IBOutlet UITableView *videoTableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *videoTableViewCell;

@property (nonatomic, retain) NSArray *videoListData; // Will hold HubPieceVideo objects

- (void) embedYouTube: (NSString *) videoId withFrame: (CGRect) frame;
- (IBAction) closeYoutubeVideo: (id) sender;
+ (NSString *) getDurationStringFromSeconds: (double) seconds;

@end
