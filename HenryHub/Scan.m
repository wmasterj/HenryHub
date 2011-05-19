//
//  Scan.m
//  HenryHub
//
//  Created by Ohyoon Kwon on 11. 5. 10..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Scan.h"
#import "ZBarSDK.h"


@implementation Scan

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
    
//    // Create the reader
//    ZBarReaderViewController *reader = [ZBarReaderViewController new];
//    reader.readerDelegate = self;
//    
//    // Create image for adding a logo :)
//    UIImage *image = [UIImage imageNamed:@"mainLogo.png"];
//    UIImageView *henryLogo = [[UIImageView alloc] initWithImage:image];
//    henryLogo.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//    
//    // Configure reader
//    reader.cameraOverlayView = henryLogo;
//    [reader.scanner setSymbology:0 config:ZBAR_CFG_ENABLE to:0];
//    [reader.scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:1];
//    reader.readerView.zoom = 1.0;
//    
//    [self presentModalViewController:reader animated:YES];
//    
//    //[reader release];
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
