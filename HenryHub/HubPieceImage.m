//
//  HubPieceImage.m
//  HenryHub
//
//  Created by jeroen on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HubPieceImage.h"
#import "TBXML.h"


@implementation HubPieceImage

// INIT methods   -   start //

-(id)initWithXML:(TBXMLElement *)imageXML
{
    self = [super init];
    
    if(imageXML) 
    {
        self.title = [TBXML textForElement: [TBXML childElementNamed:@"title" parentElement:imageXML]];;
        self.asset_url = [NSURL URLWithString:[TBXML textForElement: [TBXML childElementNamed:@"url" parentElement:imageXML]] ];
        self.page_url = [NSURL URLWithString:[TBXML textForElement: [TBXML childElementNamed:@"page_link" parentElement:imageXML]] ];
        self.caption = [TBXML textForElement: [TBXML childElementNamed:@"description" parentElement:imageXML]];;
        return self;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
