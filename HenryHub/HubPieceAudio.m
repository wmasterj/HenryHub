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

@dynamic audio_title;
@dynamic audio_page_url;
@dynamic audio_asset_url;
@dynamic audio_duration;
@dynamic audio_caption;
@dynamic piece;

-(id)initWithXML:(TBXMLElement *)audioXML
{
    self = [super init];
    
    if(audioXML) 
    {
        
        [self setAudio_title:[TBXML textForElement: [TBXML childElementNamed:@"title" parentElement:audioXML]] ];
        [self setAudio_asset_url:[TBXML textForElement: [TBXML childElementNamed:@"url" parentElement:audioXML]] ];
        [self setAudio_page_url:[TBXML textForElement: [TBXML childElementNamed:@"url" parentElement:audioXML]] ];
        [self setAudio_caption:[TBXML textForElement: [TBXML childElementNamed:@"description" parentElement:audioXML]] ];
        [self setAudio_duration:[NSNumber numberWithInt:
                                 [[TBXML textForElement: [TBXML childElementNamed:@"duration" 
                                                                                           parentElement:audioXML]] integerValue]] ];
        return self;
    }
    return self;
}


@end
