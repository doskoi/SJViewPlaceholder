//
//  ViewController.m
//  SJViewPlaceholder
//
//  Created by Sheng on 20/10/2016.
//  Copyright © 2016 Jiang Sheng. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Placeholder.h"

#define PLACEHOLDER_DURATION 3.0

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self perparePlaceholders];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(PLACEHOLDER_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removePlaceholders];
    });
}

- (void)perparePlaceholders {
    [_controls makeObjectsPerformSelector:@selector(showPlaceholder)];
}

- (void)removePlaceholders {
    [_controls makeObjectsPerformSelector:@selector(hidePlaceholder:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
