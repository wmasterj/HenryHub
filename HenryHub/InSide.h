//
//  InSide.h
//  HHub
//
//  Created by Ohyoon Kwon on 11. 5. 9..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

#define kTitleValueTag      1
#define kArtistValueTag     2
#define kLastViewedValueTag 3
#define kImageValueTag      4

@interface InSide : UIViewController <ZBarReaderDelegate, UITableViewDelegate, UITableViewDataSource> {
    
}

@property (nonatomic, retain) IBOutlet UITextField *idString;
@property (nonatomic, retain) ZBarReaderViewController *reader;
@property (nonatomic, retain) IBOutlet UILabel *historyLabel;
@property (nonatomic, retain) IBOutlet UIView *historyModal;
@property (nonatomic, retain) IBOutlet UIImageView *historyModalArrow;
@property (nonatomic, retain) IBOutlet UIButton *historyDismissLayer;
@property (nonatomic, retain) IBOutlet UITableView *historyTableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *historyCell;
// History objects
@property (nonatomic, retain) NSArray *historyObjects;

- (IBAction) backToStart;
- (IBAction) openScanner: (id)sender;
- (IBAction) textEditingDone: (id)sender;
- (IBAction) toggleHistory: (id)sender;
- (void) loadObjectsToTableView;

+ (NSString *) getDurationStringFromSeconds: (double)seconds;


@end
