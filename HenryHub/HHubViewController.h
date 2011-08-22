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

@property (nonatomic, retain) IBOutlet UILabel *labelExplore;
@property (nonatomic, retain) IBOutlet UILabel *welcomeText;
@property (nonatomic, retain) IBOutlet UIButton *exploreButton;
@property (nonatomic, retain) IBOutlet UIButton *visitButton;

-(IBAction)InSideView;
-(IBAction)OutSideView;


@end
