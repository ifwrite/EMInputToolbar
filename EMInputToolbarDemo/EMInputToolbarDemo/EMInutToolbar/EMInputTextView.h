//
//  EMInputTextView.h
//  EMInputToolbarDemo
//
//  Created by 苏亮 on 2016/12/14.
//  Copyright © 2016年 Emir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMInputTextView : UITextView

/**
 *  textView最大行数
 */
@property (assign, nonatomic) NSUInteger maxNumberOfLines;

/**
 *  文字高度改变block → 文字高度改变会自动调用
 *  block参数(text) → 文字内容
 *  block参数(textHeight) → 文字高度
 */
@property (copy, nonatomic) void(^jm_textHeightChangeBlock)(NSString *text,CGFloat textHeight);

@property (assign, nonatomic) NSUInteger cornerRadius;

@property (strong, nonatomic) NSString *placeholder;

@property (strong, nonatomic) UIColor *placeholderColor;

- (void)textDidChange;

@end
