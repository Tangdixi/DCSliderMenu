//
//  DCSliderViewController+sliderMenu.m
//  iWhat
//
//  Created by DC on 1/16/15.
//  Copyright (c) 2015 PDTech.Ltd.Inc. All rights reserved.
//

#import "DCSliderViewController+sliderMenu.h"

@implementation DCSliderViewController (sliderMenu)

- (DCSliderViewController *)sliderMenu {
    
    UIViewController *sliderViewController = self.parentViewController;
    
    while (sliderViewController) {
        if ([sliderViewController isKindOfClass:[DCSliderViewController class]]) {
            return (DCSliderViewController *)sliderViewController;
        }
        sliderViewController = sliderViewController.parentViewController;
    }
    
    return nil;
    
}

@end
