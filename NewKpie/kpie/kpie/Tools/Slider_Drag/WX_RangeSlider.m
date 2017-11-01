//
//  WX_RangeSlider.m
//  视频滚动条_Demo
//
//  Created by 王傲擎 on 15/10/30.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_RangeSlider.h"
#import "UIColor+CustomSliderColor.h"

static NSString * const CustomRangeSliderThumbImage = @"rangeSliderThumb.png";
static NSString * const CustomRangeSliderTrackgImage = @"rangeSliderTrack.png";
static NSString * const CustomRangeSliderTrackRangeImage = @"rangeSliderTrackRange.png";

@interface WX_RangeSlider ()
@property (nonatomic) UIImageView *trackImageView;
@property (nonatomic) UIImageView *rangeImageView;

@property (nonatomic) UIImageView *leftThumbImageView;
@property (nonatomic) UIImageView *rightThumbImageView;

@end


@implementation WX_RangeSlider
@synthesize trackImage = _trackImage;
@synthesize rangeImage = _rangeImage;
@synthesize leftThumbImage = _leftThumbImage;
@synthesize rightThumbImage = _rightThumbImage;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
        [self setUpViewComponents];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaults];
        [self setUpViewComponents];
    }
    return self;
}

#pragma mark - Configuration

- (void)setDefaults
{
    self.minimumValue = 0.0f;
    self.maximumValue = 1.0f;
    self.leftValue = self.minimumDistance;
    self.rightValue = self.maximumValue;
    self.minimumDistance = 0.2f;
}

- (void)setUpViewComponents
{
    self.multipleTouchEnabled = YES;
    
    // Init track image
    self.trackImageView = [[UIImageView alloc] initWithImage:self.trackImage];
    [self addSubview:self.trackImageView];
    
    // Init range image
    self.rangeImageView = [[UIImageView alloc] initWithImage:self.rangeImage];
    [self addSubview:self.rangeImageView];
    
//    self.rangeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    self.rangeImageView.image = [UIImage imageNamed:@"icon-slider-thumb"];
//    self.rangeImageView.contentMode = UIViewContentModeScaleToFill;
//    [self addSubview:self.rangeImageView];
    
    
    // Init left thumb image
    self.leftThumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0.088*self.frame.size.width, self.frame.size.height)];
    self.leftThumbImageView.image = [UIImage imageNamed:@"icon-zuobian"];
//    self.leftThumbImageView.frame = CGRectMake(0, 0, self.leftThumbImageView.frame.size.width, self.rangeImageView.frame.size.height);
    self.leftThumbImageView.userInteractionEnabled = YES;
    self.leftThumbImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.leftThumbImageView];
    

    
    // Add left pan recognizer
    UIPanGestureRecognizer *leftPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftPan:)];
    [self.leftThumbImageView addGestureRecognizer:leftPanRecognizer];
    
    // Init right thumb image
//    self.rightThumbImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-youbian"]];
    self.rightThumbImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0.088*self.frame.size.width, self.frame.size.height)];
    self.rightThumbImageView.image = [UIImage imageNamed:@"icon-youbian"];
    self.rightThumbImageView.userInteractionEnabled = YES;
//    self.rightThumbImageView.contentMode = UIViewContentModeCenter;
    self.rightThumbImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.rightThumbImageView];
    
    // Add right pan recognizer
    UIPanGestureRecognizer *rightPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightPan:)];
    [self.rightThumbImageView addGestureRecognizer:rightPanRecognizer];
}

#pragma mark - Layout

- (CGSize)intrinsicContentSize {
    CGFloat width = _trackImage.size.width + _leftThumbImage.size.width + _rightThumbImage.size.width;
    CGFloat height = MAX(_leftThumbImage.size.height, _rightThumbImage.size.height);
    
    return CGSizeMake(width, height);
}

