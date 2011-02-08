//
//  TKScrollView.m
//  iccoss
//
//  Created by Ivan Sinitsa on 01.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TKScrollView.h"


@implementation TKScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
    }
    return self;
}

- (void)dealloc {
    
    [super dealloc];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

@end
