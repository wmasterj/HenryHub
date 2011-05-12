//
//  HubPieceVideo.h
//  HenryHub
//
//  Created by jeroen on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HubPieceMedia.h"

/*!
 @class HubPieceAudio
 
 @abstract A model class that contains information about a video attached 
 to a hub piece.
 */
@interface HubPieceVideo : HubPieceMedia {
    
    NSNumber        *external_id; // This videos id on youtube/vimeo.
    NSURL           *image_url; // Direct link to the image online
    NSNumber        *duration;  // Video duration in seconds
    
}

@property (nonatomic, retain) NSNumber    *external_id;
@property (nonatomic, retain) NSURL       *image_url; 
@property (nonatomic, retain) NSNumber    *duration;

@end
    