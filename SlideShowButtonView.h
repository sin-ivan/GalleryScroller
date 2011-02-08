//
//  DescriptionView.h
//  iccoss
//
//  Created by Ivan Sinitsa on 04.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SlideShowButtonView : UIView {

    
}

@property (nonatomic, assign) BOOL isSlideShowStarted;
@property (nonatomic, retain) UIButton *playButton;
@property (nonatomic, assign) id delegate;

@end
