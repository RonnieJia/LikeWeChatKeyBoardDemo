//
//  VoiceView.h
//  RJKeyBoard
//
//  Created by jia on 16/4/27.
//  Copyright © 2016年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceView : UIView
- (void)playVoice;
@property (nonatomic, strong)NSString *voiceUrl;
@end
