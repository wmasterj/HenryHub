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
@dynamic images;

-(id)initWithXML:(TBXMLElement *)relatedXML
{
    // Setup the environment for dealing with Core Data and managed objects
    HenryHubAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityHubPieceRelate = [NSEntityDescription entityForName:@"HubPieceRelated" inManagedObjectContext:context];
    
    self = [[HubPieceRelated alloc] initWithEntity:entityHubPieceRelate insertIntoManagedObjectContext:context];
    
    if(relatedXML) 
    {
        NSLog(@"NAME: %@", [TBXML textForElement: [TBXML childElementNamed:@"name" parentElement:relatedXML]]);
        
        [self setPiece_id:[TBXML textForElement: [TBXML childElementNamed:@"id" parentElement:relatedXML]] ];
        [self setPiece_name:[TBXML textForElement: [TBXML childElementNamed:@"name" parentElement:relatedXML]] ];
        [self setPiece_artist:[TBXML textForElement: [TBXML childElementNamed:@"artist" parentElement:relatedXML]] ];
        [self setPiece_likes:[TBXML textForElement: [TBXML childElementNamed:@"likes" parentElement:relatedXML]] ];
        
        // Load image here by adding it to the core data model and then using setImage or something
        
        
    }
    
    NSError *error;
    if(![context save:&error]) 
    {
        NSLog(@"HubPieceRelated save context error: %@ %@", error, [error userInfo]); 
    }
    
    return self;
}

- (void)addImagesObject:(HubPieceImage *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"images" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"images"] addObject:value];
    [self didChangeValueForKey:@"images" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeImagesObject:(HubPieceImage *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"images" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"images"] removeObject:value];
    [self didChangeValueForKey:@"images" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addImages:(NSSet *)value {    
    [self willChangeValueForKey:@"images" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"images"] unionSet:value];
    [self didChangeValueForKey:@"images" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeImages:(NSSet *)value {
    [self willChangeValueForKey:@"images" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"images"] minusSet:value];
    [self didChangeValueForKey:@"images" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

@end
