//
//  RelatedView.m
//  HenryHub
//
//  Created by jeroen on 8/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RelatedView.h"
#import "Related.h"

@implementation RelatedView

@synthesize parentController = _parentController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

/**
 * This is called when a subview is going to be removed and hides the 
 * related window in order to make navigation flow better.
 */
- (void)willRemoveSubview:(UIView *)subview {
    [self.parentController closeRelatedView:nil];
}

@end
