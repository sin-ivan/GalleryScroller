//
//  TKScrollViewController.m
//  Berlingske
//
//  Created by Taras Kalapun on 09.07.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import "TKScrollViewController.h"
#import "UIUtils.h"
#import "SlideShowButtonView.h"

//#import <objc/message.h>

@interface TKScrollViewController ()

- (void)fullScreenImageLoaded:(NSNotification *)note;
- (void)fadeInDecriptionView;
- (void)fadeOutDecriptionView;

@end 

@implementation TKScrollViewController

@synthesize pageWidth, pagePadding, loadingView;
@synthesize pagingScrollView, pageControlView, scrolledToRight, moreVisiblePages;
@synthesize recycledPages = recycledPages_, visiblePages = visiblePages_, buttonView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */
/*
- (id)init {
	if (self = [super init]) {
		// Custom initialization
		updateOnStart = YES;
	}
	return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect barFrame = self.view.frame;
    barFrame.origin.y = 20.0;
    barFrame.size.height = 44.0;
    
    navBar = [[UIToolbar alloc] initWithFrame:barFrame];
    navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    navBar.barStyle = UIBarStyleBlackTranslucent;
    //navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIBarButtonItem *navBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self action:@selector(close:)];
    
    navBar.items = [NSArray arrayWithObject:navBtn];
    [navBtn release];
    
    navBar.userInteractionEnabled = YES;
    navBar.alpha = 1.0;
    [self.view addSubview:navBar];
    
 
    CGRect descrFrame = CGRectMake(0, 0, 300, 100);
    self.buttonView = [[[SlideShowButtonView alloc] initWithFrame:descrFrame] autorelease];   
    self.buttonView.center = CGPointMake(self.view.frame.size.width / 2, (self.view.frame.size.height - descrFrame.size.height / 2));
    self.buttonView.delegate = self;
    [self.view addSubview:self.buttonView];

    [[NSNotificationCenter defaultCenter] addObserverForName:kNFullScreenImageLoaded object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self fullScreenImageLoaded:[note object]];
    }];    
    
    // Make the outer paging scroll view
    //CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    //self.pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
    self.pagingScrollView.pagingEnabled = YES;
    //self.pagingScrollView.backgroundColor = [UIColor blackColor];
    self.pagingScrollView.directionalLockEnabled = YES;
    self.pagingScrollView.showsVerticalScrollIndicator = NO;
    self.pagingScrollView.showsHorizontalScrollIndicator = NO;
    
    [self.pagingScrollView setNeedsLayout];
    
    
    
    //CGFloat pw = self.pagingScrollView.frame.size.width;
    //NSLog(@"pw = %d",pw)
    
    self.pagingScrollView.delegate = self;
    //self.view = pagingScrollView;
    
    // Prepare to tile content
    self.recycledPages = [NSMutableSet set];
    self.visiblePages  = [NSMutableSet set];
   
	if (!disableUpdateOnStart)
		[self updatePages];
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    isRotating = YES;
    
    if (UIDeviceOrientationIsPortrait(toInterfaceOrientation)) {
        [UIApplication sharedApplication].statusBarHidden = NO;
    } else if(UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    
    [self fadeOutDecriptionView];
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{
    isRotating = YES;
    
    for (id page in self.visiblePages) {
        NSUInteger pageIndex = [[page valueForKey:@"index"] intValue];
        CGRect pageFrame = [self frameForPageAtIndex:pageIndex];
        
        //NSLog(@"rotating: pageIndex: %d, pageFrame = %@", pageIndex, NSStringFromCGRect(pageFrame));
        
        UIView *pageView = ([page isKindOfClass:[UIViewController class]]) ? [page view] : page;
        pageView.frame = pageFrame;
    }
    
    CGRect currentPageFrame = [self frameForPageAtIndex:currentPageNumber];   	
    self.pagingScrollView.contentOffset = CGPointMake(currentPageFrame.origin.x, self.pagingScrollView.contentOffset.y);
          
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    isRotating = NO;
    [self scrollToPage:currentPageNumber animated:NO];
    
    CGRect rect = CGRectZero;      
    
     
    if ([UIUtils isPortrait]) {
        rect = CGRectMake(0, 0, 768, 1024);
    } else if([UIUtils isLandscape]) {
        rect = CGRectMake(0, 0, 1024, 768);
    }
    NSLog(@"rect %@", NSStringFromCGRect(rect));
    
    self.buttonView.center = CGPointMake(rect.size.width / 2, (rect.size.height - self.buttonView.frame.size.height / 2));
    [self fadeInDecriptionView];
}

- (void)fadeInDecriptionView {
    [UIView animateWithDuration:0.2 
                     animations:^ { 
                         self.buttonView.alpha = 1;
                     }
                     completion:^ (BOOL finished) {                         
                     }];
}

- (void)fadeOutDecriptionView {
    [UIView animateWithDuration:0.2 
                     animations:^ { 
                         self.buttonView.alpha = 0;
                     }
                     completion:^ (BOOL finished) {                         
                     }];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.pagingScrollView = nil;
    self.pageControlView = nil;
    
    self.recycledPages = nil;
    self.visiblePages = nil;
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.recycledPages = nil;
    self.visiblePages = nil;
    self.buttonView = nil;    
    
    [pagingScrollView release];
    [pageControlView release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Tiling and page configuration

- (void)close:(id)sender
{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)updatePages
{   
    NSLog(@"update pages");
    [self updatePages: YES];
}

- (void)updatePages: (BOOL) scrollToRoot {
	isPagesUpdated = YES;
	
    pageCount = NSNotFound;
    
    [self.visiblePages removeAllObjects];
    [self.recycledPages removeAllObjects];
    
    for (UIView *v in self.pagingScrollView.subviews) {
        [v removeFromSuperview];
    }
    
    if (self.pageWidth > 0) {
        self.pagingScrollView.contentSize = CGSizeMake(self.pageWidth * [self pageCount],
                                                       self.pagingScrollView.frame.size.height);
    } else {
        self.pagingScrollView.contentSize = CGSizeMake(
													   self.pagingScrollView.frame.size.width * [self pageCount], //+ self.pagePadding * [self pageCount],
													   self.pagingScrollView.frame.size.height);
    }
    
    [self tilePages];
    self.pageControlView.numberOfPages = [self viewsCount];
    self.pageControlView.currentPage = currentPageNumber;
    if (([self pageCount] > 0) && scrollToRoot) [self scrollToPage:currentPageNumber];
	
}

- (void)scrollToPageObject:(id)page
{
	for(int i=0; i<[self pageCount]; ++i) {
		if([[self pageAtIndex:i] isEqual:page]) {
			self.pageControlView.currentPage = i;
			break;
		}
	}
}

- (void)tilePages 
{
    NSLog(@"tilePages");
        
    if ([self pageCount] < 1) return;
    
    // Calculate which pages are visible
    CGRect visibleBounds = pagingScrollView.bounds;
	    
    int firstNeededPageIndex, lastNeededPageIndex;
    
    if (self.pageWidth > 0) {
        NSLog(@"page width %d", pageWidth);
        firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / self.pageWidth);
        lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / self.pageWidth);
    } else {
        firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / visibleBounds.size.width);
        lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / visibleBounds.size.width);        
    }
    
    if (self.moreVisiblePages) {
        // Added -1 and +1 for more smoothing
        // TODO: think about memory
        firstNeededPageIndex = MAX(firstNeededPageIndex-1, 0);
        lastNeededPageIndex  = MIN(lastNeededPageIndex+1, [self pageCount] - 1);
    } else {
        firstNeededPageIndex = MAX(firstNeededPageIndex-1, 0);
        lastNeededPageIndex  = MIN(lastNeededPageIndex+1, [self pageCount] - 1);
    }
    
    // Recycle no-longer-visible pages 
    for (id page in self.visiblePages) {
        NSUInteger pageIndex = [[page valueForKey:@"index"] intValue];
        if (pageIndex < firstNeededPageIndex || pageIndex > lastNeededPageIndex) {
            [self.recycledPages addObject:page];
            
            UIView *pageView = ([page isKindOfClass:[UIViewController class]]) ? [page view] : page;
            [pageView removeFromSuperview];            
        }        
    }
    
    [self.visiblePages minusSet:self.recycledPages];
    
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        //NSLog(@"index in cycle %d", index);
        if (![self isDisplayingPageForIndex:index]) {            
            
            id page = [self pageAtIndex:index];
			//NSLog(@"SVC tiled page %d", index);
			if (page) {
				[page setValue:[NSNumber numberWithInt:index] forKey:@"index"];
				//objc_msgSend(page, @selector(setIndex:), index); // Cool way !!!

				CGRect pageFrame = [self frameForPageAtIndex:index];
				//pageFrame.origin.x -= self.pagePadding*index*2 - self.pagePadding;
				if (self.pagePadding > 0) {
					; //NSLog(@"tiling %d, pageFrame = %@", index, NSStringFromCGRect(pageFrame));
				}
				
				UIView *pageView = ([page isKindOfClass:[UIViewController class]]) ? [page view] : page;
				pageView.frame = pageFrame;
				[pagingScrollView addSubview:pageView];
				
				[self.visiblePages addObject:page];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"redrawImage" object:nil];
                
			}
        }
    }      
}

- (id)dequeueRecycledPage
{
    id page = [self.recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [self.recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (id page in self.visiblePages) {
        NSUInteger pageIndex = [[page valueForKey:@"index"] intValue];
        if (pageIndex == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void)fullScreenImageLoaded:(NSNotification *)note {
      
}



#pragma mark -
#pragma mark ScrollView delegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"will begin dragging");
    if (isRotating) return;    
    previousX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"did scroll");

//    if (isRotating) return;
//        
//    self.scrolledToRight = (scrollView.contentOffset.x > previousX) ? YES : NO;
//    
//    //NSLog(@"scrolledToRight: %d", self.scrolledToRight);
//
//    [self tilePages];
//    currentPageNumber = [self currentViewIndex];
	//CGRect rect = [self frameForPageAtIndex:currentPageNumber];
	
	//NSLog(@"scroll page to: %d, rect: %@, pagingScrollView: %@, floaf %1.2f", currentPageNumber, NSStringFromCGRect(rect), NSStringFromCGRect(pagingScrollView.frame), rect.origin.x/rect.size.width);
    //[self removeLoadingView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"did end");
    
    if (isRotating) return;
    
    self.scrolledToRight = (scrollView.contentOffset.x > previousX) ? YES : NO;
    
    //NSLog(@"scrolledToRight: %d", self.scrolledToRight);
    
    [self tilePages];
    currentPageNumber = [self currentViewIndex];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setOriginalScrollViewZoom" object:nil];
    CGRect rect = [self frameForPageAtIndex:currentPageNumber];

    if (isRotating) 
	{
		if (self.pageWidth == 0) {
			[pagingScrollView scrollRectToVisible:rect animated:NO];
		} 
		
		return;
    }
    self.pageControlView.currentPage = [self currentViewIndex];
    currentPageNumber = [self currentViewIndex];
	//NSLog(@"scroll page to: %d, rect: %@, pagingScrollView: %@, floaf %1.2f", currentPageNumber, NSStringFromCGRect(rect), NSStringFromCGRect(pagingScrollView.frame), rect.origin.x/rect.size.width);

	//ArticleWebView *awv = [self pageForIndex:currentPageNumber];
	//if([awv isKindOfClass:[ArticleWebView class]]) {
	//	NSLog(@"SVC forced reload for page %@", awv);
	//	[awv updateWebView];
	//}
	

    /*
    for (id page in visiblePages) {
        if ([page isKindOfClass:[UIViewController class]]) {
            [(UIViewController*)page viewWillAppear:YES];
        }
    }
     */
}

