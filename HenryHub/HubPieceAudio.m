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
        NSString *audioTitle = [TBXML textForElement: [TBXML childElementNamed:@"title" parentElement:audioXML]];
        NSString *audioURL = [TBXML textForElement: [TBXML childElementNamed:@"url" parentElement:audioXML]];
        NSString *audioPageURL = [TBXML textForElement: [TBXML childElementNamed:@"url" parentElement:audioXML]];
        NSString *audioDescription = [TBXML textForElement: [TBXML childElementNamed:@"description" parentElement:audioXML]];
        NSString *audioDuration = [TBXML textForElement: [TBXML childElementNamed:@"duration" parentElement:audioXML]];
        
        self.title       = audioTitle;
        self.asset_url   = [NSURL URLWithString:audioURL];
        self.page_url    = [NSURL URLWithString:audioPageURL];
        self.caption     = audioDescription;
        self.duration    = [NSNumber numberWithInt:[audioDuration integerValue]];
        return self;
    }
    return self;
}

- (void)dealloc
{
    [self.duration dealloc];
    
    [super dealloc];
}

@end
