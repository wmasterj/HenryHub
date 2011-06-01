//
//  HubPiece.m
//  XMLAppTest
//
//  Created by jeroen on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HubPiece.h"
#import "TBXML.h"
#import "HenryHubAppDelegate.h"
#import "HubPieceAudio.h"
#import "HubPieceVideo.h"
#import "HubPieceImage.h"

@implementation HubPiece

@dynamic piece_id;
@dynamic piece_name;
@dynamic piece_description;
@dynamic piece_creation_date;
@dynamic piece_artist;
@dynamic piece_facebookid;
@dynamic piece_share_copy;
@dynamic piece_likes;
@dynamic piece_views;
@dynamic piece_last_viewed;
@dynamic videos;
@dynamic images;
@dynamic related;
@dynamic audio;

-(id)initWithXML:(TBXMLElement *)pieceXML
{
    // Setup the environment for dealing with Core Data and managed objects
    HenryHubAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityHubPiece = [NSEntityDescription entityForName:@"HubPiece" 
                                                      inManagedObjectContext:context];

    // STORING values
    self = [[HubPiece alloc] initWithEntity:entityHubPiece insertIntoManagedObjectContext:context];
    
    if(pieceXML) 
    {
        // ----------------------------- //
        //       General stuff           //
        // ----------------------------- //
        
        // Set time viewed
        //<CHANGE> also set when fetched from database
        [self setPiece_last_viewed:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] ];
        
        // ID
        [self setPiece_id:[TBXML valueOfAttributeNamed:@"id" forElement:pieceXML] ];
        
        // Title
        TBXMLElement *titleXML = [TBXML childElementNamed:@"title" parentElement:pieceXML];
        if(titleXML)
            [self setPiece_name:[NSString stringWithString:[TBXML textForElement:titleXML]] ];
        //self.piece_name = [NSString stringWithString:[TBXML textForElement:titleXML]];
        else
            NSLog(@"ERROR: No title available.");
        
        // Information output test
        // NSLog(@"ID: %@, Title: %@", self.piece_id, self.name);
        
        // Description
        TBXMLElement *descriptionXML = [TBXML childElementNamed:@"asset_description" parentElement:pieceXML];
        if(descriptionXML)
            [self setPiece_description:[TBXML textForElement:descriptionXML] ];
        else
            NSLog(@"ERROR: No description");
        
        // Creation date
        
        
        // Artist
        TBXMLElement *artistXML = [TBXML childElementNamed:@"artist" parentElement:pieceXML];
        if(artistXML)
            [self setPiece_artist:[TBXML textForElement:artistXML] ];
        else
            NSLog(@"ERROR: No artist");
        
        // Last time viewed
        
        
        // Information output test
        // NSLog(@"Artist: %@", self.artist);
        
        // Social stuff
        TBXMLElement *socialXML = [TBXML childElementNamed:@"social" parentElement:pieceXML];
        if(socialXML)
        {
            // Views
            [self setPiece_views:[TBXML textForElement:[TBXML childElementNamed:@"views" parentElement:socialXML]] ];
            // Facebook ID
            [self setPiece_facebookid:[TBXML textForElement:[TBXML childElementNamed:@"facebook_id" parentElement:socialXML]] ];
            // Facebook likes
            [self setPiece_likes:[TBXML textForElement:[TBXML childElementNamed:@"likes" parentElement:socialXML]] ];
            // Share copy
            [self setPiece_share_copy:[TBXML textForElement:[TBXML childElementNamed:@"share_copy" parentElement:socialXML]] ];
        }
        
        // Information output test
        // NSLog(@"View %@, FB ID %@, likes %@, Share copy '%@'", self.views, self.facebookid, self.likes, self.share_copy);
        
        // ----------------------------- //
        //       Related pieces          //
        // ----------------------------- // 
        TBXMLElement *relatedPiece = [TBXML childElementNamed:@"hubpiece" parentElement:[TBXML childElementNamed:@"related_hubpieces" parentElement:pieceXML]];
//        if(relatedPiece) {
//            do {
//                [self.related addObject:[TBXML textForElement:relatedPiece]];
//            } while ((relatedPiece = relatedPiece->nextSibling));
//        }
        
        // ----------------------------- //
        //       Video clips             //
        // ----------------------------- //
        TBXMLElement *hubVideo = [TBXML childElementNamed:@"video" parentElement:[TBXML childElementNamed:@"videos" parentElement:pieceXML]];
        if(hubVideo) {
            do {
                [self addVideosObject:[[HubPieceVideo alloc] initWithXML:hubVideo] ];
            } while ((hubVideo = hubVideo->nextSibling));
        }
        
        // ----------------------------- //
        //       Images                  //
        // ----------------------------- //
        TBXMLElement *hubImage = [TBXML childElementNamed:@"image" parentElement:[TBXML childElementNamed:@"images" parentElement:pieceXML]];
        if(hubImage) {
            do {
                [self addImagesObject: [[HubPieceImage alloc] initWithXML:hubImage]];
            } while ((hubImage = hubImage->nextSibling));
        }
        
        // ----------------------------- //
        //       Audio  (skipped!)       //
        // ----------------------------- //      
        
        // skipped to save implementation time by lowering complexity
        
        // ----------------------------- //
        //     Save Managed Object       //
        // ----------------------------- //      
        
        NSError *error;
        if(![context save:&error]) 
        {
            NSLog(@"HubPiece save context error: %@ %@", error, [error userInfo]); 
        }
    }
    
    return self;
}

#pragma mark - Core Data functions

- (void)addVideosObject:(NSManagedObject *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"videos" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"videos"] addObject:value];
    [self didChangeValueForKey:@"videos" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeVideosObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"videos" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"videos"] removeObject:value];
    [self didChangeValueForKey:@"videos" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addVideos:(NSSet *)value {    
    [self willChangeValueForKey:@"videos" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"videos"] unionSet:value];
    [self didChangeValueForKey:@"videos" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeVideos:(NSSet *)value {
    [self willChangeValueForKey:@"videos" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"videos"] minusSet:value];
    [self didChangeValueForKey:@"videos" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addImagesObject:(NSManagedObject *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"images" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"images"] addObject:value];
    [self didChangeValueForKey:@"images" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeImagesObject:(NSManagedObject *)value {
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


- (void)addRelatedObject:(NSManagedObject *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"related" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"related"] addObject:value];
    [self didChangeValueForKey:@"related" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeRelatedObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"related" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"related"] removeObject:value];
    [self didChangeValueForKey:@"related" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addRelated:(NSSet *)value {    
    [self willChangeValueForKey:@"related" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"related"] unionSet:value];
    [self didChangeValueForKey:@"related" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeRelated:(NSSet *)value {
    [self willChangeValueForKey:@"related" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"related"] minusSet:value];
    [self didChangeValueForKey:@"related" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (void)addAudioObject:(NSManagedObject *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"audio" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"audio"] addObject:value];
    [self didChangeValueForKey:@"audio" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeAudioObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"audio" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"audio"] removeObject:value];
    [self didChangeValueForKey:@"audio" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addAudio:(NSSet *)value {    
    [self willChangeValueForKey:@"audio" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"audio"] unionSet:value];
    [self didChangeValueForKey:@"audio" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeAudio:(NSSet *)value {
    [self willChangeValueForKey:@"audio" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"audio"] minusSet:value];
    [self didChangeValueForKey:@"audio" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

@end
