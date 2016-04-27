#import "EmojiView.h"

@interface EmojiView ()
{
    FacialView *_facialView;
}

@end

@implementation EmojiView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _facialView = [[FacialView alloc] initWithFrame: CGRectMake(5, 5, frame.size.width - 10, self.bounds.size.height - 10)];
        [_facialView loadFacialView:1 size:CGSizeMake(30, 30)];
        _facialView.delegate = self;
        [self addSubview:_facialView];
    }
    return self;
}

#pragma mark - FacialViewDelegate

-(void)selectedFacialView:(NSString*)str{
    if (_delegate) {
        [_delegate selectedFacialView:str isDelete:NO];
    }
}

-(void)deleteSelected:(NSString *)str{
    if (_delegate) {
        [_delegate selectedFacialView:str isDelete:YES];
    }
}

- (void)sendFace
{
    if (_delegate) {
        [_delegate sendFace];
    }
}

#pragma mark - public

- (BOOL)stringIsFace:(NSString *)string
{
    if ([_facialView.faces containsObject:string]) {
        return YES;
    }
    
    return NO;
}


@end
