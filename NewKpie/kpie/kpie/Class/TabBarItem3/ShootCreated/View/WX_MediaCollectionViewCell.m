//
//  WX_MediaCollectionViewCell.m
//  kpie
//
//  Created by 王傲擎 on 15/11/19.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_MediaCollectionViewCell.h"

@implementation WX_MediaCollectionViewCell

#if 1
{
    UIImageView             *imgView;
    UIImageView             *iconImgView;
    UIView                  *backGView;
    UILabel                 *timeLabel;
//    UIButton                *selButton;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isClick = NO;
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        imgView.userInteractionEnabled = YES;
        imgView.layer.cornerRadius = 10;
        imgView.layer.masksToBounds = YES;
        [self addSubview:imgView];
        
        self.selImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.selImgView.backgroundColor = KUIColorFromRGBA(0x000000, 0.5);
        self.selImgView.layer.cornerRadius = 10;
        self.selImgView.layer.masksToBounds = YES;
        self.selImgView.hidden = YES;
        [self addSubview:self.selImgView];
        
        self.selButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selButton.frame = CGRectMake(self.frame.size.width-30, 5, 25, 25);
        [self.selButton setBackgroundImage:[UIImage imageNamed:@"icon_dpcz_xuanzhe_n"] forState:UIControlStateNormal];
        [self.selButton setBackgroundImage:[UIImage imageNamed:@"icon_dpcz_xuanzhe_h"] forState:UIControlStateSelected];
        [self.selButton setSelected:NO];
        [self.selButton addTarget:self action:@selector(selectMovie:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.selButton];
        
        backGView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20)];
        backGView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
        [imgView addSubview:backGView];
        
        iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(3, self.frame.size.height-15, 20, 10)];
        iconImgView.image = [UIImage imageNamed:@"icon_dpcz_video_n"];
        [self addSubview:iconImgView];
        
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-40, iconImgView.frame.origin.y-3, 35, 15)];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textColor = [UIColor whiteColor];
        [self addSubview:timeLabel];
        
        self.BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.BGView];
        
    }
    return self;
}


//- (void)setSelected:(BOOL)selected
//{
//    [super setSelected:selected];
//    [self setNeedsDisplay];
//}
//


-(void)selectMovie:(UIButton *)button
{
    button.selected = !button.selected;
    self.selImgView.hidden = !self.selImgView.hidden;
    
    QNWSLog(@"button == %@",button);
}



//
//-(void)drawRect:(CGRect)rect
//{
//    if (self.selected) {
//        
//    }
//}



-(void)setCellWithImage:(UIImage *)image time:(NSString *)time
{
    imgView.image = image;
    timeLabel.text = time;
}


#if 0
-(void)setCellWithAsset:(ALAsset *)asset
{
    imgView.image = [UIImage imageWithCGImage:asset.thumbnail];
    timeLabel.text = [NSDate timeDescriptionOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDuration] doubleValue]];
  
}
#endif

#endif





#if 0
#define IS_IOS7             ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#define kThumbnailLength    78.0f

{
     ALAsset    *assets;
     UIImage    *image;
     NSString   *assetType;
     NSString   *title;
     UIImage    *videoImage;
}
static UIFont *titleFont = nil;

static CGFloat titleHeight;
static UIImage *videoIcon;
static UIColor *titleColor;
static UIImage *checkedIcon;
static UIColor *selectedColor;

+ (void)initialize
{
    titleFont       = [UIFont systemFontOfSize:12];
    titleHeight     = 20.0f;
    videoIcon       = [UIImage imageNamed:@"icon_dpcz_video_n"];
    titleColor      = [UIColor whiteColor];
    checkedIcon     = [UIImage imageNamed:(!IS_IOS7) ? @"CTAssetsPickerChecked~iOS6" : @"CTAssetsPickerChecked"];
    selectedColor   = [UIColor colorWithWhite:1 alpha:0.3];
    
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.opaque                     = YES;
        self.isAccessibilityElement     = YES;
        self.accessibilityTraits        = UIAccessibilityTraitImage;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)bind:(ALAsset *)asset
{
    assets  = asset;
    image  = [UIImage imageWithCGImage:asset.thumbnail];
    assetType   = [asset valueForProperty:ALAssetPropertyType];
    title  = [NSDate timeDescriptionOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDuration] doubleValue]];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self setNeedsDisplay];
}


