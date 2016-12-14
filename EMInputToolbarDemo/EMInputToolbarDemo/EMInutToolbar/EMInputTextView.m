//
//  EMInputTextView.m
//  EMInputToolbarDemo
//
//  Created by 苏亮 on 2016/12/14.
//  Copyright © 2016年 Emir. All rights reserved.
//

#import "EMInputTextView.h"

@interface EMInputTextView ()

@property (weak, nonatomic) UITextView *placeholderView;

/**
 *  文字高度
 */
@property (assign, nonatomic) NSInteger textH;

/**
 *  文字最大高度
 */
@property (assign, nonatomic) NSInteger maxTextH;

@end

@implementation EMInputTextView

#pragma mark -
#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setup {
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.font = [UIFont systemFontOfSize:14];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark -
#pragma mark - setter
- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines {
    
    _maxNumberOfLines = maxNumberOfLines;
    // 计算最大高度 = (每行高度 * 总行数 + 文字上下间距)
    _maxTextH = ceil(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
}

- (void)setCornerRadius:(NSUInteger)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setYz_textHeightChangeBlock:(void (^)(NSString *, CGFloat))yz_textChangeBlock {
    _jm_textHeightChangeBlock = yz_textChangeBlock;
    
    [self textDidChange];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    self.placeholderView.textColor = placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    self.placeholderView.text = placeholder;
}

#pragma mark -
#pragma mark - nofitication method
- (void)textDidChange {
    // 占位文字是否显示
    self.placeholderView.hidden = self.text.length > 0;
    
    NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    
    if (_textH != height) { // 高度不一样，就改变了高度
        
        // 最大高度，可以滚动
        self.scrollEnabled = height > _maxTextH && _maxTextH > 0;
        
        _textH = height;
        
        if (_jm_textHeightChangeBlock && self.scrollEnabled == NO) {
            _jm_textHeightChangeBlock(self.text,height);
            [self.superview layoutIfNeeded];
            self.placeholderView.frame = self.bounds;
        }
    }
}

#pragma mark -
#pragma mark - lazy load
- (UITextView *)placeholderView {
    if (!_placeholderView) {
        UITextView *placeholderView = [[UITextView alloc] init];
        _placeholderView = placeholderView;
        _placeholderView.scrollEnabled = NO;
        _placeholderView.showsHorizontalScrollIndicator = NO;
        _placeholderView.showsVerticalScrollIndicator = NO;
        _placeholderView.userInteractionEnabled = NO;
        _placeholderView.font = self.font;
        _placeholderView.textColor = [UIColor lightGrayColor];
        _placeholderView.backgroundColor = [UIColor clearColor];
        [self addSubview:placeholderView];
    }
    return _placeholderView;
}


@end
