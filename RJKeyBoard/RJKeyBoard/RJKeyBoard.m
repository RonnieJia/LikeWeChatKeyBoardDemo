#import "RJKeyBoard.h"
#import "RJTextView.h"
#import "EmojiView.h"
#import "RJMoreView.h"
#import "VoiceView.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define kBCTextViewHeight 36 /**< 底部textView的高度 */
#define kHorizontalPadding 8 /**< 横向间隔 */
#define kVerticalPadding 5 /**< 纵向间隔 */

@interface RJKeyBoard() <UITextViewDelegate, EmojiViewDelegate, RJMoreViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong)UIImageView *backgroundImageView;
@property (nonatomic,strong)UIButton *voiceBtn;
@property (nonatomic,strong)UIButton *faceBtn;
@property (nonatomic,strong)UIButton *moreBtn;
@property (nonatomic,strong)VoiceView *voiceView;
@property (nonatomic,strong)RJTextView  *textView;
@property (nonatomic,strong)UIView *faceView;
@property (nonatomic,strong)UIView *moreView;
@property (nonatomic,assign)CGFloat lastHeight;
@property (nonatomic,strong)UIView *activeView;
@property (nonatomic,assign)BOOL isRegisFirst;

@end

@implementation RJKeyBoard

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kBCTextViewHeight)) {
        frame.size.height = kVerticalPadding * 2 + kBCTextViewHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kBCTextViewHeight)) {
        frame.size.height = kVerticalPadding * 2 + kBCTextViewHeight;
    }
    [super setFrame:frame];
}
- (void)resignFirstRespoder {
    if (self.voiceBtn.selected) {
        return;
    }
    self.faceBtn.selected = NO;
    self.moreBtn.selected = NO;
    if (!self.isRegisFirst) {
        [self.textView resignFirstResponder];
        self.isRegisFirst = NO;
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.backgroundImageView.frame.size.height, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            [self willShowBottomView:nil];
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.backgroundImageView.frame.size.height, self.frame.size.width, self.backgroundImageView.frame.size.height);
        }];
    }
}

