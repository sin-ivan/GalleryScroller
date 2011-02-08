//
//  TKScrollViewPage.m
//  Berlingske
//
//  Created by Taras Kalapun on 13.07.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TKScrollViewPage.h"


@implementation TKScrollViewPage

@synthesize index, reuseIdentifier;

- (id)init {
	return [self initWithFrame:[UIScreen mainScreen].applicationFrame];
}

- (id)initWithReuseIdentifier:(NSString *)identifier {
    if ((self = [super init])) {
        self.reuseIdentifier = identifier;
    }
    return self;
}



- (void)dealloc {
    
    [reuseIdentifier release];    
    [super dealloc];
}


@end
