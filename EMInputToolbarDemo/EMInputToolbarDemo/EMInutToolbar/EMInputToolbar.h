//
//  EMInputToolbar.h
//  EMInputToolbarDemo
//
//  Created by 苏亮 on 2016/12/14.
//  Copyright © 2016年 Emir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMInputTextView.h"

typedef NS_ENUM(NSInteger, InputToolbarBtnType) {
    InputToolbarBtnTypeLeft,
    InputToolbarBtnTypeRight,
};

typedef void(^inputToolbarKeyboardHandle)(BOOL keyboardIsShow, CGFloat keyboardHeight);

@class EMInputToolbar;

@protocol EMInputToolbarDelegate <NSObject>

@optional;
- (void)inputToolBar:(EMInputToolbar *)inputToolbar didClickBtnWithType:(InputToolbarBtnType)type;

- (void)inputToolBar:(EMInputToolbar *)inputToolbar didSelectSendMessage:(NSString *)message;

@end

@interface EMInputToolbar : UIView

@property (weak, nonatomic) id<EMInputToolbarDelegate> delegate;

@property (strong, nonatomic) EMInputTextView *inputTextView;

@property (copy, nonatomic) inputToolbarKeyboardHandle inputToolbarKeyboardHandle;

@end
