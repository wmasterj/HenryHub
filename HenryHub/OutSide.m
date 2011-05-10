//
//  OutSide.m
//  HHub
//
//  Created by Ohyoon Kwon on 11. 5. 9..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OutSide.h"


@implementation OutSide



-(IBAction)OutSideView
{
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(int)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kIdentifier =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIdentifier] autorelease];
    }
    
    if (indexPath.row==0) {
        
        cell.textLabel.text = @"History";
    }
    if (indexPath.row==1) {
        
        cell.textLabel.text = @"Exhibition";
    } 
    if (indexPath.row==2) {
        
        cell.textLabel.text = @"News";
    } 
    if (indexPath.row==3) {
        
        cell.textLabel.text = @"Press Room";
    } 
    if (indexPath.row==4) {
        
        cell.textLabel.text = @"Timings";
    } 
    if (indexPath.row==5) {
        
        cell.textLabel.text = @"Contact Directory";
    } 
    if (indexPath.row==6) {
        
        cell.textLabel.text = @"Visit";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://henryart.org"]];   
    }
    if(indexPath.row==1)
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://henryart.org"]];   
    }
    if(indexPath.row==2)
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://henryart.org"]];   
    }
    if(indexPath.row==3)
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://henryart.org"]];   
    }
    if(indexPath.row==4)
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://henryart.org"]];   
    }
    if(indexPath.row==5)
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://henryart.org"]];   
    }
    if(indexPath.row==6)
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://henryart.org"]];   
    }
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
