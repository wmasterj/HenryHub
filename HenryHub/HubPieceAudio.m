//
//  HubPieceAudio.m
//  HenryHub
//
//  Created by jeroen on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HubPieceAudio.h"
#import "TBXML.h"

@implementation HubPieceAudio

@synthesize duration=_duration;

-(id)initWithXML:(TBXMLElement *)audioXML
{
    self = [super init];
    
    if(audioXML) 
    {
        
        self.title       = [TBXML textForElement: [TBXML childElementNamed:@"title" parentElement:audioXML] ];
        self.asset_url   = [NSURL URLWithString:[TBXML textForElement: [TBXML childElementNamed:@"url" parentElement:audioXML] ] ];
        self.page_url    = [NSURL URLWithString:[TBXML textForElement: [TBXML childElementNamed:@"url" parentElement:audioXML] ] ];
        self.caption     = [TBXML textForElement: [TBXML childElementNamed:@"description" parentElement:audioXML] ];
        self.duration    = [NSNumber numberWithInt:[[TBXML textForElement: [TBXML childElementNamed:@"duration" parentElement:audioXML]] integerValue]];
        return self;
    }
    return self;
}

- (void)dealloc
{
    [self.duration release];
    
    [super dealloc];
}

@end
