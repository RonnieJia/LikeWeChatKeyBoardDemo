#import <UIKit/UIKit.h>

@protocol FacialViewDelegate

@optional
-(void)selectedFacialView:(NSString*)str;
-(void)deleteSelected:(NSString *)str;
-(void)sendFace;

@end

@interface FacialView : UIView
{
    NSArray *_faces;
}

@property(nonatomic) id<FacialViewDelegate> delegate;

@property(strong, nonatomic, readonly) NSArray *faces;

-(void)loadFacialView:(int)page size:(CGSize)size;

@end
