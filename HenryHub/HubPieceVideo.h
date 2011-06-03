//
//  HubPieceVideo.h
//  HenryHub
//
//  Created by jeroen on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "HubPiece.h"
#import "TBXML.h"

/*!
 @class HubPieceAudio
 
 @abstract A model class that contains information about a video attached 
 to a hub piece.
 */
@interface HubPieceVideo : NSManagedObject {
    
}

@property (nonatomic, retain) NSString * video_title;
@property (nonatomic, retain) NSString * video_asset_url;
@property (nonatomic, retain) NSString * video_page_url;
@property (nonatomic, retain) NSString * video_duration;
@property (nonatomic, retain) NSString * video_caption;
@property (nonatomic, retain) NSString * video_external_id;
@property (nonatomic, retain) NSString * video_image_url;
@property (nonatomic, retain) NSString * video_views;
@property (nonatomic, retain) HubPiece * piece;

-(id)initWithXML:(TBXMLElement *)videoXML;

@end
    