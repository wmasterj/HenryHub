//
//  HubPieceImage.m
//  HenryHub
//
//  Created by jeroen on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HubPieceImage.h"
#import "HenryHubAppDelegate.h"
#import "TBXML.h"
#import "HubPiece.h"


@implementation HubPieceImage

@dynamic image_asset_thumb_url;
@dynamic image_page_url;
@dynamic image_asset_url;
@dynamic image_title;
@dynamic image_caption;
@dynamic piece;

// INIT methods   -   start //

-(id)initWithXML:(TBXMLElement *)imageXML
{
    // Setup the environment for dealing with Core Data and managed objects
    HenryHubAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityHubPieceVideo = [NSEntityDescription entityForName:@"HubPieceImage" 
                                                           inManagedObjectContext:context];
    
    self = [[HubPieceImage alloc] initWithEntity:entityHubPieceVideo insertIntoManagedObjectContext:context];
    
    if(imageXML) 
    {
        [self setImage_title: [TBXML textForElement: [TBXML childElementNamed:@"title" parentElement:imageXML]] ];
        [self setImage_asset_url: [TBXML textForElement: [TBXML childElementNamed:@"url" parentElement:imageXML]] ];
        [self setImage_page_url: [TBXML textForElement: [TBXML childElementNamed:@"page_link" parentElement:imageXML]] ];
        [self setImage_caption: [TBXML textForElement: [TBXML childElementNamed:@"description" parentElement:imageXML]] ];
    }
    
    NSError *error;
    if(![context save:&error]) 
    {
        NSLog(@"HubPieceImage save context error: %@ %@", error, [error userInfo]); 
    }
    
    return self;
}

@end
