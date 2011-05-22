//
//  OutSide.m
//  HHub
//
//  Created by Ohyoon Kwon on 11. 5. 9..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OutSide.h"


@implementation OutSide


#define ScreenWidth 320
#define ScreenHeight 416


-(IBAction)OutSideView
{
    // Hide status bar going back
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    [UIView beginAnimations:@"back" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view.superview cache:YES];
    [self.view removeFromSuperview];
    [UIView commitAnimations];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) goUrl:(NSString*)urlAddr
{
    [webDtl loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlAddr]]];
}

-(void) webViewDidStartLoad:(UIWebView*)webView
{
    NSLog(@"Start WebView");
    [spinner startAnimating];
}
-(void) webViewDidFinishLoad:(UIWebView*)webView
{
    NSLog(@"Finish WebView");
    [spinner stopAnimating];
}


- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self.view addSubview:spinner];
    [spinner setCenter:CGPointMake(ScreenWidth /2, ScreenHeight /2)];
    [self goUrl:@"http://hub.henryart.org/index.php/pages/"];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