- (void)layoutSubviews
{
    // Calculate coords & sizes
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat trackHeight = _trackImage.size.height;
    
    CGSize leftThumbImageSize = self.leftThumbImageView.frame.size;
    CGSize rightThumbImageSize = self.rightThumbImageView.frame.size;
    
//    CGSize leftThumbImageSize = CGSizeMake(self.leftThumbImageView.frame.size.width, 30);
//    CGSize rightThumbImageSize = CGSizeMake( self.rightThumbImageView.frame.size.width, 30);
    
    CGFloat leftAvailableWidth = width - leftThumbImageSize.width;
    CGFloat rightAvailableWidth = width - rightThumbImageSize.width;
    if (self.disableOverlapping) {
        leftAvailableWidth -= leftThumbImageSize.width;
        rightAvailableWidth -= rightThumbImageSize.width;
    }
    
    CGFloat leftInset = leftThumbImageSize.width / 2;
    CGFloat rightInset = rightThumbImageSize.width / 2;
    
    CGFloat trackRange = self.maximumValue - self.minimumValue;
    
    CGFloat leftX = floorf((self.leftValue - self.minimumValue) / trackRange * leftAvailableWidth);
    if (isnan(leftX)) {
        leftX = 0.0;
    }
    
    CGFloat rightX = floorf((self.rightValue - self.minimumValue) / trackRange * rightAvailableWidth);
    if (isnan(rightX)) {
        rightX = 0.0;
    }
    
//    CGFloat trackY = (height - trackHeight) / 2;
    CGFloat gap = 1.0;
    
    // Set track frame
    CGFloat trackX = gap;
    CGFloat trackWidth = width - gap * 2;
    if (self.disableOverlapping) {
        trackX += leftInset;
        trackWidth -= leftInset + rightInset;
    }
//    self.trackImageView.frame = CGRectMake(trackX, trackY, trackWidth, trackHeight);
    self.trackImageView.frame = CGRectMake(0, 0, trackWidth, self.frame.size.height);
    
    // Set range frame
    CGFloat rangeWidth = rightX - leftX;
    if (self.disableOverlapping) {
        rangeWidth += rightInset + gap;
    }
//    self.rangeImageView.frame = CGRectMake(leftX + leftInset, trackY, rangeWidth, trackHeight);
    self.rangeImageView.frame = CGRectMake(leftX + leftInset + self.leftThumbImageView.frame.size.width/2, 0, rangeWidth - self.leftThumbImageView.frame.size.width, self.frame.size.height);
    
    // Set left & right thumb frames
    leftX += leftInset;
    rightX += rightInset;
    if (self.disableOverlapping) {
        rightX = rightX + rightInset * 2 - gap;
    }
    self.leftThumbImageView.center = CGPointMake(leftX, height / 2);
    self.rightThumbImageView.center = CGPointMake(rightX, height / 2);
}

#pragma mark - Gesture recognition

- (void)handleLeftPan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        //Fix when minimumDistance = 0.0 and slider is move to 1.0-1.0
        [self bringSubviewToFront:self.leftThumbImageView];
        
        CGPoint translation = [gesture translationInView:self];
        CGFloat trackRange = self.maximumValue - self.minimumValue;
        CGFloat width = CGRectGetWidth(self.frame) - CGRectGetWidth(self.leftThumbImageView.frame);
        
        // Change left value
        self.leftValue += translation.x / width * trackRange;
        
        [gesture setTranslation:CGPointZero inView:self];
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)handleRightPan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        //Fix when minimumDistance = 0.0 and slider is move to 1.0-1.0
        [self bringSubviewToFront:self.rightThumbImageView];
        
        CGPoint translation = [gesture translationInView:self];
        CGFloat trackRange = self.maximumValue - self.minimumValue;
        CGFloat width = CGRectGetWidth(self.frame) - CGRectGetWidth(self.rightThumbImageView.frame);
        
        // Change right value
        self.rightValue += translation.x / width * trackRange;
        
        [gesture setTranslation:CGPointZero inView:self];
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

-(void)changeSliderRangeImage:(UIImage *)image
{
    _rangeImage = image;

    self.rangeImageView.image = _rangeImage;
}

#pragma mark - Getters

- (UIImage *)trackImage
{
    if (!_trackImage) {
        _trackImage = [UIImage imageNamed:CustomRangeSliderTrackgImage];
    }
    return _trackImage;
}

- (UIImage *)rangeImage
{
    if (!_rangeImage) {
//        _rangeImage = [UIImage imageNamed:CustomRangeSliderTrackRangeImage];
        _rangeImage = [UIImage imageNamed:@"img-dpan-n"];
    }
    return _rangeImage;
}

- (UIImage *)leftThumbImage
{
    if (!_leftThumbImage) {
        _leftThumbImage = [UIImage imageNamed:CustomRangeSliderThumbImage];
    }
    return _leftThumbImage;
}

- (UIImage *)rightThumbImage
{
    if (!_rightThumbImage) {
        _rightThumbImage = [UIImage imageNamed:CustomRangeSliderThumbImage];
    }
    return _rightThumbImage;
}

