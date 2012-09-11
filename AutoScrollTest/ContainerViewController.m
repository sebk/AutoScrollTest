//
//  ContainerViewController.m
//  AutoScrollTest
//
//  Created by Sebastian on 11.09.12.
//  Copyright (c) 2012 Sebastian. All rights reserved.
//

#import "ContainerViewController.h"
#import "SmallView.h"
#import "MyScrollView.h"

@interface ContainerViewController ()

@property(nonatomic, strong) NSTimer *scrollTimer;

@end


@implementation ContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view.superview setClipsToBounds:YES];
    
    
    SmallView *mySmallView = [[SmallView alloc]initWithFrame:CGRectMake(20, 20, 50, 50)];
    mySmallView.backgroundColor = [UIColor redColor];
    mySmallView.alpha = 0.7f;
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [mySmallView addGestureRecognizer:recognizer];
    
    [self.view addSubview:mySmallView];
}


- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state)
    {
        case UIGestureRecognizerStatePossible:
        {
            break;
        }
        case UIGestureRecognizerStateBegan:
        {
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [recognizer translationInView:self.view];
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                                recognizer.view.center.y + translation.y);
            [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
            
           
            MyScrollView *scrollView = (MyScrollView*)self.view.superview;
            
            CGRect visibleRect;
            visibleRect.origin = scrollView.contentOffset;
            visibleRect.size = scrollView.bounds.size;
            
            CGRect frame = recognizer.view.frame;
            
            CGFloat scale = 1.0 / scrollView.zoomScale;
            visibleRect.origin.x *= scale;
            visibleRect.origin.y *= scale;
            visibleRect.size.width *= scale;
            visibleRect.size.height *= scale;
            
            
            /*
             Thanks to MyMattes from OS X Entwicklerforum (http://www.osxentwicklerforum.de/index.php?page=Thread&postID=185021) for
             the complete following part and the autoScroll: Implementation.
             */
            CGSize scrollZone = CGSizeMake(10.0f, 10.0f); //start scrolling when SmallView is out of x or y pixels
            float scrollStep = 3.0f;
            CGPoint scrollAmount = CGPointZero;
            
            //determine the change of x and y
            if (frame.origin.x+scrollZone.width < visibleRect.origin.x) {
                scrollAmount.x = -scrollStep;
            }
            else if((frame.origin.x+frame.size.width)-scrollZone.width > visibleRect.origin.x + visibleRect.size.width) {
                scrollAmount.x = scrollStep;
            }
            else if (frame.origin.y+scrollZone.height < visibleRect.origin.y) {
                scrollAmount.y = -scrollStep;
            }
            else if((frame.origin.y+frame.size.height)-scrollZone.height > visibleRect.origin.y + visibleRect.size.height) {
                scrollAmount.y = scrollStep;
            }

            //SmallView is out of the visibleArea: start the NSTimer for scrolling
            if ((scrollAmount.x != 0) | (scrollAmount.y != 0)) {
                if (![_scrollTimer isValid]) {
                    [_scrollTimer invalidate];
                    _scrollTimer = nil;
                    
                    NSString *scrollString = NSStringFromCGPoint(scrollAmount);
                    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:scrollString, @"scrollString", recognizer.view, @"currentView", nil];
                    
                    _scrollTimer = [[NSTimer alloc]initWithFireDate:[NSDate date] interval:0.03f target:self selector:@selector(autoScroll:) userInfo:info repeats:YES];
                    [[NSRunLoop mainRunLoop] addTimer:_scrollTimer forMode:NSRunLoopCommonModes];
                }
            }
            //SmallView is not out of the visible Area: stop the NSTimer
            else {
                [_scrollTimer invalidate];
                _scrollTimer = nil;
            }
            
                      break;
        }
        case UIGestureRecognizerStateEnded:
        {
            //quite know the scrolling should stop, maybe it would be better when the scrollView scrolls even if the user does nothing when the subview is over the visible area
            [_scrollTimer invalidate];
            _scrollTimer = nil;
            break;
        }
        default:
        {
            [_scrollTimer invalidate];
            _scrollTimer = nil;
            break;
        }
    }
}



-(void)autoScroll:(NSTimer*)timer {
    
    NSDictionary *info = [timer userInfo];
    
    MyScrollView *scrollView = (MyScrollView*)self.view.superview;
    CGRect visibleRect;
    visibleRect.origin = scrollView.contentOffset;
    visibleRect.size = scrollView.bounds.size;
    
    CGPoint scrollAmount = CGPointFromString([info objectForKey:@"scrollString"]);
    SmallView *currentView = [info objectForKey:@"currentView"];
    
    //stop scrolling when the UIView is at the edge of the containerView (referenced over 'self')
    if ((currentView.frame.origin.x <= 0 | currentView.frame.origin.y <= 0) ||
        ((currentView.frame.origin.x+currentView.frame.size.width) > self.view.frame.size.width | (currentView.frame.origin.y+currentView.frame.size.height) > self.view.frame.size.height)
        ) {
        return;
    }
    
    //move the UIView
    CGFloat scale = 1.0 / scrollView.zoomScale;
    if (scrollAmount.x != 0) {
        scrollAmount.x *= scale;
    }
    if (scrollAmount.y != 0) {
        scrollAmount.y *= scale;
    }
    CGRect frame = currentView.frame;
    frame.origin.x += scrollAmount.x;
    frame.origin.y += scrollAmount.y;
    currentView.frame = frame;
    
    //move the scrollView
    CGPoint contentOffset = scrollView.contentOffset;
    contentOffset.x += scrollAmount.x;
    contentOffset.y += scrollAmount.y;
    [scrollView setContentOffset:contentOffset animated:NO];
}


- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
