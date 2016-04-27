#import <UIKit/UIKit.h>
#import "FacialView.h"

@protocol EmojiViewDelegate <FacialViewDelegate>

@required
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete;
- (void)sendFace;

@end

@interface EmojiView : UIView<FacialViewDelegate>
@property (nonatomic, assign) id<EmojiViewDelegate> delegate;

- (BOOL)stringIsFace:(NSString *)string;
@end
