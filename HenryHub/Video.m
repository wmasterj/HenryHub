//
//  Video.m
//  HenryHub
//
//  Created by Jeroen van den Eijkhof, jeroen@uw.edu on 11. 5. 17..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Video.h"
#import "HubPieceVideo.h"
#import "UIImageView+WebCache.h"

@implementation Video

@synthesize videoListData = _videoListData;
@synthesize selected_video = _selected_video;
@synthesize selected_videoWebView = _selected_videoWebView;
@synthesize selected_videoTitle = _selected_videoTitle;
@synthesize selected_videoDescription = _selected_videoDescription;
@synthesize selected_videoDuration = _selected_videoDuration;
@synthesize selected_videoClose = _selected_videoClose;
@synthesize videoTableView = _videoTableView;
@synthesize videoTableViewCell = _videoTableViewCell;
@synthesize parentView = _parentView;

#pragma mark - Instance methods

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
    [self.selected_video release];
    [self.selected_videoWebView release];
    [self.selected_videoTitle release];
    [self.selected_videoDescription release];
    [self.selected_videoDuration release];    
    [self.selected_videoClose release];
    [self.videoTableView release];
    [self.videoTableViewCell release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

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

-(IBAction)closeYoutubeVideo:(id)sender
{
    self.selected_video.hidden = YES;
}

-(IBAction)closeVideoView:(id)sender
{
    NSLog(@"Close video table");
    [self.parentView hideMenu:NO];
}

#pragma mark - Table view delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"How many videos do I have? Count: %i", [self.videoListData count]);
    return [self.videoListData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *VideoTableViewCellIdentifier = @"VideoTableViewCellIdentifier";
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:VideoTableViewCellIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VideoTableViewCell" 
                                                     owner:self 
                                                   options:nil];
        if([nib count] > 0)
        {
            cell = self.videoTableViewCell;
        } 
        else
        {
            NSLog(@"Failed to load videoTableViewCell nig file!");
        }
    }
    
    // Get the correct video
    NSUInteger row = [indexPath row];
    NSLog(@"...at row: %i", row);
    HubPieceVideo *video = [self.videoListData objectAtIndex:row];
    
    // Title
    UILabel *videoTitleLabel = (UILabel *)[cell viewWithTag:kTitleValueTag];
    videoTitleLabel.text = [NSString stringWithFormat:@"%@", video.video_title];
    
    // Description
    UILabel *videoDescriptionTextView = (UILabel *)[cell viewWithTag:kDescriptionValueTag];
    videoDescriptionTextView.text = [NSString stringWithFormat:@"%@", video.video_caption];
    
    // Image
    UIImageView *videoImageView = (UIImageView *)[cell viewWithTag:kImageValueTag];
    [videoImageView setImageWithURL:[NSURL URLWithString:video.video_image_url] ];
    
    // Calculate time
    UILabel *videoDurationLabel = (UILabel *)[cell viewWithTag:kDurationValueTag];
    videoDurationLabel.text = [NSString stringWithFormat:@"Duration: %@ min", 
                               [Video getDurationStringFromSeconds:[video.video_duration doubleValue]]];
    
    return cell;
}

+(NSString *)getDurationStringFromSeconds:(double)seconds
{
    if(seconds)
    {
        int tmpMinutes = floor(seconds/60);
        int tmpSeconds = trunc(seconds - (tmpMinutes*60));
        return [NSString stringWithFormat:@"%i:%.2d", tmpMinutes, tmpSeconds];
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 136; // Change this when the cell size changes
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    HubPieceVideo *video = [self.videoListData objectAtIndex:row];
    
    // Open video
    NSString *url = [NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", video.video_external_id];
    [self embedYouTube:url withFrame:CGRectMake(0, 0, 280, 176)];
    
    // Show video information
    self.selected_videoTitle.text = video.video_title;
    self.selected_videoDescription.text = video.video_caption;
    // Calculate time
    double delta = [video.video_duration doubleValue];
    int minutes = floor(delta/60);
    int seconds = trunc(delta - (minutes*60));
    self.selected_videoDuration.text = [NSString 
                                        stringWithFormat:@"Duration %i:%i", minutes, seconds];
    self.selected_video.hidden = NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    // Change cell seperator color for table
    self.videoTableView.separatorColor = [UIColor clearColor];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.videoListData = nil;
    self.selected_video = nil;
    self.selected_videoWebView = nil;
    self.selected_videoTitle = nil;
    self.selected_videoDescription = nil;
    self.selected_videoDuration = nil;
    self.selected_videoClose = nil;
    self.videoTableView = nil;
    self.videoTableViewCell = nil;
    
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
