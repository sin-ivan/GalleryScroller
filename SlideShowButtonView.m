//
//  DescriptionView.m
//  iccoss
//
//  Created by Ivan Sinitsa on 04.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SlideShowButtonView.h"

static const float kCornerRadius = 7;

@interface SlideShowButtonView ()

- (void)startSlideShow;
- (void)nextImage;
- (void)previousImage;

@end

@implementation SlideShowButtonView

@synthesize playButton, isSlideShowStarted, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isSlideShowStarted = NO;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        self.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        self.layer.borderWidth = 2;
                      
        self.playButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)] autorelease];
        [self.playButton  setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
        [self.playButton  setImage:[UIImage imageNamed:@"slideshow_btn_Play.png"] forState:UIControlStateNormal];
        [self.playButton  setImage:[UIImage imageNamed:@"slideshow_btn_Play_Dis.png"] forState:UIControlStateHighlighted];
        [self.playButton  addTarget:self action:@selector(startSlideShow) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.playButton];
                
        UIButton *prevButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [prevButton setCenter:CGPointMake((self.frame.size.width / 2) - 80, self.frame.size.height / 2)];
        [prevButton setImage:[UIImage imageNamed:@"slideshow_btn_Prev.png"] forState:UIControlStateNormal];
        [prevButton setImage:[UIImage imageNamed:@"slideshow_btn_Prev_Dis.png"] forState:UIControlStateHighlighted];
        [prevButton addTarget:self action:@selector(previousImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:prevButton];
        [prevButton release];
        
        UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [nextButton setCenter:CGPointMake((self.frame.size.width / 2) + 80, self.frame.size.height / 2)];
        [nextButton setImage:[UIImage imageNamed:@"slideshow_btn_Next.png"] forState:UIControlStateNormal];
        [nextButton setImage:[UIImage imageNamed:@"slideshow_btn_Next_Dis.png"] forState:UIControlStateHighlighted];
        [nextButton addTarget:self action:@selector(nextImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextButton];
        [nextButton release];
                
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    self.playButton = nil;
    [super dealloc];
}


- (void)startSlideShow {
    if (!self.isSlideShowStarted) {
        [self.playButton  setImage:[UIImage imageNamed:@"slideshow_btn_Pause.png"] forState:UIControlStateNormal];
        [self.playButton  setImage:[UIImage imageNamed:@"slideshow_btn_Pause_Dis.png"] forState:UIControlStateHighlighted];
        self.isSlideShowStarted = YES;
        
        if([self.delegate respondsToSelector:@selector(startSlideShow)]) {
            [self.delegate performSelector:@selector(startSlideShow)];
        }
    } else {
        [self.playButton  setImage:[UIImage imageNamed:@"slideshow_btn_Play.png"] forState:UIControlStateNormal];
        [self.playButton  setImage:[UIImage imageNamed:@"slideshow_btn_Play_Dis.png"] forState:UIControlStateHighlighted];
        self.isSlideShowStarted = NO;
        
        if([self.delegate respondsToSelector:@selector(stopSlideShow)]) {
            [self.delegate performSelector:@selector(stopSlideShow)];
        }
    }
}

- (void)nextImage {
    if([self.delegate respondsToSelector:@selector(nextImage)]) {
        [self.delegate performSelector:@selector(nextImage)];
    }
}

- (void)previousImage {
    if([self.delegate respondsToSelector:@selector(previousImage)]) {
        [self.delegate performSelector:@selector(previousImage)];
    }
}

@end
