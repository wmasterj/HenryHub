//
//  Video.m
//  HenryHub
//
//  Created by Ohyoon Kwon on 11. 5. 17..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Video.h"


@implementation Video




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    // make a connection to video here
  /*  
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello!"
													message:@"Lafdsfsd"
												   delegate:self 
										  cancelButtonTitle:@"I'm super"    otherButtonTitles:nil];
	[alert show];
	[alert release];
    */
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
