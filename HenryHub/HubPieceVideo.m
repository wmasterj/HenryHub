//
//  HubPieceVideo.m
//  HenryHub
//
//  Created by jeroen on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HubPieceVideo.h"
#import "TBXML.h"


@implementation HubPieceVideo

@synthesize image_url=_image_url, external_id=_object_id, duration=_duration, views=_views;

-(id)initWithXML:(TBXMLElement *)videoXML
{
    self = [super init];
    
    if(videoXML) 
    {
        self.title = [TBXML textForElement: [TBXML childElementNamed:@"title" parentElement:videoXML]];
        self.external_id = [TBXML textForElement: [TBXML childElementNamed:@"serviceid" parentElement:videoXML]];
        self.asset_url = [NSURL URLWithString:[TBXML textForElement: [TBXML childElementNamed:@"url" parentElement:videoXML]]];
        self.image_url = [NSURL URLWithString:[TBXML textForElement: [TBXML childElementNamed:@"thumbnail" parentElement:videoXML]]];
        self.page_url = [NSURL URLWithString:[TBXML textForElement: [TBXML childElementNamed:@"url" parentElement:videoXML]]];
        self.caption = [TBXML textForElement: [TBXML childElementNamed:@"description" parentElement:videoXML]];;
        self.duration = [NSNumber numberWithInt: [[TBXML textForElement: [TBXML childElementNamed:@"duration" parentElement:videoXML]] integerValue]];
        self.views = [TBXML textForElement: [TBXML childElementNamed:@"views" parentElement:videoXML]];
    }
    return self;
}

- (void)dealloc
{
    [self.image_url release];
    [self.external_id release];
    [self.duration release];
    
    [super dealloc];
}

@end
