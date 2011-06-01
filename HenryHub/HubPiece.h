//
//  HubPiece.h
//  XMLAppTest
//
//  Created by jeroen on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TBXML.h"


@interface HubPiece : NSManagedObject {
    
}

@property (nonatomic, retain) NSString *piece_id;
@property (nonatomic, retain) NSString *piece_name;
@property (nonatomic, retain) NSString *piece_description;
@property (nonatomic, retain) NSString *piece_creation_date;
@property (nonatomic, retain) NSString *piece_artist;

// Lists of content
@property (nonatomic, retain) NSSet *related;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) NSSet *videos;
@property (nonatomic, retain) NSSet *audio;

// Social
@property (nonatomic, retain) NSString *piece_facebookid;
@property (nonatomic, retain) NSString *piece_share_copy;
@property (nonatomic, retain) NSString *piece_likes;
@property (nonatomic, retain) NSString *piece_views;

// User metadata
@property (nonatomic, retain) NSNumber *piece_last_viewed;

-(id)initWithXML:(TBXMLElement *)pieceXML;
- (void)addVideosObject:(NSManagedObject *)value;
- (void)addImagesObject:(NSManagedObject *)value;
- (void)addRelatedObject:(NSManagedObject *)value;

@end