#pragma mark -
#pragma mark  Frame calculations

- (CGRect)frameForPagingScrollView {
    
    if (self.pagePadding > 0) {
        //CGRect frame = [[UIScreen mainScreen] bounds];
        CGRect frame = self.pagingScrollView.frame;
        //frame.origin.x -= self.pagePadding;
        //frame.size.width += (2 * self.pagePadding);
        return frame;
    } else {
        return self.pagingScrollView.frame;
    }
    
    
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    //CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    
    CGRect pageFrame = [self frameForPagingScrollView];
    
    if (self.pageWidth > 0) {
		pageFrame.size.width = self.pageWidth;
    }
    //pageFrame.size.width -= (2 * self.pagePadding);
    
    //pageFrame.origin.x = ((pageFrame.size.width + (2 * self.pagePadding) ) * index);// + self.pagePadding;
    pageFrame.origin.x = pageFrame.size.width * index; //+ (2*self.pagePadding * index) + self.pagePadding;
    //pageFrame.origin.x = (pageFrame.size.width * index) + (2* self.pagePadding * index) - self.pagePadding;
    //pageFrame.size.width += (4*self.pagePadding);
    
    //hack :((( 
    //if ((self.pagePadding > 0) && (index == 0)) {
        //pageFrame.origin.x += self.pagePadding;
    //}
    
    pageFrame.origin.y = 0.0;
    return pageFrame;
}


