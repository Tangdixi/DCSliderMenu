//
//  PDMainViewController.m
//  iWhat
//
//  Created by DC on 1/9/15.
//  Copyright (c) 2015 PDTech.Ltd.Inc. All rights reserved.
//

#import "DCSliderViewController.h"
#import "DCMasterUtility.h"


@interface DCSliderViewController () 

@property (strong, nonatomic) UIView *containerView;

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer;

@property (strong, nonatomic) UIPanGestureRecognizer *sliderMenuPanGestureRecognizer;

@property (assign, nonatomic, getter = isMenuViewShow) BOOL menuViewshow;



@end

@implementation DCSliderViewController

#pragma mark - Initialization

- (id)initWithContentController:(UIViewController *)contentController
                       withMenu:(UIViewController *)menuController {
    
    if (self = [super init]) {
        
        _contentController = contentController;
        _menuController = menuController;
        
        
    }
    return self;
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    //
    // Add menu controller into parent controller
    //
    [self addChildViewController:self.menuController];
    [self.menuController didMoveToParentViewController:self];
    
    // Add content controller into parent controller
    //
    [self addChildViewController:self.contentController];
    [self.contentController didMoveToParentViewController:self];
    
    // Configure a container view to hold the controller's view
    //
    _containerView = [[UIView alloc]initWithFrame:[UIScreen screenBounds]];
    [_containerView addSubview:self.contentController.view];
    
    [self insertMenuControllerView];
    [self.view addSubview:self.containerView];
    
    // Prepare tap gesture suppport
    //
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                   action:@selector(tapGestureRecognizer:)];
    
    // Add pan gesture support
    //
    _screenEdgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(screenEdgePanGestureRecognizer:)];
    _screenEdgePanGestureRecognizer.edges = UIRectEdgeRight;
    [self.containerView addGestureRecognizer:self.screenEdgePanGestureRecognizer];

    // Prepare a pan gesture support
    //
    _sliderMenuPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(sliderMenuPanGestureRecognizer:)];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gesture methods

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    if (self.menuViewshow) {
        
        [self dismissSliderMenuAnimated:YES
                         withTraslation:CGPointZero
                             completion:^(BOOL finished) {
                                 
                                 _menuViewshow = NO;
                                 
                             }];
        
    }

    
}

- (void)sliderMenuPanGestureRecognizer:(UIPanGestureRecognizer *)sliderMenuPanGestureRecognizer {
    
    // Fetch the basic parameters for the pan gesture
    //
    CGPoint translation = [sliderMenuPanGestureRecognizer translationInView:sliderMenuPanGestureRecognizer.view];
    CGPoint velocity = [sliderMenuPanGestureRecognizer velocityInView:sliderMenuPanGestureRecognizer.view];
    
    // Handle the slider menu dismiss stuff
    //
    
    CGFloat horizontalOffset = -(self.menuWidth - MAX(0, translation.x));
    
    // Handle the slider menu dismiss stuff
    //
    if (self.isMenuViewShow) {
        
        // DCSliderViewControllerDelegate Stuff
        //
        if (sliderMenuPanGestureRecognizer.state == UIGestureRecognizerStateBegan) {
            
            if ([_delegate respondsToSelector:@selector(sliderMenuWillDismiss)]) {
                [_delegate sliderMenuWillDismiss];
            }
            
        }
        else if (sliderMenuPanGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            
            self.menuController.view.transform = CGAffineTransformMakeTranslation(horizontalOffset, 0);
            
        }
        else if (sliderMenuPanGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            
            if (ABS(horizontalOffset) < self.menuWidth * 0.8f || horizontalOffset > 0) {
                
                [self dismissSliderMenuAnimated:YES
                                 withTraslation:translation
                                     completion:^(BOOL finished) {
                                         
                                         // DCSliderViewControllerDelegate Stuff
                                         //
                                         if ([_delegate respondsToSelector:@selector(sliderMenuDidDismiss)]) {
                                             [_delegate sliderMenuDidDismiss];
                                         }
                                         
                                         
                }];
                
            }
            else {
                
                [self showSliderMenuAnimated:YES
                      withCurrentTranslation:translation
                                  completion:^(BOOL finished) {
                                      
                                      // DCSliderViewControllerDelegate Stuff
                                      //
                                      if ([_delegate respondsToSelector:@selector(sliderMenuDidShow)]) {
                                          [_delegate sliderMenuDidShow];
                                      }
                                      
                }];
                
            }
            
        }
        
    }
    
    // Handle the slider menu show stuff
    //
    else {
        
        CGFloat horizontalOffset = MIN(translation.x, 0);
        
        // DCSliderViewControllerDelegate Stuff
        //
        if (sliderMenuPanGestureRecognizer.state == UIGestureRecognizerStateBegan) {
            
            if ([_delegate respondsToSelector:@selector(sliderMenuWillShow)]) {
                [_delegate sliderMenuWillShow];
            }
            
        }
        else if (sliderMenuPanGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            
            self.menuController.view.transform = CGAffineTransformMakeTranslation(horizontalOffset, 0);
            
        }
        else if (sliderMenuPanGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            
            if (ABS(horizontalOffset) > self.menuWidth * 0.25f ||
                (ABS(velocity.x) > 300 && horizontalOffset < 0)) {
                
                [self showSliderMenuAnimated:YES
                      withCurrentTranslation:translation
                                  completion:^(BOOL finished) {
                    
                                      // DCSliderViewControllerDelegate Stuff
                                      //
                                      if ([_delegate respondsToSelector:@selector(sliderMenuDidShow)]) {
                                          [_delegate sliderMenuDidShow];
                                      }
                                      
                                      [self.menuController.view addGestureRecognizer:self.sliderMenuPanGestureRecognizer];
                                      [self.contentController.view addGestureRecognizer:self.tapGestureRecognizer];
                }];
                
            }
            else {
                
                [self dismissSliderMenuAnimated:YES
                                 withTraslation:translation
                                     completion:^(BOOL finished) {
                    
                                         // DCSliderViewControllerDelegate Stuff
                                         //
                                         if ([_delegate respondsToSelector:@selector(sliderMenuDidDismiss)]) {
                                             [_delegate sliderMenuDidDismiss];
                                         }
                                         
                                         [self.menuController.view removeGestureRecognizer:self.sliderMenuPanGestureRecognizer];
                                         [self.contentController.view removeGestureRecognizer:self.tapGestureRecognizer];
                                         
                }];
                
            }
            
        }
        
    }

    
}

