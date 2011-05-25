//
//  XMLView.h
//  HenryHub
//
//  Created by jeroen on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HubPiece;
@class TBXML;
@class TBXMLElement;

@protocol HttpDataDelegate <NSObject>

-(void)dataDidDownload:(BOOL)success;
-(void)dataDidNotDownload:(BOOL)success;
-(void)dataResultInvalid:(BOOL)success;

@end

/*!
 @class HubXMLConnection
 
 @abstract A controller class that takes care of establishing a connection
 to a URL that returns simple XML data. It is not possible to alter any of
 the incoming XML but the read performance is good.
 */
@interface HubXMLConnection : NSObject {
    
    NSMutableData *receivedData;
    TBXMLElement *pieceXML;
    NSString *stringXML;
    id <HttpDataDelegate> delegate;
    
}

@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSString *stringXML;
@property (retain) id delegate;

-(BOOL)connect:(NSString *)idString;

@end
