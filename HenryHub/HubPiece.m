//
//  HubPiece.m
//  XMLAppTest
//
//  Created by jeroen on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HubPiece.h"

@implementation HubPiece

@synthesize piece_id, name, description, creation_date, artist;
@synthesize related, images, videos, audio;
@synthesize facebookid, share_copy, likes;

- (void) dealloc
{
    [name release];
    [description release];
    [creation_date release];
    [artist release];
    [related release];
    [images release];
    [videos release];
    [audio release];
    [facebookid release];
    [share_copy release];
    
    [super dealloc];
}

@end
