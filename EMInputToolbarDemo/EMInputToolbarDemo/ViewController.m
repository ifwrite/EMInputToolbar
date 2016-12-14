//
//  ViewController.m
//  EMInputToolbarDemo
//
//  Created by 苏亮 on 2016/12/14.
//  Copyright © 2016年 Emir. All rights reserved.
//

#import "ViewController.h"
#import "EMInputToolbar.h"

@interface ViewController ()<EMInputToolbarDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    EMInputToolbar *inputToolbar = [[EMInputToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 43, self.view.frame.size.width, 43)];
    inputToolbar.delegate = self;
    
    [self.view addSubview:inputToolbar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - EMInputToolbarDelegate
- (void)inputToolBar:(EMInputToolbar *)inputToolbar didSelectSendMessage:(NSString *)message {
    NSLog(@"message: %@", message);
}

- (void)inputToolBar:(EMInputToolbar *)inputToolbar didClickBtnWithType:(InputToolbarBtnType)type {
    NSLog(@"click button-%d", type ? 2 : 1);
}
@end
