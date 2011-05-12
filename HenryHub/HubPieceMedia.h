//
//  HubPieceMedia.h
//  HenryHub
//
//  Created by jeroen on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class HubPieceMedia
 
 @abstract This is a higher level object in order to set the correct 
 relationships between objects. Also since all other media assets will
 be inheriting from this class we can create collections holding any
 type of media in it, if that would be necessary.
 */
@interface HubPieceMedia : NSObject {
    
    NSString    *title;     // The name of this media asset
    NSString    *caption;   // This assets caption/description
    NSURL       *page_url;  // URL to a this asset's page
    NSURL       *asset_url; // Direct link to this media asset
    
    
}

@property (nonatomic, retain) NSString    *title;     
@property (nonatomic, retain) NSString    *caption;   
@property (nonatomic, retain) NSURL       *image_url; 
@property (nonatomic, retain) NSString    *page_url;  

@end