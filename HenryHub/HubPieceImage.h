//
//  HubPieceImage.h
//  HenryHub
//
//  Created by jeroen on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HubPieceMedia.h"
#import "TBXML.h"


/*!
 @class HubPieceImage
 
 @abstract A model class that contains information about an image attached 
 to a hub piece.
 */
@interface HubPieceImage : HubPieceMedia {
    
}

-(id)initWithXML:(TBXMLElement *)imageXML;

@end