- (void)screenEdgePanGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer {
    
    [self sliderMenuPanGestureRecognizer:screenEdgePanGestureRecognizer];
    
}

#pragma mark - Setter and Getters

- (BOOL)isMenuViewShow {
    
    return _menuViewshow;
    
}

#pragma mark - Configure Menu Controller View

- (void)insertMenuControllerView {
    
    if (! self.menuController.view.superview) {
        
        // Make the menu locate in the right sile
        //
        self.menuController.view.center = point(self.menuController.view.width * 1.5f, self.menuController.view.height/2);
        
        // The menu will always on the top
        //
        [self.containerView insertSubview:self.menuController.view aboveSubview:self.contentController.view];
        
    }
    
}

#pragma mark - Configure Content View Controller

- (void)setContentController:(UIViewController *)contentController animated:(BOOL)animated {
    
    if (! contentController) {
        return ;
    }
    
    // Step 1.
    // Hold the current controller's pointer
    //
    UIViewController *previousContentViewController = self.contentController;
    
    // Step 2.
    // Configure the current content controller
    //
    _contentController = contentController;
    
    [self addChildViewController:self.contentController];
    [self.contentController didMoveToParentViewController:self];
    
    self.contentController.view.alpha = 0.0f;
    [self.containerView insertSubview:self.contentController.view belowSubview:self.menuController.view];
    
    // Step 3.
    // Present the view withanimation
    //
    NSTimeInterval animationTime = 0.618f * 0.5f;
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateKeyframesWithDuration:animated? animationTime : 0.0f
                                   delay:0.0f
                                 options:UIViewKeyframeAnimationOptionAllowUserInteraction
                              animations:^{
                              
                                  weakSelf.contentController.view.alpha = 1.0f;
                                  
                              }
     
                              completion:^(BOOL finished) {
                                  
                                  [previousContentViewController willMoveToParentViewController:self];
                                  [previousContentViewController removeFromParentViewController];
                                  [previousContentViewController.view removeFromSuperview];
                                  
                                  [self dismissSliderMenuAnimated:YES
                                                   withTraslation:CGPointZero
                                                       completion:^(BOOL finished) {
                                                           _menuViewshow = NO;
                                                       }];
                                  
                              }];
    
}

#pragma mark - Configure menu view animation stuff

- (void)showSliderMenuAnimated:(BOOL)animated {
    
    [self showSliderMenuAnimated:animated withCurrentTranslation:CGPointZero completion:nil];
    
}

- (void)showSliderMenuAnimated:(BOOL)animated
        withCurrentTranslation:(CGPoint)translation
                    completion:(void(^)(BOOL finished))completeBlock{
    
    // Dynamic animation duration
    //
    NSTimeInterval animationTime = 0.618f/2 * (self.menuWidth - ABS(translation.x))/self.menuWidth;
    
    // Perform the animation
    //
    __weak typeof(self) weakSelf = self;
    
    [UIView animateKeyframesWithDuration:animated? animationTime: 0.0f
                                   delay:0.0f
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations:^{
                                  
                                  weakSelf.menuController.view.transform = CGAffineTransformMakeTranslation(-self.menuWidth, 0);
                                  
                              }
                              completion:^(BOOL finished) {
                                  
                                  _menuViewshow = YES;
                                  
                                  completeBlock(finished);
                                  
                              }];
    
}

- (void)dismissSliderMenuAnimated:(BOOL)animated {
    
    [self dismissSliderMenuAnimated:YES withTraslation:CGPointZero completion:nil];
    
}

- (void)dismissSliderMenuAnimated:(BOOL)animated
                   withTraslation:(CGPoint)translation
                       completion:(void(^)(BOOL finished))completeBlock{
    
    // Dynamic animation duration
    //
    NSTimeInterval animationTime = 0.618f * (self.menuWidth - ABS(translation.x))/self.menuWidth;
    
    // Perform the animation
    //
    __weak typeof(self) weakSelf = self;
    
    [UIView animateKeyframesWithDuration:animationTime * 0.618f
                                   delay:0.0f
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations:^{
                                  
                                  weakSelf.menuController.view.transform = CGAffineTransformMakeTranslation(0, 0);
                                  
                              }
                              completion:^(BOOL finished) {
                                  
                                  _menuViewshow = NO;
                                  
                                  completeBlock(finished);
                                  
                              }];
    
}



@end
