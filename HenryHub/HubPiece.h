//
//  HubPiece.h
//  XMLAppTest
//
//  Created by jeroen on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"


@interface HubPiece : NSObject {
    
}

@property (nonatomic, retain) NSString *piece_id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSDate   *creation_date;
@property (nonatomic, retain) NSString *artist;

// Lists of content
@property (nonatomic, retain) NSMutableArray  *related;
@property (nonatomic, retain) NSMutableArray  *images;
@property (nonatomic, retain) NSMutableArray  *videos;
@property (nonatomic, retain) NSMutableArray  *audio;

// Social
@property (nonatomic, retain) NSString *facebookid;
@property (nonatomic, retain) NSString *share_copy;
@property (nonatomic, retain) NSString *likes;
@property (nonatomic, retain) NSString *views;

-(id)initWithXML:(TBXMLElement *)pieceXML;

@end
