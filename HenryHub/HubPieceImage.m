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
        NSString *imageTitle = [TBXML textForElement: [TBXML childElementNamed:@"title" parentElement:imageXML]];
        NSString *imageURL = [TBXML textForElement: [TBXML childElementNamed:@"url" parentElement:imageXML]];
        NSString *imagePageURL = [TBXML textForElement: [TBXML childElementNamed:@"page_link" parentElement:imageXML]];
        NSString *imageDescription = [TBXML textForElement: [TBXML childElementNamed:@"description" parentElement:imageXML]];
        self.title = imageTitle;
        self.asset_url = [NSURL URLWithString:imageURL];
        self.page_url = [NSURL URLWithString:imagePageURL];
        self.caption = imageDescription;
        return self;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
