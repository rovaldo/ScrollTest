//
//  TTViewController.m
//  Touch
//
//  Created by LI Admin on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTViewController.h"
#import "TTPageViewController.h"

#define NUM_PAGES 10


@interface TTViewController ()

@property (nonatomic, retain) NSMutableArray *newsPages;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *controllers;
@property (nonatomic) NSInteger currentPageNumber;
@property (nonatomic) BOOL userScrolling;

- (void)loadPageInScrollViewWithIndex:(NSInteger)index;
@end

@implementation TTViewController

@synthesize newsPages=_newsPages;
@synthesize scrollView=_scrollView;
@synthesize controllers=_controllers;
@synthesize currentPageNumber=_currentPageNumber;
@synthesize userScrolling=_userScrolling;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)loadPageInScrollViewWithIndex:(NSInteger)index {
  if (index < 0 || index >= NUM_PAGES) {return;}
  NSLog(@"%d index", index);
  TTPageViewController *controller = [self.controllers objectAtIndex:index];
  if ((NSNull *)controller == [NSNull null]) {
    TTPageViewController *controller = [[TTPageViewController alloc] init];
    [self.controllers replaceObjectAtIndex:index withObject:controller];
    [controller release];
  }
  
  controller = [self.controllers objectAtIndex:index];
  if (controller.view.superview == nil)
  {
    CGRect frame = controller.view.frame;
    frame.origin.x = self.scrollView.frame.size.width * index;
    frame.origin.y = 0;
    controller.view.frame = frame;
    [self.scrollView addSubview:controller.view];
    
    controller.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    [controller.view addSubview:text];
    text.text=[NSString stringWithFormat:@"%d", index];
  }

}

- (void)setCurrentPageNumber:(NSInteger)currentPageNumber {
  if (currentPageNumber < NUM_PAGES) {
    _currentPageNumber = currentPageNumber;
    self.userScrolling = NO;
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGRect newFrame = CGRectMake(currentPageNumber * pageWidth, 0, pageWidth, self.scrollView.frame.size.height);
    [self.scrollView scrollRectToVisible:newFrame animated:YES];
    [self loadPageInScrollViewWithIndex:currentPageNumber - 1];
    [self loadPageInScrollViewWithIndex:currentPageNumber];
    [self loadPageInScrollViewWithIndex:currentPageNumber + 1];
  }
}
#pragma mark - Scrollview Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (!self.userScrolling) {
    return;
  }
  CGFloat pageWidth = scrollView.frame.size.width;
  int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
  [self loadPageInScrollViewWithIndex:page - 1];
  [self loadPageInScrollViewWithIndex:page];
  [self loadPageInScrollViewWithIndex:page + 1];
  // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  self.userScrolling = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  CGFloat pageWidth = scrollView.frame.size.width;
  int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
  
  self.currentPageNumber = page;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
  self.newsPages = [[NSMutableArray alloc] init];
  
  NSMutableArray *controllers = [[NSMutableArray alloc] init];
  for (unsigned i = 0; i < NUM_PAGES; i++)
  {
		[controllers addObject:[NSNull null]];
  }
  self.controllers = controllers;
  [controllers release];
  
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  scrollView.pagingEnabled = YES;
  scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * NUM_PAGES, scrollView.frame.size.height);
  scrollView.showsHorizontalScrollIndicator = NO;
  scrollView.showsVerticalScrollIndicator = NO;
  scrollView.scrollsToTop = NO;
  scrollView.delegate = self;
  scrollView.backgroundColor = [UIColor purpleColor];
  self.scrollView = scrollView;
  [self.view addSubview:scrollView];
  [scrollView release];
  
  [self loadPageInScrollViewWithIndex:0];
  [self loadPageInScrollViewWithIndex:1];
  
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_leather_tall_contrast.png"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
