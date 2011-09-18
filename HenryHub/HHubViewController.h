//
//  HHubViewController.h
//  Henry Hi
//
//  Created by Jeroen van den Eijkhof
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

// History cell tags
#define kTitleValueTag      1
#define kArtistValueTag     2
#define kLastViewedValueTag 3
#define kImageValueTag      4

@interface HHubViewController : UIViewController <ZBarReaderDelegate, UITableViewDelegate, UITableViewDataSource> {

}

@property (nonatomic, retain) IBOutlet UILabel *labelExplore;
@property (nonatomic, retain) IBOutlet UIButton *visitButton;
@property (nonatomic, retain) IBOutlet UIView *bottomControls;

// SCANNING ELEMENTS
@property (nonatomic, retain) IBOutlet UIButton *scanButton;
@property (nonatomic, retain) ZBarReaderViewController *reader;

// HISTORY ELEMENTS
@property (nonatomic, retain) IBOutlet UILabel *historyLabel;
@property (nonatomic, retain) IBOutlet UIView *historyModal;
@property (nonatomic, retain) IBOutlet UIImageView *historyModalArrow;
@property (nonatomic, retain) IBOutlet UITableView *historyTableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *historyCell;
// HISTORY DATA 
@property (nonatomic, retain) NSArray *historyObjects;


// ## METHODS

// Scanner
- (IBAction) openScanner: (id)sender;
// History
- (IBAction) toggleHistory: (id)sender;
- (void) loadObjectsToTableView;
+ (NSString *) getDurationStringFromSeconds: (double)seconds;
// Navigate to info/web
- (IBAction) AppInfoView;
- (IBAction) OutSideView;


@end
