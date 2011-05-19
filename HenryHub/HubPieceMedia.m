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
    [self.title release];
    [self.caption release];
    [self.page_url release];
    [self.asset_url release];
    
    [super dealloc];
}

@end
