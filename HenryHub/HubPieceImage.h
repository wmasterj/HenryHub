//
//  HubPieceImage.h
//  HenryHub
//
//  Created by jeroen on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@class HubPiece;

/*!
 @class HubPieceImage
 
 @abstract A model class that contains information about an image attached 
 to a hub piece.
 */
@interface HubPieceImage : NSManagedObject {
@private
}

@property (nonatomic, retain) NSString * image_asset_thumb_url;
@property (nonatomic, retain) NSString * image_page_url;
@property (nonatomic, retain) NSString * image_asset_url;
@property (nonatomic, retain) NSString * image_title;
@property (nonatomic, retain) NSString * image_caption;
@property (nonatomic, retain) HubPiece * piece;


-(id)initWithXML:(TBXMLElement *)imageXML;

@end