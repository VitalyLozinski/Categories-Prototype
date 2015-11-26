//
//  SlideNavigationController.m
//  ShopShopMe
//
//  Created by Jin WeiYi on 6/6/15.
//  Copyright (c) 2015 Minhua. All rights reserved.
//

#import "SlideNavigationController.h"
#import "SlideNavigationContorllerAnimator.h"
#import "Define.h"

typedef enum {
	PopTypeAll,
	PopTypeRoot
} PopType;

@interface SlideNavigationController() <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint draggingPoint;
@property (nonatomic, assign) BOOL menuNeedsLayout;
@property (nonatomic, assign) BOOL lastRevealedMenu;
@property (nonatomic, assign) BOOL didMenuOpened;
@end

@implementation SlideNavigationController

static SlideNavigationController *singletonInstance;

#pragma mark - Initialization -

+ (SlideNavigationController *)sharedInstance
{
	if (!singletonInstance)
		NSLog(@"SlideNavigationController has not been initialized. Either place one in your storyboard or initialize one in code");
	
	return singletonInstance;
}

- (id)init
{
	if (self = [super init])
	{
		[self setup];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		[self setup];
	}
	
	return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
	if (self = [super initWithRootViewController:rootViewController])
	{
		[self setup];
	}
	
	return self;
}

- (id)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass
{
	if (self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass])
	{
		[self setup];
	}
	
	return self;
}

