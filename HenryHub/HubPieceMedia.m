//
//  HubPieceMedia.m
//  HenryHub
//
//  Created by jeroen on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HubPieceMedia.h"


@implementation HubPieceMedia

@synthesize title=_title, caption=_caption, page_url=_page_url, asset_url=_asset_url;

- (void)dealloc
{
    [self.title dealloc];
    [self.caption dealloc];
    [self.page_url dealloc];
    [self.asset_url dealloc];
    
    [super dealloc];
}

@end
