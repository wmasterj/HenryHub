//
//  HubPieceRelated.m
//  HenryHub
//
//  Created by jeroen on 6/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HubPieceRelated.h"
#import "HenryHubAppDelegate.h"
#import "HubPiece.h"
#import "TBXML.h"


@implementation HubPieceRelated

@dynamic piece_id;
@dynamic piece_name;
@dynamic piece_likes;
@dynamic piece_artist;
@dynamic piece;

-(id)initWithXML:(TBXMLElement *)relatedXML
{
    // Setup the environment for dealing with Core Data and managed objects
    HenryHubAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityHubPieceRelate = [NSEntityDescription entityForName:@"HubPieceRelated" 
                                                           inManagedObjectContext:context];
    
    self = [[HubPieceRelated alloc] initWithEntity:entityHubPieceRelate insertIntoManagedObjectContext:context];
    
    if(relatedXML) 
    {
        NSLog(@"NAME: %@", [TBXML textForElement: [TBXML childElementNamed:@"name" parentElement:relatedXML]]);
        
        [self setPiece_id:[TBXML textForElement: [TBXML childElementNamed:@"id" parentElement:relatedXML]] ];
        [self setPiece_name:[TBXML textForElement: [TBXML childElementNamed:@"name" parentElement:relatedXML]] ];
        [self setPiece_artist:[TBXML textForElement: [TBXML childElementNamed:@"artist" parentElement:relatedXML]] ];
        [self setPiece_likes:[TBXML textForElement: [TBXML childElementNamed:@"likes" parentElement:relatedXML]] ];
        
        // Store first image for display in table cell
//        TBXMLElement *relatedPiece = [TBXML childElementNamed:@"hubpiece" parentElement:[TBXML childElementNamed:@"related_hubpieces" parentElement:pieceXML]];
//        if(relatedPiece) {
//            do {
//                [self addRelatedObject:[[HubPieceRelated alloc] initWithXML:relatedPiece] ];
//            } while ((relatedPiece = relatedPiece->nextSibling));
//        }
    }
    
    NSError *error;
    if(![context save:&error]) 
    {
        NSLog(@"HubPieceRelated save context error: %@ %@", error, [error userInfo]); 
    }
    
    return self;
}


@end