#pragma mark -
#pragma mark Page wrangling

- (NSUInteger)pageCount {
    if (pageCount == NSNotFound) {
        pageCount = 0;
    }
    return pageCount;
}


- (NSUInteger)viewsCount
{
    if (self.pagingScrollView.frame.size.width == 0) return 0;
    if ([self pageCount] == 0) return 0;
    
    int pagesPerView = (self.pageWidth > 0) ? self.pagingScrollView.frame.size.width / self.pageWidth : 1;
    return [self pageCount] / pagesPerView;
}

- (NSUInteger)currentViewIndex
{
    CGFloat tmpPageWidth = self.pagingScrollView.frame.size.width;
    CGFloat tmpX = self.pagingScrollView.contentOffset.x;
     
    int viewIndex;
    
    if (self.pageWidth > 0) {
        viewIndex = floor(((tmpX + tmpPageWidth/4) - tmpPageWidth / 2) / tmpPageWidth) + 1;
    //} else if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
    //    viewIndex = floor(pagingScrollView.contentOffset.x / tmpPageWidth);
    } else {
        //viewIndex = floor((tmpX - tmpPageWidth / 2) / tmpPageWidth)+1;
        viewIndex = floor(tmpX / tmpPageWidth);
    }
    
    
    //int viewIndex = floor(pagingScrollView.contentOffset.x / tmpPageWidth);
    
    return viewIndex;
    
}

