//
//  TKImageView.m
//  Grazia
//
//  Created by Taras Kalapun on 09.12.09.
//  Copyright 2009 Taras Kalapun. All rights reserved.
//

#import "TKImageView.h"

@implementation TKImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization
        [self setUserInteractionEnabled:YES];
		self.contentMode = UIViewContentModeScaleAspectFit;
		self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

//- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
//{
//	if (callbackTarget && callbackAction) {
//		if ([callbackTarget respondsToSelector:callbackAction]) {
//			[callbackTarget performSelector:callbackAction withObject:self];
//		}
//	}
//}

//- (void)addTarget:(id)target action:(SEL)action {
//	callbackAction = action;
//	callbackTarget = target;
//}

@end
