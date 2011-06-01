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
        NSString *tmpStr = [TBXML textForElement: [TBXML childElementNamed:@"title" parentElement:relatedXML]];
        [self setPiece_id: [NSNumber numberWithInt:[tmpStr integerValue]]];
    }
    
    NSError *error;
    if(![context save:&error]) 
    {
        NSLog(@"HubPieceRelated save context error: %@ %@", error, [error userInfo]); 
    }
    
    return self;
}


@end
