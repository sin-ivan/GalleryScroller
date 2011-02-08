//
//  GalleryViewController.h
//  Berlingske
//
//  Created by Taras Kalapun on 27.09.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKScrollViewController.h"
#import "GalleryItemView.h"

@interface GalleryViewController : TKScrollViewController 
<GalleryItemDelegate>
{
    BOOL isShowingControls;    
}


@property (nonatomic, retain) NSArray *photos;
@property (nonatomic, assign) BOOL pageScrolled;

- (void)relocateComponentsToOrientation:(UIInterfaceOrientation)orientation;


@end
