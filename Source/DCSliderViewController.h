//
//  PDMainViewController.h
//  iWhat
//
//  Created by DC on 1/9/15.
//  Copyright (c) 2015 PDTech.Ltd.Inc. All rights reserved.
//

@import UIKit;

@protocol DCSliderViewControllerDelegate <NSObject>

- (void)sliderMenuWillShow;
- (void)sliderMenuDidShow;
- (void)sliderMenuWillDismiss;
- (void)sliderMenuDidDismiss;

@end

@interface DCSliderViewController: UIViewController

@property (strong, nonatomic) UIViewController *menuController;
@property (strong, nonatomic) UIViewController *contentController;

@property (assign, nonatomic) CGFloat menuWidth;

@property (weak, nonatomic) id<DCSliderViewControllerDelegate> delegate;

@property (assign, nonatomic) BOOL allowPanGesture;
@property (assign, nonatomic) BOOL allowTapGesture;


/**
 @brief Init a controller which present a content view and another controller which present a slider view
 @param contentController A controller that present the content
 @param menuController A controller which be a slider menu
 @discussion This two parameters should not be nil
 */
- (id)initWithContentController:(UIViewController *)contentController
                       withMenu:(UIViewController *)menuController;

/**
 @brief Switch the current content view to a new content view
 @param contentController The new content controller
 @param animated Present the new controller with a fade animation, you can custom the animation in the 
 animation block, I means the implementation about this method
 @discussion The contentController should not be nil
 */
- (void)setContentController:(UIViewController *)contentController
                    animated:(BOOL)animated;

/**
 @brief Show the slider menu
 @param animated Present the new controller with a fade animation, you can custom the animation in the
 animation block, I means the implementation about this method
 */
- (void)showSliderMenuAnimated:(BOOL)animated;

/**
 @brief Hide the slider menu
 @param animated Present the new controller with a fade animation, you can custom the animation in the
 animation block, I means the implementation about this method
 */
- (void)dismissSliderMenuAnimated:(BOOL)animated;

@end
