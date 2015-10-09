# TFSliderView
TFSliderView is an easy to use stylish toggle switch for iOS 8+ built on the POP animation framework. I put it together for use in an inhouse project and thought I'd share in case anyone else needed something similar.

##Installation with CocoaPods
CocoaPods is a dependency manager for Objective-C and Swift, which automates and simplifies the process of using 3rd-party libraries in your projects. It's the preferred method of installing TFSliderView as it takes care of the POP integration as well.

####Podfile
```ruby
platform :ios, '8.0'
pod "TFSliderView", "~> 0.1.0"
```

##Example Image
<p align="center" >
  <img src="http://i.imgur.com/o0qSWTr.gif" alt="TFSlider" title="TFSlider">
</p>

##Usage
TFSliderView is very simple to use. Simply create a view programatcially (as shown below), and call the toggle delegate methods to do whatever it is you need to when the view toggles.

```objective-c
//Creating a frame for the slider that spans the width of the screen
CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 65.0f);

/*!Initializing the slider with a border color that matches the toggle color and left/right button images.
You can also set the animation constants here to change the ammount of spring and bounce that occurs as the
toggle shifts*/
TFSliderView *slider = [[TFSliderView alloc] initWithFrame:frame 
                                             borderColor:[UIColor tipiDarkGreen]
                                             borderWidth:1.0f 
                                             toggleBackgroundColor:[UIColor tipiDarkGreen] 
                                             leftButtonImage:[UIImage imageNamed:@"comment-white"] 
                                             rightButtonImage:[UIImage imageNamed:@"filled-heart-green"] 
                                             springBounciness:5.0f 
                                             springSpeed:10.0f 
                                             andShouldInvertImages:YES];

/*!Overriding the default inverted images. If not overridden with something custom, the slider will
automatically invert the image colors as it toggles*/
slider.invertedLeftImage = [UIImage imageNamed:@"comment"];
slider.invertedRightImage = [UIImage imageNamed:@"outline-heart"];

//Setting the delegate
slider.delegate = self;
    
//Adding the slider to the View Controller's view
[self.view addSubview:slider];
```

```objective-c
#pragma mark - Slider Delegates
-(void)sliderViewDidToggleLeftOption:(TFSliderView *)sliderView
{
    NSLog(@"Toggled Left");
}

- (void)sliderViewDidToggleRightOption:(TFSliderView *)sliderView
{
     NSLog(@"Toggled Right");
}
```

##To Dos
- Add support for up to four buttons
- Create more convenient init methods to accompany the one monster of a designated initializer
- Add in generic starting values for `[TFSliderView new]`
- Allow each toggle state to have a unique color
- Complete documentation