- (void)setup
{
	if (singletonInstance)
		NSLog(@"Singleton instance already exists. You can only instantiate one instance of SlideNavigationController. This could cause major issues");
	
	singletonInstance = self;
    
    UIImage *navBarImg = [[UIImage imageNamed:@"navigation_bar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
    [[UINavigationBar appearance] setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
    
	self.menuRevealAnimationDuration = MENU_SLIDE_ANIMATION_DURATION;
	self.menuRevealAnimationOption = MENU_SLIDE_ANIMATION_OPTION;
	self.portraitSlideOffset = MENU_DEFAULT_SLIDE_OFFSET;
	self.panGestureSideOffset = 0;
	self.avoidSwitchingToSameClassViewController = YES;
	self.enableShadow = YES;
	self.enableSwipeGesture = YES;
    self.lastRevealedMenu = NO;
    self.didMenuOpened = NO;
	self.delegate = self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	// Update shadow size of enabled
    self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    
    // When menu open we disable user interaction
    // When rotates we want to make sure that userInteraction is enabled again
    [self enableTapGestureToCloseMenu:NO];
    
    if (self.menuNeedsLayout)
    {
        [self updateMenuFrameAndTransformAccordingToOrientation];
        
        // Handle different horizontal/vertical slideOffset during rotation
        // On iOS below 8 we just close the menu, iOS8 handles rotation better so we support keepiong the menu open
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && [self isMenuOpen])
        {
            [self openMenuForDuration:0 andCompletion:nil];
        }
        
        self.menuNeedsLayout = NO;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    self.menuNeedsLayout = YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    self.menuNeedsLayout = YES;
}

#pragma mark - Public Methods -


- (void)switchToViewController:(UIViewController *)viewController
					   popType:(PopType)poptype
				 andCompletion:(void (^)())completion
{
	if (self.avoidSwitchingToSameClassViewController && [self.topViewController isKindOfClass:viewController.class])
	{
		[self closeMenuWithCompletion:completion];
		return;
	}
	
	void (^switchAndCallCompletion)(BOOL) = ^(BOOL closeMenuBeforeCallingCompletion) {
		if (poptype == PopTypeAll) {
			[self setViewControllers:@[viewController]];
		}
		else {
			[super popToRootViewControllerAnimated:NO];
			[super pushViewController:viewController animated:NO];
		}
		
		if (closeMenuBeforeCallingCompletion)
		{
			[self closeMenuWithCompletion:^{
				if (completion)
					completion();
			}];
		}
		else
		{
			if (completion)
				completion();
		}
	};
	
	if ([self isMenuOpen])
	{
        switchAndCallCompletion(YES);
	}
	else
	{
		switchAndCallCompletion(NO);
	}
}

- (void)popToRootAndSwitchToViewController:(UIViewController *)viewController
						 withCompletion:(void (^)())completion
{
	[self switchToViewController:viewController popType:PopTypeRoot andCompletion:completion];
}

- (void)popAllAndSwitchToViewController:(UIViewController *)viewController
						 withCompletion:(void (^)())completion
{
	[self switchToViewController:viewController popType:PopTypeAll andCompletion:completion];
}

- (void)closeMenuWithCompletion:(void (^)())completion
{
	[self closeMenuWithDuration:self.menuRevealAnimationDuration andCompletion:completion];
}

- (BOOL)shouldDisplayMenuforViewController:(UIViewController *)vc
{

    if ([vc respondsToSelector:@selector(slideNavigationControllerShouldDisplayMenu)] &&
        [(UIViewController<SlideNavigationControllerDelegate> *)vc slideNavigationControllerShouldDisplayMenu])
    {
        return YES;
    }
    
    return NO;
}

- (void)openMenuWithCompletion:(void (^)())completion
{
	[self openMenuForDuration:self.menuRevealAnimationDuration andCompletion:completion];
}

- (void)toggleMenu
{
	[self toggleMenuWithCompletion:nil];
}

- (BOOL)isMenuOpen
{
	return (self.horizontalLocation == 0) ? NO : YES;
}

- (void)setEnableShadow:(BOOL)enable
{
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowRadius = MENU_SHADOW_RADIUS;
    self.view.layer.shadowOpacity = MENU_SHADOW_OPACITY;
    self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    self.view.layer.shouldRasterize = YES;
    self.view.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

#pragma mark - Override Methods -

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
	if ([self isMenuOpen])
	{
		[self closeMenuWithCompletion:^{
			[super popToRootViewControllerAnimated:animated];
		}];
	}
	else
	{
		return [super popToRootViewControllerAnimated:animated];
	}
	
	return nil;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if ([self isMenuOpen])
	{
		[self closeMenuWithCompletion:^{
			[super pushViewController:viewController animated:animated];
		}];
	}
	else
	{
		[super pushViewController:viewController animated:animated];
	}
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if ([self isMenuOpen])
	{
		[self closeMenuWithCompletion:^{
			[super popToViewController:viewController animated:animated];
		}];
	}
	else
	{
		return [super popToViewController:viewController animated:animated];
	}
	
	return nil;
}

#pragma mark - Private Methods -

- (void)updateMenuFrameAndTransformAccordingToOrientation
{
	// Animate rotatation when menu is open and device rotates
	CGAffineTransform transform = self.view.transform;
	self.leftMenu.view.transform = transform;
	self.leftMenu.view.frame = [self initialRectForMenu];
}

- (void)enableTapGestureToCloseMenu:(BOOL)enable
{
	if (enable)
	{
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
			self.interactivePopGestureRecognizer.enabled = NO;
		
		self.topViewController.view.userInteractionEnabled = NO;
		[self.view addGestureRecognizer:self.tapRecognizer];
	}
	else
	{
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
			self.interactivePopGestureRecognizer.enabled = YES;
		
		self.topViewController.view.userInteractionEnabled = YES;
		[self.view removeGestureRecognizer:self.tapRecognizer];
	}
}

- (void)toggleMenuWithCompletion:(void (^)())completion
{
	if ([self isMenuOpen])
		[self closeMenuWithCompletion:completion];
	else
		[self openMenuWithCompletion:completion];
}

- (UIBarButtonItem *)barButtonItemForMenu
{
	SEL selector = @selector(menuSelected:);
	UIBarButtonItem *customButton = self.leftBarButtonItem;
	
	if (customButton)
	{
		customButton.action = selector;
		customButton.target = self;
		return customButton;
	}
	else
	{
		UIImage *image = [UIImage imageNamed:@"btn_menu.png"];
        return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:selector];
	}
}

- (void)openMenuForDuration:(float)duration andCompletion:(void (^)())completion
{
	[self enableTapGestureToCloseMenu:YES];

	[self prepareMenuForReveal];
    
	[UIView animateWithDuration:duration
						  delay:0
						options:self.menuRevealAnimationOption
					 animations:^{
						 CGRect rect = self.view.frame;
						 CGFloat width = self.horizontalSize;
						 rect.origin.x = width - self.slideOffset;
						 [self moveHorizontallyToLocation:rect.origin.x];
					 }
					 completion:^(BOOL finished) {
						 if (completion)
							 completion();
                         
                         [self postNotificationWithName:SLIDE_NAVIGATIONCONTROLLER_DID_OPEN];
                         self.didMenuOpened = YES;
					 }];
}

- (void)closeMenuWithDuration:(float)duration andCompletion:(void (^)())completion
{
	[self enableTapGestureToCloseMenu:NO];
    
	[UIView animateWithDuration:duration
						  delay:0
						options:self.menuRevealAnimationOption
					 animations:^{
						 CGRect rect = self.view.frame;
						 rect.origin.x = 0;
						 [self moveHorizontallyToLocation:rect.origin.x];
					 }
					 completion:^(BOOL finished) {
						 if (completion)
							 completion();
                         
                         [self postNotificationWithName:SLIDE_NAVIGATIONCONTROLLER_DID_CLOSE];
                         self.didMenuOpened = NO;
					 }];
}

- (void)moveHorizontallyToLocation:(CGFloat)location
{
	CGRect rect = self.view.frame;
	UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    if ((location > 0 && self.horizontalLocation <= 0) || (location < 0 && self.horizontalLocation >= 0)) {
        [self postNotificationWithName:SLIDE_NAVIGATIONCONTROLLER_DID_REVEAL];
    }
	
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        rect.origin.x = location;
        rect.origin.y = 0;
    }
    else
    {
        rect.origin.x = (orientation == UIDeviceOrientationPortrait) ? location : location*-1;
        rect.origin.y = 0;
    }
	
	self.view.frame = rect;
	[self updateMenuAnimation];
}

- (void)updateMenuAnimation
{
    CGFloat progress = self.horizontalLocation / (self.horizontalSize - self.slideOffset);
	[self.menuRevealAnimator animateMenuWithProgress:progress];
}

- (CGRect)initialRectForMenu
{
	CGRect rect = self.view.frame;
	rect.origin.x = 0;
	rect.origin.y = 0;
	
	if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        return rect;
    }
    
    rect.origin.y = STATUS_BAR_HEIGHT;
    rect.size.height = self.view.frame.size.height-STATUS_BAR_HEIGHT;

	return rect;
}

