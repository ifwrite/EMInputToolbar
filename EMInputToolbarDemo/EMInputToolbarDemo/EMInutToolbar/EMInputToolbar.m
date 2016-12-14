//
//  EMInputToolbar.m
//  EMInputToolbarDemo
//
//  Created by 苏亮 on 2016/12/14.
//  Copyright © 2016年 Emir. All rights reserved.
//

#import "EMInputToolbar.h"

static CGFloat jm_input_toolbar_margin = 5.0f;
static CGFloat jm_input_toolbar_btnWH = 33.0f;

#define MAXLINES 5
@interface EMInputToolbar ()<UITextViewDelegate>

@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;

@property (assign, nonatomic) BOOL isAnimated;

@end

@implementation EMInputToolbar

#pragma mark -
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}
- (void)setup {
    
    //默认属性
    self.inputTextView.maxNumberOfLines = MAXLINES;
    self.backgroundColor = [UIColor lightGrayColor];
    self.isAnimated = NO;
    //子控件
    [self addSubview:self.inputTextView];
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
    
    __weak typeof(self) weakSelf = self;
    self.inputTextView.jm_textHeightChangeBlock = ^(NSString *text, CGFloat textHeight) {
        
        CGRect frame = weakSelf.frame;
        frame.size.height = textHeight + jm_input_toolbar_margin * 2;
        frame.origin.y = weakSelf.frame.origin.y - (frame.size.height - weakSelf.frame.size.height);
        weakSelf.frame = frame;
        
        [weakSelf layoutIfNeeded];
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    
    self.leftBtn.frame = CGRectMake(jm_input_toolbar_margin, self.frame.size.height - jm_input_toolbar_btnWH - jm_input_toolbar_margin, jm_input_toolbar_btnWH, jm_input_toolbar_btnWH);
    
    self.inputTextView.frame = CGRectMake(CGRectGetMaxX(self.leftBtn.frame) + jm_input_toolbar_margin, jm_input_toolbar_margin, self.frame.size.width - jm_input_toolbar_btnWH * 2 - jm_input_toolbar_margin * 4, self.frame.size.height - jm_input_toolbar_margin * 2);
    
    self.rightBtn.frame = CGRectMake(CGRectGetMaxX(self.inputTextView.frame) + jm_input_toolbar_margin, self.leftBtn.frame.origin.y, jm_input_toolbar_btnWH, jm_input_toolbar_btnWH);
}

- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    if (self.isAnimated) {
        return;
    }
    self.isAnimated = YES;
    // 获取键盘frame
    CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 获取键盘弹出时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    if (endFrame.origin.y == screenH) {
        
        CGRect frame = self.frame;
        if (self.superview) {
            frame.origin.y = self.superview.frame.size.height - frame.size.height;
        }
        
        self.frame = frame;
        if (self.inputToolbarKeyboardHandle) {
            self.inputToolbarKeyboardHandle(NO, endFrame.size.height);
        }
    }else {
        CGRect frame = self.frame;
        if (self.superview) {
            frame.origin.y = self.superview.frame.size.height - frame.size.height - endFrame.size.height;
        }
        self.frame = frame;
        if (self.inputToolbarKeyboardHandle) {
            self.inputToolbarKeyboardHandle(YES, endFrame.size.height);
        }
    }
    
    // 约束动画
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
    
    self.isAnimated = NO;
}

#pragma mark -
#pragma mark - btn Action
- (void)btnAction:(UIButton *)button {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputToolBar:didClickBtnWithType:)]) {
        [self.delegate inputToolBar:self didClickBtnWithType:button.tag];
    }
}

#pragma mark -
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputToolBar:didSelectSendMessage:)]) {
            [self.delegate inputToolBar:self didSelectSendMessage:self.inputTextView.text];
            
            //清空textView
            self.inputTextView.text = nil;
            [self.inputTextView textDidChange];
        }
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark - lazy load
- (EMInputTextView *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = [[EMInputTextView alloc] init];
        _inputTextView.delegate = self;
        _inputTextView.returnKeyType = UIReturnKeySend;
    }
    return _inputTextView;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] init];
        _leftBtn.tag = InputToolbarBtnTypeLeft;
        [_leftBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _leftBtn.backgroundColor = [UIColor greenColor];
        [_leftBtn setTitle:@"求" forState:UIControlStateNormal];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.tag = InputToolbarBtnTypeRight;
        [_rightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _rightBtn.backgroundColor = [UIColor greenColor];
        [_rightBtn setTitle:@"图" forState:UIControlStateNormal];
    }
    return _rightBtn;
}

@end
