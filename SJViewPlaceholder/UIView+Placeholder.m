//
//  UIView+Placeholder.m
//  IWUIPlaceholder
//
//  Created by Sheng on 12/10/2016.
//  Copyright © 2016 Jiang Sheng. All rights reserved.
//

#import "UIView+Placeholder.h"
#import <objc/runtime.h>

#define kIWPlaceholderLineWidth 10.0f
#define kIWPlaceholderSpacing 10.0f
#define kIWPlaceholderMargin 12.0f

@implementation UIView (Placeholder)
@dynamic hideBlock;

- (void)setHideBlock:(void (^)(BOOL))hideBlock {
    objc_setAssociatedObject(self, @selector(hideBlock), hideBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(BOOL))hideBlock {
    return objc_getAssociatedObject(self, @selector(hideBlock));
}

#pragma mark - Public

- (void)showPlaceholder {
#ifdef DEBUG
//    self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.01 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
#endif
    UIColor* darkColor = [UIColor colorWithRed: 0.376 green: 0.325 blue: 0.373 alpha: 1];
    UIColor* normalColor = [UIColor colorWithRed: 0.541 green: 0.518 blue: 0.541 alpha: 1];
    UIColor* lightColor = [UIColor colorWithRed: 0.902 green: 0.894 blue: 0.898 alpha: 1];
    UIColor* veryLightColor = [UIColor colorWithRed: 0.945 green: 0.941 blue: 0.937 alpha: 1];
    
    CGRect frame = self.frame;
    
    BOOL userInteractionEnabled = self.userInteractionEnabled;
    self.userInteractionEnabled = NO;
    
    __block UIView *overlay = [[UIView alloc] initWithFrame:self.bounds];
    // Get visible background color to cover on current view to made content invisible
    UIColor *bgcolor = self.backgroundColor;
    UIView *view = self;
    while (bgcolor == nil) {
        view = [view superview];
        bgcolor = view.backgroundColor;
    }
    overlay.backgroundColor = bgcolor;
    
    // Choose color mode
    UIColor *color = self.backgroundColor;
    CGFloat grayscale;
    CGFloat alpha;
    BOOL converted = [color getWhite:&grayscale alpha:&alpha];
    BOOL darkMode = NO;
    if (converted)
        darkMode = grayscale > 0.5 ? YES : NO;
    
    NSUInteger row = CGRectGetHeight(frame) / (kIWPlaceholderSpacing + kIWPlaceholderLineWidth);
    NSUInteger start = 1;
    for (NSUInteger i = start; i <= row; i++) {
        UIColor *color = nil;
        if (i == start)
            color = (darkMode) ? normalColor : lightColor;
        else
            color = (darkMode) ? darkColor : veryLightColor;
        
        // Draw
        CGFloat offsetY = (kIWPlaceholderSpacing + kIWPlaceholderLineWidth) * i;
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(kIWPlaceholderMargin,
                                             offsetY - kIWPlaceholderLineWidth)];
        NSUInteger adjustmentWidth =  (i % 5 > 2) ? (CGRectGetWidth(frame) / 3.0) : 0 ;
        [bezierPath addLineToPoint: CGPointMake(CGRectGetWidth(frame) - kIWPlaceholderMargin * 2 - adjustmentWidth,
                                                offsetY - kIWPlaceholderLineWidth)];
        [bezierPath closePath];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = bezierPath.CGPath;
        layer.lineCap = kCALineCapRound;
        layer.lineJoin = kCALineJoinRound;
        layer.strokeColor = color.CGColor;
        layer.lineWidth = kIWPlaceholderLineWidth;

        [overlay.layer addSublayer:layer];
    }
    
    __weak __typeof__(self) weakSelf = self;
    self.hideBlock = ^void(BOOL animated) {
        __strong __typeof(self) strongSelf = weakSelf;
        if (animated) {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 overlay.alpha = 0;
                             } completion:^(BOOL finished) {
                                 [overlay removeFromSuperview];
                             }];
        } else {
            [overlay removeFromSuperview];
        }
        strongSelf.userInteractionEnabled = userInteractionEnabled;
    };
    
    
    // Make sure overlay covered whole view after it layout
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addSubview:overlay];
    });
}

- (void)hidePlaceholder:(BOOL)animated {
    if (self.hideBlock) {
        self.hideBlock(animated);
        self.hideBlock = nil;
    }
}

@end
