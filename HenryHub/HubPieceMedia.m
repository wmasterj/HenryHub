//
//  HubPieceMedia.m
//  HenryHub
//
//  Created by jeroen on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HubPieceMedia.h"


@implementation HubPieceMedia

@synthesize title=_title, caption=_caption, image_url=_image_url, page_url=_page_url;

- (void)dealloc
{
    [self.title dealloc];
    [self.caption dealloc];
    [self.image_url dealloc];
    [self.page_url dealloc];
    
    [super dealloc];
}

@end