// Draw everything to improve scrolling responsiveness

- (void)drawRect:(CGRect)rect
{
    // Image
    [image drawInRect:CGRectMake(0, 0, kThumbnailLength, kThumbnailLength)];
    
    // Video title
    if ([assetType isEqual:ALAssetTypeVideo])
    {
        // Create a gradient from transparent to black
        CGFloat colors [] = {
            0.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.8,
            0.0, 0.0, 0.0, 1.0
        };
        
        CGFloat locations [] = {0.0, 0.75, 1.0};
        
        CGColorSpaceRef baseSpace   = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient      = CGGradientCreateWithColorComponents(baseSpace, colors, locations, 2);
        
        CGContextRef context    = UIGraphicsGetCurrentContext();
        
        CGFloat height          = rect.size.height;
        CGPoint startPoint      = CGPointMake(CGRectGetMidX(rect), height - titleHeight);
        CGPoint endPoint        = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
        
        //
        //        CGSize titleSize        = [self.title sizeWithFont:titleFont];
        
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:titleFont}];
        
        
        NSDictionary *titleAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        
        [titleColor set];
        
        
        //        [self.title drawAtPoint:CGPointMake(rect.size.width - titleSize.width - 2 , startPoint.y + (titleHeight - 12) / 2)
        //                       forWidth:kThumbnailLength
        //                       withFont:titleFont
        //                       fontSize:12
        //                  lineBreakMode:NSLineBreakByTruncatingTail
        //             baselineAdjustment:UIBaselineAdjustmentAlignCenters];
        //
        //        [videoIcon drawAtPoint:CGPointMake(2, startPoint.y + (titleHeight - videoIcon.size.height) / 2)];
        
        //        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:@"kThumbnailLength",@"titleSize",@"12",@"NSLineBreakByTruncatingTail",@"UIBaselineAdjustmentAlignCenters", nil];
        //        [self.title drawInRect:CGRectMake(0, rect.size.height-titleHeight, rect.size.width, titleHeight) withAttributes:titleAttributes] ;
        
        NSStringDrawingContext *drawingContext = [[NSStringDrawingContext alloc]init];
        drawingContext.minimumScaleFactor = 0.5;
        
        
        [title drawWithRect:CGRectMake(rect.size.width-titleSize.width-5, rect.size.height-titleHeight+2.5, titleSize.width+5, titleHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:drawingContext];
        
        [videoIcon drawAtPoint:CGPointMake(2, startPoint.y + (titleHeight - videoIcon.size.height) / 2)];
        
    }
    
    if (self.selected)
    {
        CGContextRef context    = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, selectedColor.CGColor);
        CGContextFillRect(context, rect);
        
        [checkedIcon drawAtPoint:CGPointMake(CGRectGetMaxX(rect) - checkedIcon.size.width, CGRectGetMinY(rect))];
    }
}


- (NSString *)accessibilityLabel
{
    ALAssetRepresentation *representation = assets.defaultRepresentation;
    
    NSMutableArray *labels          = [[NSMutableArray alloc] init];
    NSString *type                  = [assets valueForProperty:ALAssetPropertyType];
    NSDate *date                    = [assets valueForProperty:ALAssetPropertyDate];
    CGSize dimension                = representation.dimensions;
    
    
    // Type
    if ([type isEqual:ALAssetTypeVideo])
        [labels addObject:NSLocalizedString(@"Video", nil)];
    else
        [labels addObject:NSLocalizedString(@"Photo", nil)];
    
    // Orientation
    if (dimension.height >= dimension.width)
        [labels addObject:NSLocalizedString(@"Portrait", nil)];
    else
        [labels addObject:NSLocalizedString(@"Landscape", nil)];
    
    // Date
    NSDateFormatter *df             = [[NSDateFormatter alloc] init];
    df.locale                       = [NSLocale currentLocale];
    df.dateStyle                    = NSDateFormatterMediumStyle;
    df.timeStyle                    = NSDateFormatterShortStyle;
    df.doesRelativeDateFormatting   = YES;
    
    [labels addObject:[df stringFromDate:date]];
    
    return [labels componentsJoinedByString:@", "];
}

#endif

@end
