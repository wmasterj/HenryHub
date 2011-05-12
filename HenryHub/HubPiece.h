//
//  HubPiece.h
//  XMLAppTest
//
//  Created by jeroen on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HubPiece : NSObject {
    
    NSNumber *piece_id;
    NSString *name;
    NSString *description;
    NSDate   *creation_date;
    NSString *artist;
    
    // Content lists
    NSArray  *related;
    NSArray  *images;
    NSArray  *videos;
    NSArray  *audio;
    
    // Social
    NSNumber *facebookid;
    NSString *share_copy;
    NSNumber *likes;
    
}

@property (nonatomic, retain) NSNumber *piece_id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSDate   *creation_date;
@property (nonatomic, retain) NSString *artist;

// Lists of content
@property (nonatomic, retain) NSArray  *related;
@property (nonatomic, retain) NSArray  *images;
@property (nonatomic, retain) NSArray  *videos;
@property (nonatomic, retain) NSArray  *audio;

// Social
@property (nonatomic, retain) NSNumber *facebookid;
@property (nonatomic, retain) NSString *share_copy;
@property (nonatomic, retain) NSNumber *likes;

@end