- (void)prepareMenuForReveal
{
    // Only prepare menu if it has changed (ex: from MenuLeft to MenuRight or vice versa)
    if (self.lastRevealedMenu)
        return;
    
    UIViewController *menuViewController = self.leftMenu;
    
    self.lastRevealedMenu = YES;
    
    [self.view.window insertSubview:menuViewController.view atIndex:0];
    [self updateMenuFrameAndTransformAccordingToOrientation];
    
    [self.menuRevealAnimator prepareMenuForAnimation];
}

- (CGFloat)horizontalLocation
{
	CGRect rect = self.view.frame;
	UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
	
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        return rect.origin.x;
    }
    else
    {
        return (orientation == UIDeviceOrientationPortrait)
        ? rect.origin.x
        : rect.origin.x*-1;
    }
}

- (CGFloat)horizontalSize
{
	CGRect rect = self.view.frame;
	
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        return rect.size.width;
    }
    else
    {
        return rect.size.width;
    }
}

- (void)postNotificationWithName:(NSString *)name
{
    NSString *menuString = NOTIFICATION_USER_INFO_MENU_LEFT;
    NSDictionary *userInfo = @{ NOTIFICATION_USER_INFO_MENU : menuString };
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
}

#pragma mark - UINavigationControllerDelegate Methods -

- (void)navigationController:(UINavigationController *)navigationController
	  willShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated
{
	if ([self shouldDisplayMenuforViewController:viewController])
		viewController.navigationItem.leftBarButtonItem = [self barButtonItemForMenu];
}

- (CGFloat)slideOffset
{
	return self.portraitSlideOffset;
}

#pragma mark - IBActions -

- (void)menuSelected:(id)sender
{
	if ([self isMenuOpen])
		[self closeMenuWithCompletion:nil];
	else
		[self openMenuWithCompletion:nil];
}

#pragma mark - Gesture Recognizing -

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
	[self closeMenuWithCompletion:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	if (self.panGestureSideOffset == 0)
		return YES;
	
	CGPoint pointInView = [touch locationInView:self.view];
	CGFloat horizontalSize = [self horizontalSize];
	
	return (pointInView.x <= self.panGestureSideOffset || pointInView.x >= horizontalSize - self.panGestureSideOffset)
		? YES
		: NO;
}

