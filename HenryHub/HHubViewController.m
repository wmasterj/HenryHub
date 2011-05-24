//
//  HHubViewController.m
//  HHub
//
//  Created by Ohyoon Kwon on 11. 5. 9..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HHubViewController.h"
#import "OutSide.h"
#import "InSide.h"

@implementation HHubViewController

@synthesize historyLabel = _historyLabel;
@synthesize historyModal = _historyModal;
@synthesize historyModalArrow = _historyModalArrow;
@synthesize historyDismissLayer = _historyDismissLayer;

-(IBAction)InSideView
{
    InSide *inView = [[InSide alloc]initWithNibName:@"InSide" bundle:nil];
    
    [UIView beginAnimations:@"In Side" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [self.view addSubview:inView.view];
    [UIView commitAnimations];
}   

-(IBAction)OutSideView
{
    OutSide *outView = [[OutSide alloc]initWithNibName:@"OutSide" bundle:nil];
    
    [UIView beginAnimations:@"Out Side" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [self.view addSubview:outView.view];
    [UIView commitAnimations];
}

-(IBAction)toggleHistory:(id)sender
{
    // Tell the history modal where to animate to
    CGRect viewFrame = self.historyModal.frame;
    if(self.historyModal.frame.origin.y > 200)
    {
        viewFrame.origin.y = 98; 
        self.historyDismissLayer.hidden = NO;
        self.historyModalArrow.highlighted = YES; // down arrow
    }
    else
    {
        viewFrame.origin.y = 444;
        self.historyDismissLayer.hidden = YES;
        self.historyModalArrow.highlighted = NO; // up arrow
    }
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  
    [UIView setAnimationDuration:0.25];
    
    [self.historyModal setFrame:viewFrame];
    
    [UIView commitAnimations];
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
