//
//  HHTextView_BrandonBold.m
//  HenryHub
//
//  Created by jeroen on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HHTextView_BrandonBold.h"


@implementation HHTextView_BrandonBold

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) 
    {
        [self setFont:[UIFont fontWithName: @"BrandonGrotesque-Bold" 
                                      size: self.font.pointSize]];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
