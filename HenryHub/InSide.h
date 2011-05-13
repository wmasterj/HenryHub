//
//  InSide.h
//  HHub
//
//  Created by Ohyoon Kwon on 11. 5. 9..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InSide : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UITextField *idString;

- (IBAction)InSideView;
- (IBAction)scanTest;
- (IBAction)textEditingDone:(id)sender;
@end
