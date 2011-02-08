//
//  GalleryItemView.m
//  Berlingske
//
//  Created by Taras Kalapun on 11.10.10.
//  Copyright (c) 2010 Ciklum. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GalleryItemView.h"
#import "TKImageView.h"
#import "TKZoomScrollView.h"
#import "ImageCache.h"
#import "DataLoadingView.h"

#import "UILabel+recalculateFrame.h"

@implementation GalleryItemView

@synthesize scrollView, caption, author, photoUrl, delegate, photoUUID, isControlsHidden = isControlHidden_;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {

        // Initialization code        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redrawImages) name:@"redrawImage" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setZoomToOriginal) name:@"setOriginalScrollViewZoom" object:nil];
              
        tkImageView = [[TKImageView alloc] initWithFrame:frame];
        tkImageView.contentMode = UIViewContentModeScaleAspectFit; //UIViewContentModeCenter;
        tkImageView.backgroundColor = [UIColor blackColor];
        //[tkImageView addTarget:self action:@selector(showImageControls:)];
              
        self.scrollView = [[[TKZoomScrollView alloc] initWithFrame:frame] autorelease];        
        self.scrollView.delegate = self;
        self.scrollView.backgroundColor = [UIColor blackColor];
        [self.scrollView addSubview:tkImageView];  
        [self addSubview:self.scrollView];             
        
    }
    return self;
}

- (void)dealloc {
    
    [tkImageView release];
    [authorLabel release];
    
    
    self.scrollView = nil;
    self.caption = nil;
    self.author = nil;
    self.photoUrl = nil;
    self.photoUUID = nil;
    
    [super dealloc];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
     
    [self.scrollView setFrame:frame];
    [self.scrollView setContentSize:frame.size];
    [self.scrollView setCenter:CGPointMake(frame.size.width / 2, frame.size.height / 2)];

}

- (void)redrawImages {
       
    NSLog(@"redraw");
    //CGRect lRect;
   
    tkImageView.image = [UIImage imageNamed:@"Icon.png"];
    
    ImageCache *ic = [ImageCache sharedImageCache];
    NSString *photoFilename = [self.photoUUID stringByAppendingString:@".jpg"];
    
    if ([ic hasImageWithName:photoFilename size:ICImageSizeFullScreen]) {
        
        
        
        tkImageView.image = [ic imageWithName:photoFilename size:ICImageSizeFullScreen];
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"hideLoadingView" object:nil];
       
    } else {
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"showLoadingView" object:nil];
        tkImageView.image = [UIImage imageNamed:@"Icon.png"];
        
        NSDictionary *cp = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInt:self.index], @"itemIndex", 
                            @"Gallery", @"tableName", 
                            self.photoUrl, @"url",
                            nil];
        
        [ic loadImageNamed:self.photoUUID size:ICImageSizeFullScreen withCustomProperties:cp];            
    }
//    lRect = CGRectMake(10.0, 10.0, 217.0, 150.0);
//    captionLabel.frame = lRect;
//    captionLabel.text = self.caption;
//    [captionLabel recalculateFrame];
//    lRect = captionLabel.frame;
//    lRect.size.width = 217.0;
//    captionLabel.frame = lRect;
//    
//    lRect = CGRectMake(50.0, 160.0, 180.0, 20.0);
//    authorLabel.frame = lRect;
//    authorLabel.text = self.author;
//    [authorLabel recalculateFrame];
//    lRect = authorLabel.frame;
//    lRect.origin.x = 220.0 - lRect.size.width;
//    authorLabel.frame = lRect;
       
}

- (void)setZoomToOriginal {
    //NSLog(@"setZoomToOriginal");
    //[self redrawImages];
    self.scrollView.zoomScale = 1;    
}

- (void)rotateToOrientation {
    [self.scrollView setFrame:self.frame];
    [self.scrollView setZoomScale:1.0f];
}

#pragma mark -
#pragma mark UIScrollView delegate methods

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollview {
    //NSLog(@"viewForZoomingInScrollView");
    return tkImageView;
}


@end
