//
//  HubPieceVideo.m
//  HenryHub
//
//  Created by jeroen on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HubPieceVideo.h"


@implementation HubPieceVideo

@synthesize image_url=_image_url, external_id=_object_id, duration=_duration;

- (void)dealloc
{
    [self.image_url dealloc];
    [self.external_id dealloc];
    [self.duration dealloc];
    
    [super dealloc];
}

@end
