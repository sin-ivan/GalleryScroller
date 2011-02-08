//
//  TKScrollViewController.h
//  Berlingske
//
//  Created by Taras Kalapun on 09.07.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCache.h"

@class TKScrollViewPage, DataLoadingView, SlideShowButtonView;

@protocol TKScrollViewDelegate;
@protocol TKScrollViewDataSource;

@interface TKScrollViewController : UIViewController 
    <UIScrollViewDelegate>
{
    UIScrollView *pagingScrollView;
    UIPageControl *pageControlView;
    
    NSUInteger pageWidth;
    NSUInteger pagePadding;
    
    NSUInteger currentPageNumber;
    
    NSUInteger pageCount;
    
    BOOL scrolledToRight;
    CGFloat previousX;
    
    BOOL moreVisiblePages;
    BOOL isRotating;
	BOOL disableUpdateOnStart;
	BOOL isPagesUpdated;
    UIToolbar *navBar;

}

@property (assign) NSUInteger pageWidth;
@property (assign) NSUInteger pagePadding;
@property (assign) BOOL scrolledToRight;
@property (assign) BOOL moreVisiblePages;
@property (nonatomic, retain) IBOutlet UIScrollView *pagingScrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControlView;

@property (nonatomic, retain) NSMutableSet *recycledPages;
@property (nonatomic, retain) NSMutableSet *visiblePages;
@property (nonatomic, retain) DataLoadingView *loadingView;
@property (nonatomic, retain) SlideShowButtonView *buttonView;


- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;

- (void)updatePages: (BOOL) scrollToRoot;
- (void)updatePages;
- (void)tilePages;
- (id)dequeueRecycledPage;

- (NSUInteger)pageCount;
- (NSUInteger)viewsCount;
- (NSUInteger)currentViewIndex;

- (id)currentPage;
- (id)pageForIndex:(NSUInteger)index;
- (void)scrollToPage:(NSUInteger)index;
- (void)scrollToPage:(NSUInteger)index animated:(BOOL)animated;

- (id)dequeueReusablePageWithIdentifier:(NSString *)identifier;

- (NSInteger)numberOfPages;
- (id)pageAtIndex:(NSInteger)pageIndex;
- (CGSize)sizeOfPageAtIndex:(NSInteger)pageIndex;
- (void)scrollToPageObject:(id)page;

//slide show methods
- (void)startSlideShow;
- (void)stopSlideShow;
- (void)nextImage;
- (void)previousImage;

@end

/*
@protocol TKScrollViewDataSource <NSObject>
- (NSInteger)numberOfPagesInScrollView:(TKScrollViewController *)scrollView;
- (TKScrollViewPage *)scrollView:(TKScrollViewController *)scrollView pageAtIndex:(NSInteger)pageIndex;
@optional
- (CGSize)scrollView:(TKScrollViewController *)scrollView sizeOfPageAtIndex:(NSInteger)pageIndex;
@end


@protocol TKScrollViewDelegate <NSObject>
@optional
- (void)scrollView:(TKScrollViewController *)scrollView didMoveToPageAtIndex:(NSInteger)pageIndex;
@end
*/