- (void)panDetected:(UIPanGestureRecognizer *)aPanRecognizer
{
	CGPoint translation = [aPanRecognizer translationInView:aPanRecognizer.view];
    CGPoint velocity = [aPanRecognizer velocityInView:aPanRecognizer.view];
	NSInteger movement = translation.x - self.draggingPoint.x;
    
    if (![self shouldDisplayMenuforViewController:self.topViewController])
        return;
    
    if ((self.didMenuOpened && velocity.x < 0) || (!self.didMenuOpened && velocity.x > 0))
    {
        [self prepareMenuForReveal];
        
        if (aPanRecognizer.state == UIGestureRecognizerStateBegan)
        {
            self.draggingPoint = translation;
        }
        else if (aPanRecognizer.state == UIGestureRecognizerStateChanged)
        {
            static CGFloat lastHorizontalLocation = 0;
            CGFloat newHorizontalLocation = [self horizontalLocation];
            lastHorizontalLocation = newHorizontalLocation;
            newHorizontalLocation += movement;
            
            if (newHorizontalLocation >= self.minXForDragging && newHorizontalLocation <= self.maxXForDragging)
                [self moveHorizontallyToLocation:newHorizontalLocation];
            
            self.draggingPoint = translation;
        }
        else if (aPanRecognizer.state == UIGestureRecognizerStateEnded)
        {
            NSInteger currentX = [self horizontalLocation];
            NSInteger currentXOffset = (currentX > 0) ? currentX : currentX * -1;
            NSInteger positiveVelocity = (velocity.x > 0) ? velocity.x : velocity.x * -1;
            
            // If the speed is high enough follow direction
            if (positiveVelocity >= MENU_FAST_VELOCITY_FOR_SWIPE_FOLLOW_DIRECTION)
            {
                // Moving Right
                if (velocity.x > 0)
                {
                    if (currentX > 0)
                    {
                        if ([self shouldDisplayMenuforViewController:self.visibleViewController])
                            [self openMenuForDuration:MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
                    }
                    else
                    {
                        [self closeMenuWithDuration:MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
                    }
                }
                // Moving Left
                else
                {
                    if (currentX > 0)
                    {
                        [self closeMenuWithDuration:MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
                    }
                    else
                    {
                        if ([self shouldDisplayMenuforViewController:self.visibleViewController])
                            [self openMenuForDuration:MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
                    }
                }
            }
            else
            {
                if (currentXOffset < (self.horizontalSize - self.slideOffset)/2)
                    [self closeMenuWithCompletion:nil];
                else
                    [self openMenuWithCompletion:nil];
            }
        }
    }
}

- (NSInteger)minXForDragging
{
	if ([self shouldDisplayMenuforViewController:self.topViewController])
	{
		return (self.horizontalSize - self.slideOffset)  * -1;
	}
	
	return 0;
}

- (NSInteger)maxXForDragging
{
	if ([self shouldDisplayMenuforViewController:self.topViewController])
	{
		return self.horizontalSize - self.slideOffset;
	}
	
	return 0;
}

#pragma mark - Setter & Getter -

- (UITapGestureRecognizer *)tapRecognizer
{
	if (!_tapRecognizer)
	{
		_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
	}
	
	return _tapRecognizer;
}

- (UIPanGestureRecognizer *)panRecognizer
{
	if (!_panRecognizer)
	{
		_panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
		_panRecognizer.delegate = self;
	}
	
	return _panRecognizer;
}

- (void)setEnableSwipeGesture:(BOOL)markEnableSwipeGesture
{
	_enableSwipeGesture = markEnableSwipeGesture;
	
	if (_enableSwipeGesture)
	{
		[self.view addGestureRecognizer:self.panRecognizer];
	}
	else
	{
		[self.view removeGestureRecognizer:self.panRecognizer];
	}
}

- (void)setMenuRevealAnimator:(id<SlideNavigationContorllerAnimator>)menuRevealAnimator
{
	[self.menuRevealAnimator clear];
	
	_menuRevealAnimator = menuRevealAnimator;
}

- (void)setLeftMenu:(UIViewController *)leftMenu
{
    [_leftMenu.view removeFromSuperview];
    
    _leftMenu = leftMenu;
}

@end
