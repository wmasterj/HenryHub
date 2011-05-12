//
//  HubPieceAudio.m
//  HenryHub
//
//  Created by jeroen on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HubPieceAudio.h"


@implementation HubPieceAudio

@synthesize external_id=_external_id, duration=_duration;

- (void)dealloc
{
    [self.external_id dealloc];
    [self.duration dealloc];
    
    [super dealloc];
}

@end
