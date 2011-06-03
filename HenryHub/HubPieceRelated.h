//
//  HubPieceRelated.h
//  HenryHub
//
//  Created by jeroen on 6/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "HubPiece.h"
#import "TBXML.h"

@interface HubPieceRelated : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * piece_id;
@property (nonatomic, retain) NSString * piece_name;
@property (nonatomic, retain) NSString * piece_likes;
@property (nonatomic, retain) NSString * piece_artist;
@property (nonatomic, retain) HubPiece * piece;

-(id)initWithXML:(TBXMLElement *)relatedXML;

@end