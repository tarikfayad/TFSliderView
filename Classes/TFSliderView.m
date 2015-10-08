//
//  TFSliderView.m
//  eventCam
//
//  Created by Tarik Fayad on 10/8/15.
//  Copyright © 2015 Electronic Graffiti. All rights reserved.
//

#import "TFSliderView.h"
#import "UIImage+InvertColor.h"
#import <POP.h>


@interface TFSliderView ()

@property (strong, nonatomic) UIView *toggleBackground;

@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;

@property (nonatomic) BOOL shouldInvertImage;
@property (nonatomic) BOOL imagesInverted;

@end

@implementation TFSliderView

#pragma mark - Initializers

//Designated Initializer
- (instancetype) initWithFrame:(CGRect)frame borderColor: (UIColor *)borderColor borderWidth: (CGFloat) borderWidth toggleBackgroundColor: (UIColor *)toggleColor leftButtonImage: (UIImage *) leftImage rightButtonImage: (UIImage *) rightImage springBounciness: (CGFloat) bounce springSpeed: (CGFloat) speed andShouldInvertImages: (BOOL) shouldInvert
{
    self = [super initWithFrame:frame];
    if (self) {
        //Setting Image Inversion
        _shouldInvertImage = shouldInvert;
        
        //If we are inverting the images, lets create an inverted version and just use that over and over instead of doing a new CoreImage action every time
        if (shouldInvert) {
            _leftButtonImage = leftImage;
            _rightButtonImage = rightImage;
            _invertedLeftImage = [UIImage getInvertedImageFromImage:leftImage];
            _invertedRightImage = [UIImage getInvertedImageFromImage:rightImage];
        }
        
        //Setting spring values
        _springBounciness = bounce;
        _springSpeed = speed;
        
        //Setting up the border
        [self prefix_addBorder:UIRectEdgeTop color:borderColor thickness:borderWidth];
        [self prefix_addBorder:UIRectEdgeBottom color:borderColor thickness:borderWidth];
        
        //Setting up the toggle background
        _toggleBackground = [self toggleBackgroundFromFrame:frame];
        _toggleBackground.backgroundColor = toggleColor;
        [self addSubview:_toggleBackground];
        
        //Setting up the buttons
        _leftButton = [self leftButtonFromFrame:frame andImage:leftImage];
        _rightButton = [self rightButtonFromFrame:frame andImage:rightImage];
        [self addSubview:_leftButton];
        [self addSubview:_rightButton];
    }
    
    return self;
}

#pragma mark - Helper Inits

- (UIView *) toggleBackgroundFromFrame: (CGRect) frame
{
    CGRect toggleFrame = frame;
    toggleFrame.size.width = frame.size.width/2;
    return [[UIView alloc] initWithFrame:toggleFrame];
}

- (UIButton *) leftButtonFromFrame: (CGRect) frame andImage: (UIImage *) image
{
    CGRect buttonFrame = frame;
    buttonFrame.size.width = frame.size.width/2;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:buttonFrame];
    leftButton.adjustsImageWhenHighlighted = NO;
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(turnOnLeftOption) forControlEvents:UIControlEventTouchUpInside];
    
    return leftButton;
}

- (UIButton *) rightButtonFromFrame: (CGRect) frame andImage: (UIImage *) image
{
    CGRect buttonFrame = frame;
    buttonFrame.size.width = frame.size.width/2;
    buttonFrame.origin.x = buttonFrame.size.width;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:buttonFrame];
    rightButton.adjustsImageWhenHighlighted = NO;
    [rightButton setImage:image forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(turnOnRightOption) forControlEvents:UIControlEventTouchUpInside];
    
    return rightButton;
}

- (CALayer *)prefix_addBorder:(UIRectEdge)edge color:(UIColor *)color thickness:(CGFloat)thickness
{
    CALayer *border = [CALayer layer];
    
    switch (edge) {
        case UIRectEdgeTop:
            border.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), thickness);
            break;
        case UIRectEdgeBottom:
            border.frame = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame), thickness);
            break;
        case UIRectEdgeLeft:
            border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(self.frame));
            break;
        case UIRectEdgeRight:
            border.frame = CGRectMake(CGRectGetWidth(self.frame) - thickness, 0, thickness, CGRectGetHeight(self.frame));
            break;
        default:
            break;
    }
    
    border.backgroundColor = color.CGColor;
    
    [self.layer addSublayer:border];
    
    return border;
}

#pragma mark - Button Methods and Delegate Calls

- (void) turnOnLeftOption
{
    if (_shouldInvertImage) [self invertButtonImages];
    [self animateBackgroundLeftOnCompletion:^{
        if ([self.delegate respondsToSelector:@selector(sliderViewDidToggleLeftOption:)]) {
            return [self.delegate sliderViewDidToggleLeftOption:self];
        }
    }];
}

- (void) turnOnRightOption
{
    if (_shouldInvertImage) [self invertButtonImages];
    [self animateBackgroundRightOnCompletion:^{
        if ([self.delegate respondsToSelector:@selector(sliderViewDidToggleRightOption:)]) {
            return [self.delegate sliderViewDidToggleRightOption:self];
        }
    }];
}

- (void) invertButtonImages
{
    if (_imagesInverted) {
        [_leftButton setImage:_leftButtonImage forState:UIControlStateNormal];
        [_rightButton setImage:_rightButtonImage forState:UIControlStateNormal];
    } else {
        [_leftButton setImage:_invertedLeftImage forState:UIControlStateNormal];
        [_rightButton setImage:_invertedRightImage forState:UIControlStateNormal];
    }
    
    _imagesInverted = !_imagesInverted;
}

#pragma mark - Animation Methods

- (void) animateBackgroundLeftOnCompletion: (void (^)())completionBlock
{
    //Remove any existing animations
    [_toggleBackground.layer pop_removeAllAnimations];
    
    //Create and apply the animation towards the left
    POPSpringAnimation *pushAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    pushAnimation.springBounciness = _springBounciness;
    pushAnimation.springSpeed = _springSpeed;
    pushAnimation.toValue = @(_toggleBackground.frame.size.width/2);
    [_toggleBackground.layer pop_addAnimation:pushAnimation forKey:@"positionImageX"];
    
    //Set a completion block for the animation so we can do something once it's done if needed
    [pushAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        if (finished) {
            completionBlock();
        }
    }];
    
    [_toggleBackground.layer pop_addAnimation:pushAnimation forKey:@"popToggle"];
}

- (void) animateBackgroundRightOnCompletion: (void (^)())completionBlock
{
    
    //Remove any existing animations
    [_toggleBackground.layer pop_removeAllAnimations];
    
    //Create and apply the animation towards the left
    POPSpringAnimation *pushAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    pushAnimation.springBounciness = _springBounciness;
    pushAnimation.springSpeed = _springSpeed;
    pushAnimation.toValue = @(_toggleBackground.frame.size.width + (_toggleBackground.frame.size.width/2));
    [_toggleBackground.layer pop_addAnimation:pushAnimation forKey:@"positionImageX"];
    
    //Set a completion block for the animation so we can do something once it's done if needed
    [pushAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        if (finished) {
            completionBlock();
        }
    }];
    
    [_toggleBackground.layer pop_addAnimation:pushAnimation forKey:@"popToggle"];
}
@end
