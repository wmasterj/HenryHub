//
//  HubPieceAudio.h
//  HenryHub
//
//  Created by jeroen on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HubPiece;

/*!
 @class HubPieceAudio
 
 @abstract A model class that contains information about audio attached 
 to a hub piece.
 */
@interface HubPieceAudio : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * audio_title;
@property (nonatomic, retain) NSString * audio_page_url;
@property (nonatomic, retain) NSString * audio_asset_url;
@property (nonatomic, retain) NSNumber * audio_duration;
@property (nonatomic, retain) NSString * audio_caption;
@property (nonatomic, retain) HubPiece * piece;

@end