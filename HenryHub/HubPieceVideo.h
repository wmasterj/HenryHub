//
//  HubPieceVideo.h
//  HenryHub
//
//  Created by jeroen on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HubPieceMedia.h"
#import "TBXML.h"

/*!
 @class HubPieceAudio
 
 @abstract A model class that contains information about a video attached 
 to a hub piece.
 */
@interface HubPieceVideo : HubPieceMedia {
    
}

@property (nonatomic, retain) NSString    *external_id;
@property (nonatomic, retain) NSURL       *image_url; 
@property (nonatomic, retain) NSNumber    *duration;
@property (nonatomic, retain) NSString    *views;

-(id)initWithXML:(TBXMLElement *)videoXML;

@end
    