- (void)createUI
{
    _lastHeight = 30;
    //注册键盘改变是调用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backgroundImageView.userInteractionEnabled = YES;
    self.backgroundImageView.image = [[UIImage imageNamed:@"messageToolbarBg"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:10];
    
    
    //表情按钮
    self.voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voiceBtn.frame = CGRectMake(kHorizontalPadding,kHorizontalPadding, 30, 30);
    [self.voiceBtn addTarget:self action:@selector(willShowVoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.voiceBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_record"] forState:UIControlStateNormal];
    [self.voiceBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    
    //文本
    self.textView = [[RJTextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.voiceBtn.frame)+kHorizontalPadding, kHorizontalPadding, self.bounds.size.width - 5*kHorizontalPadding - 30*3, 30)];
    self.textView.font = [UIFont systemFontOfSize:16.0];
    self.textView.placeholderColor = self.placeholderColor;
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.scrollEnabled = NO;
    self.textView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    self.textView.layer.borderWidth = 0.65f;
    self.textView.layer.cornerRadius = 6.0f;
    self.textView.delegate = self;
    
    // 按住说话
    self.voiceView = [[VoiceView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.voiceBtn.frame)+kHorizontalPadding, kHorizontalPadding, self.bounds.size.width - 5*kHorizontalPadding - 30*3, 30)];
    self.voiceView.hidden = YES;
    
    //表情按钮
    self.faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.faceBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame)+kHorizontalPadding,kHorizontalPadding, 30, 30);
    [self.faceBtn addTarget:self action:@selector(willShowFaceView:) forControlEvents:UIControlEventTouchUpInside];
    [self.faceBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_face"] forState:UIControlStateNormal];
    [self.faceBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    
    //更多按钮
    self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreBtn.frame = CGRectMake(CGRectGetMaxX(self.faceBtn.frame)+kHorizontalPadding,kHorizontalPadding,30,30);
    [self.moreBtn addTarget:self action:@selector(willShowactiveView:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_more"] forState:UIControlStateNormal];
    [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    
    [self addSubview:self.backgroundImageView];
    [self.backgroundImageView addSubview:self.voiceBtn];
    [self.backgroundImageView addSubview:self.textView];
    [self.backgroundImageView addSubview:self.faceBtn];
    [self.backgroundImageView addSubview:self.moreBtn];
    [self.backgroundImageView addSubview:self.voiceView];
    
    if (!self.faceView) {
        self.faceView = [[EmojiView alloc] initWithFrame:CGRectMake(0, (kHorizontalPadding * 2 + 30), self.frame.size.width, 220)];
        [(EmojiView *)self.faceView setDelegate:self];
        self.faceView.backgroundColor = [UIColor whiteColor];
        self.faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    if (!self.moreView) {
        self.moreView = [[RJMoreView alloc] initWithFrame:CGRectMake(0, (kHorizontalPadding * 2 + 30), self.frame.size.width, 200)];
        self.moreView.backgroundColor = [UIColor whiteColor];
        [(RJMoreView *)self.moreView setDelegate:self];
        self.moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
}

- (void)changeFrame:(CGFloat)height{
    
    if (height == _lastHeight)
    {
        return;
    }
    else{
        
        if (height > 100) {
            self.textView.scrollEnabled = YES;
            return;
        }
        self.textView.scrollEnabled = NO;
        CGFloat changeHeight = height - _lastHeight;
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.backgroundImageView.frame;
        rect.size.height += changeHeight;
        self.backgroundImageView.frame = rect;
        
        
        [self.textView setContentOffset:CGPointMake(0.0f, (self.textView.contentSize.height - self.textView.frame.size.height) / 2) animated:YES];
        
        CGRect frame = self.textView.frame;
        frame.size.height = height;
        self.textView.frame = frame;
        
        _lastHeight = height;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(returnHeight:)]) {
            [self.delegate returnHeight:height];
        }
    }
    
}
- (void)setPlaceholder:(NSString *)placeholder
{
    self.textView.placeholder = placeholder;
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    self.textView.placeholderColor = placeholderColor;
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    void(^animations)() = ^{
        CGRect frame = self.frame;
        frame.origin.y = endFrame.origin.y - self.backgroundImageView.frame.size.height;
        if (!self.isRegisFirst) {
            self.frame = frame;
            
        }
        
    };
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
}

#pragma mark 声音
- (void)willShowVoiceBtn:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.voiceView.hidden = !btn.selected;
    self.textView.hidden = btn.selected;
    
    self.moreBtn.selected = NO;
    self.faceBtn.selected = NO;
    if (btn.selected) {
        [self willShowBottomView:nil];
        self.isRegisFirst = YES;
        [self.textView resignFirstResponder];
    } else {
        self.isRegisFirst = NO;
        [self.textView becomeFirstResponder];
    }
}

#pragma mark 表情View
- (void)willShowFaceView:(UIButton *)btn
{
    self.voiceBtn.selected = NO;
    self.voiceView.hidden = YES;
    self.textView.hidden = NO;
    btn.selected = !btn.selected;
    if(btn.selected == YES){
        self.moreBtn.selected = NO;
        self.isRegisFirst = YES;
        [self.textView resignFirstResponder];
        [self willShowBottomView:self.faceView];
    }else{
        self.isRegisFirst = NO;
        [self willShowBottomView:nil];
        [self.textView becomeFirstResponder];
    }
}

#pragma mark 更多View
- (void)willShowactiveView:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if(btn.selected == YES){
        self.faceBtn.selected = NO;
        self.textView.hidden = NO;
        self.voiceBtn.selected = NO;
        self.isRegisFirst = YES;
        [self willShowBottomView:self.moreView];
        [self.textView resignFirstResponder];
        [(RJMoreView *)self.moreView setImageArray:self.imageArray];
    }else{
        [self willShowBottomView:nil];
        self.isRegisFirst = NO;
        [self.textView becomeFirstResponder];
    }
}

- (void)willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.backgroundImageView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height-toHeight), fromFrame.size.width, toHeight);
    toFrame.origin.y = [UIScreen mainScreen].bounds.size.height - toHeight;
    if (self.voiceBtn.selected) {
        self.frame = CGRectMake(fromFrame.origin.x, [UIScreen mainScreen].bounds.size.height-46, fromFrame.size.width, 46);
    } else {
        self.frame = toFrame;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(returnHeight:)]) {
        [self.delegate returnHeight:toHeight];
    }
}
- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    return ceilf([textView sizeThatFits:textView.frame.size].height);
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.isRegisFirst = NO;
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self willShowBottomView:nil];
    self.faceBtn.selected = NO;
    self.moreBtn.selected = NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:textView.text];
            self.textView.text = @"";
            [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
        }
        return NO;
    }
    return YES;
}
- (void)willShowBottomView:(UIView *)bottomView
{
    if (![self.activeView isEqual:bottomView]) {
        
        if (self.voiceBtn.selected) {
            [self willShowBottomHeight:0];
        }
        
        if (bottomView) {
            
            CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
            [self willShowBottomHeight:bottomHeight];
            
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.backgroundImageView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
        }
        if (self.activeView) {
            [self.activeView removeFromSuperview];
        }
        self.activeView = bottomView;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
}
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete
{
    NSString *chatText = self.textView.text;
    
    if (!isDelete && str.length > 0) {
        self.textView.text = [NSString stringWithFormat:@"%@%@",chatText,str];
    }
    else {
        if (chatText.length >= 2)
        {
            NSString *subStr = [chatText substringFromIndex:chatText.length-2];
            if ([(EmojiView *)self.faceView stringIsFace:subStr]) {
                self.textView.text = [chatText substringToIndex:chatText.length-2];
                [self textViewDidChange:self.textView];
                return;
            }
        }
        if (chatText.length > 0) {
            self.textView.text = [chatText substringToIndex:chatText.length-1];
        }
    }
    [self textViewDidChange:self.textView];
}
- (void)sendFace
{
    NSString *chatText = self.textView.text;
    if (chatText.length > 0) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:chatText];
            self.textView.text = @"";
            [self changeFrame:ceilf([self.textView sizeThatFits:self.textView.frame.size].height)];
        }
    }
}
- (void)didselectImageView:(NSInteger)index
{
    switch (index) {
        case 0:
            [self createActionSheet];
            break;
        default:
            break;
    }
}
- (void)createActionSheet
{
    UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:@"选取照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从摄像头选取", @"从图片库选择",nil];
    [action showInView:self];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self openCamera];
            break;
        case 1:
            [self openLibary];
            break;
        default:
            break;
    }
}
- (void)openCamera{
    //打开系统相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.currentCtr presentViewController:picker animated:YES completion:nil];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if([self.delegate respondsToSelector:@selector(returnImage:)]){
        [self.delegate returnImage:image];
    }
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self.currentCtr dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.currentCtr dismissViewControllerAnimated:YES completion:nil];
}
- (void)openLibary{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.currentCtr presentViewController:picker animated:YES completion:nil];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

@end
