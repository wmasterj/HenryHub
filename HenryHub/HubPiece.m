//
//  HubPiece.m
//  XMLAppTest
//
//  Created by jeroen on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HubPiece.h"
#import "TBXML.h"
#import "HubPieceAudio.h"
#import "HubPieceVideo.h"
#import "HubPieceImage.h"

@implementation HubPiece

@synthesize piece_id=_piece_id, name=_name, description=_description, creation_date=_creation_date, artist=_artist;
@synthesize related=_related, images=_images, videos=_videos, audio=_audio;
@synthesize facebookid=_facebookid, share_copy=_share_copy, likes=_likes, views=_views;

-(id)initWithXML:(TBXMLElement *)pieceXML
{
    // STORING values
    self = [[HubPiece alloc] init];
    
    if(pieceXML) 
    {
        // ----------------------------- //
        //       General stuff           //
        // ----------------------------- //
        
        // ID
        self.piece_id = [TBXML valueOfAttributeNamed:@"id" forElement:pieceXML];
        
        // Title
        TBXMLElement *titleXML = [TBXML childElementNamed:@"title" parentElement:pieceXML];
        if(titleXML)
            self.name = [NSString stringWithString:[TBXML textForElement:titleXML]];
        else
            NSLog(@"ERROR: No title available.");
        
        // Information output test
        // NSLog(@"ID: %@, Title: %@", self.piece_id, self.name);
        
        // Description
        TBXMLElement *descriptionXML = [TBXML childElementNamed:@"asset_description" parentElement:pieceXML];
        if(descriptionXML)
            self.description = [TBXML textForElement:descriptionXML];
        else
            NSLog(@"ERROR: No description");
        
        // Artist
        TBXMLElement *artistXML = [TBXML childElementNamed:@"artist" parentElement:pieceXML];
        if(artistXML)
            self.artist = [TBXML textForElement:artistXML];
        else
            NSLog(@"ERROR: No artist");
        
        // Information output test
        // NSLog(@"Artist: %@", self.artist);
        
        // Social stuff
        TBXMLElement *socialXML = [TBXML childElementNamed:@"social" parentElement:pieceXML];
        if(socialXML)
        {
            // Views
            self.views = [TBXML textForElement:[TBXML childElementNamed:@"views" parentElement:socialXML]];
            // Facebook ID
            self.facebookid = [TBXML textForElement:[TBXML childElementNamed:@"facebook_id" parentElement:socialXML]];
            // Facebook likes
            self.likes = [TBXML textForElement:[TBXML childElementNamed:@"likes" parentElement:socialXML]];
            // Share copy
            self.share_copy = [TBXML textForElement:[TBXML childElementNamed:@"share_copy" parentElement:socialXML]];
        }
        
        // Information output test
        // NSLog(@"View %@, FB ID %@, likes %@, Share copy '%@'", self.views, self.facebookid, self.likes, self.share_copy);
        
        // ----------------------------- //
        //       Related pieces          //
        // ----------------------------- //
        TBXMLElement *relatedPiece = [TBXML childElementNamed:@"hubpiece" parentElement:[TBXML childElementNamed:@"related_hubpieces" parentElement:pieceXML]];
        if(self.related != nil)
            [self.related release];
        self.related = [[NSMutableArray alloc] init];
        if(relatedPiece) {
            do {
                [self.related addObject:[TBXML textForElement:relatedPiece]];
                
            } while ((relatedPiece = relatedPiece->nextSibling));
        }
        
        // ----------------------------- //
        //       Video clips             //
        // ----------------------------- //
        TBXMLElement *hubVideo = [TBXML childElementNamed:@"video" parentElement:[TBXML childElementNamed:@"videos" parentElement:pieceXML]];
        if(self.videos != nil)
            [self.videos release];
        self.videos = [[NSMutableArray alloc] init];
        if(hubVideo) {
            do {
                [self.videos addObject:[[HubPieceVideo alloc] initWithXML:hubVideo] ];
            } while ((hubVideo = hubVideo->nextSibling));
        }
        
        // ----------------------------- //
        //       Images                  //
        // ----------------------------- //
        TBXMLElement *hubImage = [TBXML childElementNamed:@"image" parentElement:[TBXML childElementNamed:@"images" parentElement:pieceXML]];
        if(self.images != nil)
            [self.images release];
        self.images = [[NSMutableArray alloc] init];
        if(hubImage) {
            do {
                [self.images addObject: [[HubPieceImage alloc] initWithXML:hubImage]];
            } while ((hubImage = hubImage->nextSibling));
        }
        
        // ----------------------------- //
        //       Audio clips             //
        // ----------------------------- //        
    }
    
    return self;
}

- (void) dealloc
{
    NSLog(@"Releasing HubPiece data");
    [self.piece_id release];
    [self.name release];
    [self.description release];
    [self.creation_date release];
    [self.artist release];
    
    [self.related release];
    [self.images release];
    [self.videos release];
    [self.audio release];
    
    [self.facebookid release];
    [self.share_copy release];
    [self.views release];
    [self.likes release];
    
    [super dealloc];
}

@end