#pragma mark - Setters

- (void)setMinimumValue:(CGFloat)minimumValue
{
    if (minimumValue >= self.maximumValue) {
        minimumValue = self.maximumValue - self.minimumDistance;
    }
    
    if (self.leftValue < minimumValue) {
        self.leftValue = minimumValue;
    }
    
    if (self.rightValue < minimumValue) {
        self.rightValue = self.maximumValue;
    }
    
    _minimumValue = minimumValue;
    
    [self checkMinimumDistance];
    
    [self setNeedsLayout];
}

- (void)setMaximumValue:(CGFloat)maximumValue
{
    if (maximumValue <= self.minimumValue) {
        maximumValue = self.minimumValue + self.minimumDistance;
    }
    
    if (self.leftValue > maximumValue) {
        self.leftValue = self.minimumValue;
    }
    
    if (self.rightValue > maximumValue) {
        self.rightValue = maximumValue;
    }
    
    _maximumValue = maximumValue;
    
    [self checkMinimumDistance];
    
    [self setNeedsLayout];
}


- (void)setLeftValue:(CGFloat)leftValue
{
    CGFloat allowedValue = self.rightValue - self.minimumDistance;
    if (leftValue > allowedValue) {
        if (self.pushable) {
            CGFloat rightSpace = self.maximumValue - self.rightValue;
            CGFloat deltaLeft = self.minimumDistance - (self.rightValue - leftValue);
            if (deltaLeft > 0 && rightSpace > deltaLeft) {
                self.rightValue += deltaLeft;
            }
            else {
                leftValue = allowedValue;
            }
        }
        else {
            leftValue = allowedValue;
        }
    }
    
    if (leftValue < self.minimumValue) {
        leftValue = self.minimumValue;
        if (self.rightValue - leftValue < self.minimumDistance) {
            self.rightValue = leftValue + self.minimumDistance;
        }
    }
    
    _leftValue = leftValue;
    
    [self setNeedsLayout];
}

- (void)setRightValue:(CGFloat)rightValue
{
    CGFloat allowedValue = self.leftValue + self.minimumDistance;
    if (rightValue < allowedValue) {
        if (self.pushable) {
            CGFloat leftSpace = self.leftValue - self.minimumValue;
            CGFloat deltaRight = self.minimumDistance - (rightValue - self.leftValue);
            if (deltaRight > 0 && leftSpace > deltaRight) {
                self.leftValue -= deltaRight;
            }
            else {
                rightValue = allowedValue;
            }
        }
        else {
            rightValue = allowedValue;
        }
    }
    
    if (rightValue > self.maximumValue) {
        rightValue = self.maximumValue;
        if (rightValue - self.leftValue < self.minimumDistance) {
            self.leftValue = rightValue - self.minimumDistance;
        }
    }
    
    _rightValue = rightValue;
    
    [self setNeedsLayout];
}

- (void)setMinimumDistance:(CGFloat)minimumDistance
{
    CGFloat distance = self.maximumValue - self.minimumValue;
    if (minimumDistance > distance) {
        minimumDistance = distance;
    }
    
    if (self.rightValue - self.leftValue < minimumDistance) {
        // Reset left and right values
        self.leftValue = self.minimumValue;
        self.rightValue = self.maximumValue;
    }
    
    _minimumDistance = minimumDistance;
    
    [self setNeedsLayout];
}

#pragma mark - Setters

- (void)setTrackImage:(UIImage *)trackImage
{
    _trackImage = trackImage;
    self.trackImageView.image = _trackImage;
//    self.trackImageView.backgroundColor = [UIColor colorWithHexString:@"#4bc8b6"];
}

- (void)setRangeImage:(UIImage *)rangeImage
{
    _rangeImage = rangeImage;
    self.rangeImageView.image = _rangeImage;
    

}

- (void)setLeftThumbImage:(UIImage *)leftThumbImage
{
    _leftThumbImage = leftThumbImage;
    self.leftThumbImageView.image = _leftThumbImage;
}

- (void)setRightThumbImage:(UIImage *)rightThumbImage
{
    _rightThumbImage = rightThumbImage;
    self.rightThumbImageView.image = _rightThumbImage;
}

#pragma mark - Helpers

- (void)checkMinimumDistance
{
    if (self.maximumValue - self.minimumValue < self.minimumDistance) {
        self.minimumDistance = 0.0f;
    }
}


@end
