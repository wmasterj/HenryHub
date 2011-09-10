//
//  HHubViewController.h
//  HHub
//
//  Created by Ohyoon Kwon on 11. 5. 9..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface HHubViewController : UIViewController <ZBarReaderDelegate> {

}

@property (nonatomic, retain) IBOutlet UILabel *labelExplore;
@property (nonatomic, retain) IBOutlet UIButton *visitButton;

// SCANNING ITEMS
@property (nonatomic, retain) IBOutlet UIButton *scanButton;
@property (nonatomic, retain) ZBarReaderViewController *reader;


- (IBAction) openScanner: (id)sender;

// Navigate to info and web
- (IBAction) InSideView;
- (IBAction) OutSideView;


@end
