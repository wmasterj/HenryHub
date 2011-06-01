//
//  HubPieceVideo.m
//  HenryHub
//
//  Created by jeroen on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HubPieceVideo.h"
#import "HenryHubAppDelegate.h"
#import "TBXML.h"


@implementation HubPieceVideo

@dynamic video_title;
@dynamic video_asset_url;
@dynamic video_page_url;
@dynamic video_caption;
@dynamic video_duration;
@dynamic video_external_id;
@dynamic video_image_url;
@dynamic video_views;
@dynamic piece;

-(id)initWithXML:(TBXMLElement *)videoXML
{
    // Setup the environment for dealing with Core Data and managed objects
    HenryHubAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityHubPieceVideo = [NSEntityDescription entityForName:@"HubPieceVideo" 
                                                           inManagedObjectContext:context];
    
    self = [[HubPieceVideo alloc] initWithEntity:entityHubPieceVideo insertIntoManagedObjectContext:context];
    
    if(videoXML) 
    {
        [self setVideo_title:[TBXML textForElement: [TBXML childElementNamed:@"title" parentElement:videoXML]] ];
        [self setVideo_external_id:[TBXML textForElement: [TBXML childElementNamed:@"serviceid" parentElement:videoXML]] ];
        [self setVideo_asset_url:[TBXML textForElement: [TBXML childElementNamed:@"url" parentElement:videoXML]] ];
        [self setVideo_image_url:[TBXML textForElement: [TBXML childElementNamed:@"thumbnail" parentElement:videoXML]] ];
        [self setVideo_page_url:[TBXML textForElement: [TBXML childElementNamed:@"url" parentElement:videoXML]] ];
        [self setVideo_caption:[TBXML textForElement: [TBXML childElementNamed:@"description" parentElement:videoXML]] ];
        [self setVideo_duration:[TBXML textForElement: [TBXML childElementNamed:@"duration" parentElement:videoXML]] ];
        [self setVideo_views:[TBXML textForElement: [TBXML childElementNamed:@"views" parentElement:videoXML]] ];
    }
    
    NSError *error;
    if(![context save:&error]) 
    {
        NSLog(@"HubPieceVideo save context error: %@ %@", error, [error userInfo]); 
    }
    
    return self;
}

@end
