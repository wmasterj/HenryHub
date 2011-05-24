//
//  HHubViewController.h
//  HHub
//
//  Created by Ohyoon Kwon on 11. 5. 9..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHubViewController : UIViewController {

}

@property (nonatomic, retain) IBOutlet UILabel *historyLabel;
@property (nonatomic, retain) IBOutlet UIView *historyModal;
@property (nonatomic, retain) IBOutlet UIImageView *historyModalArrow;
@property (nonatomic, retain) IBOutlet UIButton *historyDismissLayer;

-(IBAction)InSideView;
-(IBAction)OutSideView;
-(IBAction)toggleHistory:(id)sender;

@end
