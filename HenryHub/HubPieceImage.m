//
//  HubPieceImage.m
//  HenryHub
//
//  Created by jeroen on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HubPieceImage.h"


@implementation HubPieceImage

@synthesize image_url=_image_url;

- (void)dealloc
{
    [self.image_url dealloc];
    [super dealloc];
}

@end
