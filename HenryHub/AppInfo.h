//
//  InSide.h
//  Henry Hi
//
//  Created by Jeroen van den Eijkhof, jeroen@uw.edu on 11. 5. 9..
//

#import <UIKit/UIKit.h>

@interface AppInfo : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIScrollView *infoScroll;

- (IBAction) backToStart;

@end
