//
//  Video.m
//  HenryHub
//
//  Created by Ohyoon Kwon on 11. 5. 17..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Video.h"
#import "HubPieceVideo.h"

@implementation Video

@synthesize videoListData = _videoListData;
@synthesize selected_video = _selected_video;
@synthesize selected_videoWebView = _selected_videoWebView;
@synthesize selected_videoTitle = _selected_videoTitle;
@synthesize selected_videoDescription = _selected_videoDescription;
@synthesize selected_videoDuration = _selected_videoDuration;
@synthesize selected_videoClose = _selected_videoClose;

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
    [self.videoListData release];
    [self.selected_video dealloc];
    [self.selected_videoWebView dealloc];
    [self.selected_videoTitle dealloc];
    [self.selected_videoDescription dealloc];
    [self.selected_videoDuration dealloc];    
    [self.selected_videoClose dealloc];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//-(void)embedYouTube:(NSString *)videoId withFrame:(CGRect)frame
//{
//    NSString *embedVideo = @"\
//    <html><head>\
//    <style type=\"text/css\">\
//    body {\
//    background-color: transparent;\
//    color: white;\
//    }\
//    </style>\
//    </head><body style=\"margin:0;\">\
//    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
//    width=\"%0.0f\" height=\"%0.0f\"></embed>\
//    </body></html>";
//    NSString *url = [NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", videoId];
//    NSString *html = [NSString stringWithFormat:embedVideo, url, 
//                      frame.size.width, frame.size.height];
//    if(self.selected_videoWebView != nil)
//        self.selected_videoWebView = nil;
//    self.selected_videoWebView = [[UIWebView alloc] initWithFrame:frame];
//    [self.selected_videoWebView loadHTMLString:html baseURL:nil];
//    NSLog(@"Add url: http://www.youtube.com/watch?v=%@, width: %0.0f, height: %0.0f", videoId, frame.size.width, frame.size.width);
//} 

- (void)embedYouTube:(NSString *)videoId withFrame:(CGRect)frame {
    NSString *embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    NSString *html = [NSString stringWithFormat:embedHTML, videoId, frame.size.width, frame.size.height];
    UIWebView *videoView = [[UIWebView alloc] initWithFrame:frame];
    [videoView loadHTMLString:html baseURL:nil];
    [self.selected_video addSubview:videoView];
    [videoView release];
    NSLog(@"Add url: %@, width: %0.0f, height: %0.0f", videoId, frame.size.width, frame.size.width);
}

#pragma mark - Table View Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"How many videos do I have? Count: %i", [self.videoListData count]);
    return [self.videoListData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell =  [tableView 
                              dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier] autorelease];
    }
    
    // Get the correct video
    NSUInteger row = [indexPath row];
    HubPieceVideo *video = [self.videoListData objectAtIndex:row];
    
    // Title
    cell.textLabel.text = [NSString stringWithFormat:@"%@", video.title];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    
    // Image
    UIImage *cellImage = [UIImage imageWithData:[NSData dataWithContentsOfURL: 
                                                 [NSURL URLWithString:video.image_url]]];
    cell.imageView.image = cellImage;
    
    // Calculate time
    double delta = [video.duration doubleValue];
    int minutes = floor(delta/60);
    int seconds = trunc(delta - (minutes*60));
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Duration %i:%i", minutes, seconds];
    
    return cell;
}

-(IBAction)closeYoutubeVideo:(id)sender
{
    self.selected_video.hidden = YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    HubPieceVideo *video = [self.videoListData objectAtIndex:row];
    
    // Open video
    NSString *url = [NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", video.external_id];
    [self embedYouTube:url withFrame:CGRectMake(0, 0, 280, 176)];
    
    // Show video information
    self.selected_videoTitle.text = video.title;
    self.selected_videoDescription.text = video.caption;
    // Calculate time
    double delta = [video.duration doubleValue];
    int minutes = floor(delta/60);
    int seconds = trunc(delta - (minutes*60));
    self.selected_videoDuration.text = [NSString 
                                        stringWithFormat:@"Duration %i:%i", minutes, seconds];
    self.selected_video.hidden = NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.videoListData = nil;
    
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
