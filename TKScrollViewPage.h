//
//  TKScrollViewPage.h
//  Berlingske
//
//  Created by Taras Kalapun on 13.07.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TKScrollViewPage : UIView {
    NSUInteger index;
    NSString *reuseIdentifier;
}

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, retain) NSString *reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)identifier;

@end
