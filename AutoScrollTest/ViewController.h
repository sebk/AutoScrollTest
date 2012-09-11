//
//  ViewController.h
//  AutoScrollTest
//
//  Created by Sebastian on 11.09.12.
//  Copyright (c) 2012 Sebastian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContainerViewController;
@class MyScrollView;

@interface ViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet MyScrollView *scrollView;

@property (strong, nonatomic) ContainerViewController *containerView;

@end
