//
//  ViewController.m
//  AutoScrollTest
//
//  Created by Sebastian on 11.09.12.
//  Copyright (c) 2012 Sebastian. All rights reserved.
//

#import "ViewController.h"
#import "ContainerViewController.h"
#import "MyScrollView.h"

@interface ViewController ()

@end


@implementation ViewController

@synthesize scrollView = _scrollView;
@synthesize containerView = _containerView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.containerView = [[ContainerViewController alloc] initWithNibName:@"ContainerViewController" bundle:nil];
    [self.scrollView addSubview:_containerView.view];
    
    _scrollView.minimumZoomScale = 1.0f;
    _scrollView.maximumZoomScale = 5.0f;
    
    [_scrollView setContentSize:self.view.bounds.size];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setScrollView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UIScrollView Delegate

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _containerView.view;
}


@end
