//
//  UIView+Placeholder.h
//  IWUIPlaceholder
//
//  Created by Sheng on 12/10/2016.
//  Copyright © 2016 Jiang Sheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Placeholder)
@property (nonatomic, copy) void (^hideBlock)(BOOL animated);
- (void)showPlaceholder;
- (void)hidePlaceholder:(BOOL)animated;
@end