- (id)currentPage
{
    return [self pageForIndex:[self currentViewIndex]];
}

- (id)pageForIndex:(NSUInteger)index
{
    for (id page in self.visiblePages) {
        NSUInteger pageIndex = [[page valueForKey:@"index"] intValue];
        if (pageIndex == index) {
            return page;
        }
    }
    return nil;
}

- (void)scrollToPage:(NSUInteger)index
{
    //NSLog(@"scrolltopage");
    [self scrollToPage:index animated:YES];
}

- (void)scrollToPage:(NSUInteger)index animated:(BOOL)animated
{
	CGRect neededRect = [self frameForPageAtIndex:index];
    currentPageNumber = index;
    [pagingScrollView scrollRectToVisible:neededRect animated:animated];
}

- (id)dequeueReusablePageWithIdentifier:(NSString *)identifier
{
    for (id page in self.recycledPages) {
        if ([[page reuseIdentifier] isEqualToString:identifier]) {
            [[page retain] autorelease];
            [self.recycledPages removeObject:page];
            return page;
        }
    }

    return nil;
}

- (NSInteger)numberOfPages
{
    return 0;
}

- (id)pageAtIndex:(NSInteger)pageIndex
{
    return nil;
}

- (CGSize)sizeOfPageAtIndex:(NSInteger)pageIndex
{
    return CGSizeMake(0.0, 0.0);
}

#pragma mark -
#pragma mark Slideshow methods

- (void)startSlideShow {
    NSLog(@"start slideshow");
}

- (void)stopSlideShow {
    NSLog(@"stop slideshow");
}

- (void)nextImage {
    int pageToSelect = currentPageNumber + 1;
    if(pageToSelect <= [self pageCount]) {
        [self scrollToPage:pageToSelect];
        [self scrollViewDidEndDecelerating:self.pagingScrollView];
    }
}

- (void)previousImage {
    int pageToSelect = currentPageNumber - 1;
    if(pageToSelect >= 0) {
        [self scrollToPage:pageToSelect];
        [self scrollViewDidEndDecelerating:self.pagingScrollView];
    }
    
}

@end
