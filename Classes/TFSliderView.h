//
//  TFSliderView.h
//  eventCam
//
//  Created by Tarik Fayad on 10/8/15.
//  Copyright © 2015 Electronic Graffiti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFSliderView;
@protocol TFSliderViewDelegate <NSObject>

@optional

/*!
 Slider notifies the delegate that the slider selected the left option;
 */
- (void)sliderViewDidToggleLeftOption:(TFSliderView *)sliderView;

/*!
 Slider notifies the delegate that the slider selected the right option;
 */
- (void)sliderViewDidToggleRightOption:(TFSliderView *)sliderView;


@end

@interface TFSliderView : UIView

@property (nonatomic, weak) id<TFSliderViewDelegate> delegate;

@property (strong, nonatomic) UIColor *toggleColor;
@property (strong, nonatomic) UIColor *borderColor;

@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat springBounciness;
@property (nonatomic) CGFloat springSpeed;


@property (strong, nonatomic) UIImage *leftButtonImage;
@property (strong, nonatomic) UIImage *rightButtonImage;

/*!
 These are generated for you by default, but can be overridden at any time to use a custom image
  */
@property (strong, nonatomic) UIImage *invertedLeftImage;
@property (strong, nonatomic) UIImage *invertedRightImage;

- (instancetype) initWithFrame:(CGRect)frame borderColor: (UIColor *)borderColor borderWidth: (CGFloat) borderWidth toggleBackgroundColor: (UIColor *)toggleColor leftButtonImage: (UIImage *) leftImage rightButtonImage: (UIImage *) rightImage springBounciness: (CGFloat) bounce springSpeed: (CGFloat) speed andShouldInvertImages: (BOOL) shouldInvert;
- (void) turnOnLeftOption;
- (void) turnOnRightOption;

@end