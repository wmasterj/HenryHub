//
//  HubPieceAudio.h
//  HenryHub
//
//  Created by jeroen on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HubPieceMedia.h"

/*!
 @class HubPieceAudio
 
 @abstract A model class that contains information about audio attached 
 to a hub piece.
 */
@interface HubPieceAudio : HubPieceMedia {
    
    NSNumber        *external_id; // This audios id on henryart.org
    NSNumber        *duration;  // Audio duration in seconds
    
}

@property (nonatomic, retain) NSNumber    *external_id;
@property (nonatomic, retain) NSNumber    *duration;

@end