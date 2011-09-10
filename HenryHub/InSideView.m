//
//  InSideView.m
//  HenryHub
//
//  Created by Jeroen van den Eijkhof, jeroen@uw.edu on 5/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InSideView.h"
#import "AppInfo.h"

@implementation InSideView

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

-(void)willRemoveSubview:(UIView *)subview
{
    NSLog(@"Subview will be removed");
    [self.parentController loadObjectsToTableView];
}

@end
