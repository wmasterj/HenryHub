//
//  OutSide.h
//  HHub
//
//  Created by Ohyoon Kwon on 11. 5. 9..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OutSide : UIViewController {
    
    //webDtl is relating with webview page.
    IBOutlet UIWebView *webDtl;
    
    UIActivityIndicatorView *spinner;
}

-(IBAction)OutSideView;

@end
