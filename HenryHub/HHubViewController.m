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

@synthesize labelExplore = _labelExplore;
@synthesize welcomeText = _welcomeText;

-(IBAction)InSideView
{
    InSide *inView = [[InSide alloc]initWithNibName:@"InSide" bundle:nil];
    
    [UIView beginAnimations:@"In Side" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [self.view addSubview:inView.view];
    [UIView commitAnimations];
    
    //[inView release];
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
    
    //[outView release];
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
    [super viewDidLoad];
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
