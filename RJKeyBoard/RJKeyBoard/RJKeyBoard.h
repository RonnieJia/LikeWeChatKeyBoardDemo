#import <UIKit/UIKit.h>

@protocol RJKeyBoardDelegate <NSObject>

/**
 发送的文字
 */
- (void)didSendText:(NSString *)text;

/**
 回调返回高度
 */
- (void)returnHeight:(CGFloat)height;

/**
 回调返回的图片
 */
- (void)returnImage:(UIImage *)image;

@end

@interface RJKeyBoard : UIView

@property (nonatomic,weak)id <RJKeyBoardDelegate> delegate;
@property (nonatomic,strong)NSArray *imageArray; /**< 点击加号弹出的View中的图片数组 */
@property (nonatomic,strong)NSString *placeholder; /**< 占位文字 */
@property (nonatomic,strong)UIColor *placeholderColor; /**< 占位文字颜色 */
@property (nonatomic,strong)UIViewController *currentCtr;

- (void)resignFirstRespoder;
@end
