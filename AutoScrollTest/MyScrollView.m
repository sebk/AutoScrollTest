//
//  MyScrollView.m
//  AutoScrollTest
//
//  Created by Sebastian on 11.09.12.
//  Copyright (c) 2012 Sebastian. All rights reserved.
//

#import "MyScrollView.h"
#import "SmallView.h"

@implementation MyScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView* result = [super hitTest:point withEvent:event];

    if (result && [result isKindOfClass:[SmallView class]]) {
        self.canCancelContentTouches = NO;
        self.delaysContentTouches = NO;
        self.scrollEnabled = NO;
    }
    else {
        self.canCancelContentTouches = YES; 
        self.delaysContentTouches = YES; 
        self.scrollEnabled = YES;
    }
    return result;
    
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    if ([view isKindOfClass:[SmallView class]]) {
        return YES;
    }
    else {
    }
    return [super touchesShouldBegin:touches withEvent:event inContentView:self];
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isKindOfClass:[SmallView class]])  {
        return NO;
    }
    return [super touchesShouldCancelInContentView:self];
}


@end
