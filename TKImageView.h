//
//  TKImageView.h
//  Grazia
//
//  Created by Taras Kalapun on 09.12.09.
//  Copyright 2009 Taras Kalapun. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TKImageView : UIImageView {
	SEL callbackAction;
	id callbackTarget;
}

//- (void)addTarget:(id)target action:(SEL)action;

@end
