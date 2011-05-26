//
//  HHTextView_BrandonRegular.m
//  HenryHub
//
//  Created by jeroen on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HHTextView_BrandonRegular.h"


@implementation HHTextView_BrandonRegular

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
        [self setFont: [UIFont fontWithName: @"BrandonGrotesque-Regular" 
                                       size: self.font.pointSize]];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
