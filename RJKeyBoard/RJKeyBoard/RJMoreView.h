#import <UIKit/UIKit.h>

@protocol RJMoreViewDelegate <NSObject>

- (void)didselectImageView:(NSInteger)index;

@end

@interface RJMoreView : UIView
@property (nonatomic,strong)NSArray *imageArray;
@property (nonatomic,weak)id <RJMoreViewDelegate> delegate;
@end
