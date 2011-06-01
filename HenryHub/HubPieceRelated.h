//
//  HubPieceRelated.h
//  HenryHub
//
//  Created by jeroen on 6/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TBXMLElement;
@class HubPiece;

@interface HubPieceRelated : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * piece_id;
@property (nonatomic, retain) HubPiece * piece;

-(id)initWithXML:(TBXMLElement *)relatedXML;

@end
