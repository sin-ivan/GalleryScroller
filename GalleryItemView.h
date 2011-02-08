//
//  GalleryItemView.h
//  Berlingske
//
//  Created by Taras Kalapun on 11.10.10.
//  Copyright (c) 2010 Ciklum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKScrollViewPage.h"

@class GalleryItemView, TKImageView, TKZoomScrollView, DataLoadingView;

@protocol GalleryItemDelegate <NSObject>

@optional
- (void)galleryItemCloseAction;
- (void)galleryItemShowControlsAction;
- (void)galleryItemHideControlsAction;
@end

@interface GalleryItemView : TKScrollViewPage 
<UIScrollViewDelegate>
{
    
    TKImageView *tkImageView;
    //UIView *descriptionView;
    UILabel *authorLabel;
    //UILabel *captionLabel;
      
    BOOL isShowingControls;
    
    id <GalleryItemDelegate> delegate;
}

@property (nonatomic, assign) int isControlsHidden;
@property (nonatomic, retain) NSString *caption;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *photoUrl;
@property (nonatomic, retain) NSString *photoUUID;
@property (nonatomic, assign) id <GalleryItemDelegate> delegate;
@property (nonatomic, retain) TKZoomScrollView *scrollView;


- (void)redrawImages;
- (void)rotateToOrientation;


@end
