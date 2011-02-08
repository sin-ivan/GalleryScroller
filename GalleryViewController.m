//
//  GalleryViewController.m
//  Berlingske
//
//  Created by Taras Kalapun on 27.09.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "GalleryViewController.h"
#import "Picture.h"
#import "DataLoadingView.h"
#import "SlideShowButtonView.h"

@interface GalleryViewController ()

- (void)updatePageAtIndex:(NSInteger)pageIndex;
- (void)hideImageControls;
- (void)showImageControls;

@end

@implementation GalleryViewController

@synthesize photos = photos_, pageScrolled;


- (id)init {
    self = [super init];
    if (self) {

        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOrHideItemViewControls) name:@"showOrHideItemViewControls" object:nil];
       //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoadingView) name:@"showLoadingView" object:nil];
       //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLoadingView) name:@"hideLoadingView" object:nil];
        self.pageScrolled = NO;
    }
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [navBar release];
    [photos_ release], photos_ = nil;
        
    [super dealloc];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
   
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.wantsFullScreenLayout = YES;
    
    CGRect vf = [UIScreen mainScreen].applicationFrame;
    //vf.origin.y = 0.0;
    //vf.size.height += 20;
    
    UIView *v = [[UIView alloc] initWithFrame:vf];
    v.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = v;
    [v release];
    
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.view.frame];
    sv.backgroundColor = [UIColor blackColor];
    sv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.pagingScrollView = sv;
    [sv release];
    [self.view addSubview:self.pagingScrollView];
      
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tilePages];
    //[self showImageControls:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{
    isRotating = YES;
    
    [self relocateComponentsToOrientation:toInterfaceOrientation];
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    
}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    //[self tilePages];
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma UIScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   
    if (!self.pageScrolled) {
        
        [self tilePages];
        self.pageScrolled = YES;
    }
          
    [super scrollViewDidScroll:scrollView];   
    
    for (GalleryItemView *page in self.visiblePages) {
        page.isControlsHidden = (int)navBar.alpha;
    } 
     
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [super scrollViewDidEndDecelerating:scrollView];
    self.pageScrolled = YES;
}

//- (void) showLoadingView {
//    [DataLoadingView showLoadingViewInView:self.view];
//}
//
//- (void) hideLoadingView {
//    [DataLoadingView removeLoadingView];
//}

#pragma mark -
#pragma mark Hide/show controls methods

- (void)showImageControls
{    
    [UIApplication sharedApplication].statusBarHidden = NO;    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    navBar.userInteractionEnabled = YES;
    navBar.alpha = 1.0;
    self.buttonView.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)hideImageControls
{
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    navBar.userInteractionEnabled = NO;
    navBar.alpha = 0.0f;
    self.buttonView.alpha = 0.0;
    [UIView commitAnimations];
}

- (void) showOrHideItemViewControls {
    if (navBar.alpha == 1) {
        [self hideImageControls];
    } else {
        [self showImageControls];
    }
}


#pragma mark -
#pragma mark Managing pages methods

- (void)fullScreenImageLoaded:(NSNumber *)note {  
        
    NSLog(@"full screen image loaded");
    [self updatePageAtIndex:[note intValue]];    
}

- (void)updatePageAtIndex:(NSInteger)pageIndex {
    NSLog(@"update page");
    id page = [self pageForIndex:pageIndex];
    [page redrawImages];    
}

- (id)pageAtIndex:(NSInteger)pageIndex {
    static NSString *PageIdentifier = @"GalleryItem";
    
    GalleryItemView *page = (id)[self dequeueReusablePageWithIdentifier:PageIdentifier];
    if (page == nil) {
        page = [[[GalleryItemView alloc] initWithFrame:self.view.frame] autorelease];
        page.reuseIdentifier = PageIdentifier;
        page.delegate = self;
    }
    
    Picture *picture = [self.photos objectAtIndex:pageIndex];	
    page.caption  = picture.title;
    page.author  = picture.tags;
    page.photoUrl = picture.url;
    page.photoUUID = picture.uuid;
    NSLog(@"page at index set alpha %f", navBar.alpha );
    page.isControlsHidden = (int)navBar.alpha;
  
    return page;
}

- (void)relocateComponentsToOrientation:(UIInterfaceOrientation)orientation
{
    
    self.pagingScrollView.contentSize = CGSizeMake(
                                                   (self.pagingScrollView.frame.size.width * [self pageCount]),
      
                                                   self.pagingScrollView.frame.size.height); 
    
    GalleryItemView *page = [self pageForIndex:currentPageNumber];
    [page rotateToOrientation];
    
}

- (NSUInteger)pageCount {
    if (pageCount == NSNotFound) {      
        pageCount = [self.photos count];
    }
    return pageCount;
}

@end
