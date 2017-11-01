//
//  BYC_KeyboardEmoji.m
//  自定义键盘
//
//  Created by 元朝 on 16/3/1.
//  Copyright © 2016年 BYC. All rights reserved.
//

#import "BYC_KeyboardEmoji.h"

#define item_width  screenWidth / 7.0f
#define item_height 250 / 4.0f

NSString * const Notification_SelectedFaceName         = @"KNotification_SelectedFaceName";

@interface BYC_KeyboardEmoji() {

    NSMutableArray *item_Smilies;
}

@property (nonatomic, strong)  NSMutableArray  *mArray_Emoji;
@end

@implementation BYC_KeyboardEmoji


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        self.pageNumber = item_Smilies.count;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initData {
    
    NSString *emojiPath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:nil];
    NSError *error;
    NSString *emojiString = [NSString stringWithContentsOfFile:emojiPath encoding:NSUTF8StringEncoding error:&error];
    
    if (error == nil) {
        
        NSArray *emojiArray = [emojiString componentsSeparatedByString:@"\n"];
        if (_mArray_Emoji == nil)_mArray_Emoji = [NSMutableArray array];
        for (NSString *emoji in emojiArray) {
            
            NSMutableArray *arrayEmoji = [[emoji componentsSeparatedByString:@","] mutableCopy];
            arrayEmoji[1] = [arrayEmoji[1] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            [_mArray_Emoji addObject:arrayEmoji];
        }
    }
    for (int i = (int)(_mArray_Emoji.count / 28) + 1; i > 0; i--) {//添加删除按钮
        NSArray *arrayDel = @[@"face_del_ico_dafeult.png",@""];
        if (i == (int)(_mArray_Emoji.count / 28) + 1)
            [_mArray_Emoji insertObject:arrayDel atIndex:_mArray_Emoji.count];
            else [_mArray_Emoji insertObject:arrayDel atIndex:i * 27];
    }
        NSMutableArray *item_Smilies2D = nil;
        if (item_Smilies == nil)item_Smilies = [NSMutableArray array];
        for (int i = 0; i<_mArray_Emoji.count; i++) {
            NSArray *item = [_mArray_Emoji objectAtIndex:i];
            if (i % 28 == 0) {
                item_Smilies2D = [NSMutableArray arrayWithCapacity:28];
                [item_Smilies addObject:item_Smilies2D];
            }
            [item_Smilies2D addObject:item];
        }
        self.kwidth = item_Smilies.count * screenWidth;
        self.kheight = 4 * item_height;
}

- (void)touchSmilie:(CGPoint)point {
    
    int page = point.x / (screenWidth);
    float x = point.x - (page*screenWidth) ;
    float y = point.y;
    int colum = x / (item_width);
    int row = y / (item_height);
    if (colum > 6)colum = 6;
    if (colum < 0)colum = 0;
    if (row > 3)    row = 3;
    if (row < 0)    row = 0;
    int index = colum + row*7;
    NSArray *item_Smilies2D = [item_Smilies objectAtIndex:page];
    if (index < item_Smilies2D.count) {
        
        NSArray *item = [item_Smilies2D objectAtIndex:index];
        NSString *itemName = item[1];
        if ([itemName isEqualToString: @""])
            if (self.block != nil) _block(YES,nil);
        if (![self.selectedFaceName isEqualToString:itemName] || self.selectedFaceName == nil)self.selectedFaceName = itemName;
    }
    
}

- (void)drawRect:(CGRect)rect
{

    int row = 0 , colum = 0;
    for (int i = 0; i<item_Smilies.count; i++) {
        NSArray *item_Smilies2D = [item_Smilies objectAtIndex:i];
        
        for (int j = 0; j<item_Smilies2D.count; j++) {
            NSArray *item = [item_Smilies2D objectAtIndex:j];
            UIImage *image= [UIImage imageNamed:item[0]];
            
            CGRect frame = CGRectMake(item_width*colum , item_height*row, item_width, item_height);
            float x = (i * screenWidth) + frame.origin.x;
            frame.origin.x = x;
            CGRect imageRect = CGRectMake(CGRectGetCenter(frame).x - 30 / 2.0f, CGRectGetCenter(frame).y - 30 / 2.0f , 30, 30);
            [image drawInRect:imageRect];
            colum++;
            if (colum % 7 == 0) {
                row++;
                colum = 0;
            }
            if (row == 4)row = 0;
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch  locationInView:self];
    [self touchSmilie:point];
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
    //防止传nil空数据崩溃
    if (self.block != nil) _block(NO, self.selectedFaceName.length > 0 ? self.selectedFaceName : @"");
    self.selectedFaceName = @"";
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
}

-(void)dealloc {
    _block = nil;
    QNWSLog(@"%@",NSStringFromClass([self class]));
    
}
@end
