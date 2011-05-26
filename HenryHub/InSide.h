//
//  InSide.h
//  HHub
//
//  Created by Ohyoon Kwon on 11. 5. 9..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface InSide : UIViewController <ZBarReaderDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UITextField *idString;
@property (nonatomic, retain) ZBarReaderViewController *reader;
@property (nonatomic, retain) IBOutlet UILabel *historyLabel;
@property (nonatomic, retain) IBOutlet UIView *historyModal;
@property (nonatomic, retain) IBOutlet UIImageView *historyModalArrow;
@property (nonatomic, retain) IBOutlet UIButton *historyDismissLayer;

- (IBAction)backToStart;
- (IBAction)openScanner:(id)sender;
- (IBAction)textEditingDone:(id)sender;
- (IBAction)toggleHistory:(id)sender;

@end
