#import "FacialView.h"
#import "Emoji.h"

#define kMaxEmojiNum  39
#define kBottomMargin 20

@interface FacialView ()<UIScrollViewDelegate>
@property(nonatomic, weak)UIScrollView *scrollView;
@property(nonatomic, weak)UIPageControl *pageControl;
@end

@implementation FacialView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _faces = [Emoji allEmoji];
    }
    return self;
}

- (void)setupScroll {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 40)];
    [self addSubview:scrollView];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    self.scrollView = scrollView;
    scrollView.pagingEnabled = YES;
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - kBottomMargin-40, CGRectGetWidth(self.frame), kBottomMargin)];
    [self addSubview:pageControl];
    pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.enabled = NO;
    self.pageControl = pageControl;
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame)-40, CGRectGetWidth(self.frame), 40)];
    [self addSubview:bottomView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [bottomView addGestureRecognizer:tap];
    bottomView.backgroundColor = [UIColor redColor];
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setFrame:CGRectMake(self.frame.size.width-60, 0, 60, 40)];
    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setBackgroundColor:[UIColor colorWithRed:10 / 255.0 green:82 / 255.0 blue:104 / 255.0 alpha:1.0]];
    [bottomView addSubview:sendButton];
}

- (void)tap {}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = (scrollView.contentOffset.x+scrollView.frame.size.width*0.5) / scrollView.frame.size.width;
    self.pageControl.currentPage = index;
}

//给faces设置位置
-(void)loadFacialView:(int)page size:(CGSize)size
{
    [self setupScroll];
    
    int maxRow = 3;
    int maxCol = 7;
    
    NSInteger numbers = _faces.count / (maxCol * maxRow - 1);
    if (_faces.count % (maxCol * maxRow - 1) > 0) {
        numbers += 1;
    }
    
    self.pageControl.numberOfPages = numbers;
    if (numbers == 1) {
        self.pageControl.hidden = YES;
    }
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * numbers, self.scrollView.frame.size.height);
    
    
    CGFloat itemWidth = self.scrollView.frame.size.width / maxCol;
    CGFloat itemHeight = (self.scrollView.frame.size.height-kBottomMargin) / maxRow;
    
    for (int i = 0; i<numbers; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height-kBottomMargin)];
        [self.scrollView addSubview:view];
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setBackgroundColor:[UIColor clearColor]];
        [deleteButton setFrame:CGRectMake((maxCol - 1) * itemWidth, (maxRow - 1) * itemHeight, itemWidth, itemHeight)];
        [deleteButton setImage:[UIImage imageNamed:@"faceDelete"] forState:UIControlStateNormal];
        deleteButton.tag = 10000;
        [deleteButton addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:deleteButton];
        
        for (int row = 0; row < maxRow; row++) {
            for (int col = 0; col < maxCol; col++) {
                int index = row * maxCol + col + i*(maxCol * maxRow - 1);
                if (index < [_faces count]) {
                    if (!(row == maxRow-1 && col == maxCol-1)) {
                        
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        [button setBackgroundColor:[UIColor clearColor]];
                        [button setFrame:CGRectMake(col * itemWidth, row * itemHeight, itemWidth, itemHeight)];
                        [button.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:29.0]];
                        [button setTitle: [_faces objectAtIndex:(index)] forState:UIControlStateNormal];
                        button.tag = row * maxCol + col;
                        [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
                        [view addSubview:button];

                    }
                }
                else{
                    break;
                }
            }
        }
    }
    /*
     UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [deleteButton setBackgroundColor:[UIColor clearColor]];
     [deleteButton setFrame:CGRectMake((maxCol - 1) * itemWidth, (maxRow - 1) * itemHeight, itemWidth, itemHeight)];
     [deleteButton setImage:[UIImage imageNamed:@"faceDelete"] forState:UIControlStateNormal];
     deleteButton.tag = 10000;
     [deleteButton addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
     [self addSubview:deleteButton];
     
     UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [sendButton setTitle:NSLocalizedString(@"send", @"Send") forState:UIControlStateNormal];
     [sendButton setFrame:CGRectMake((maxCol - 2) * itemWidth - 10, (maxRow - 1) * itemHeight + 5, itemWidth + 10, itemHeight - 10)];
     [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
     [sendButton setBackgroundColor:[UIColor colorWithRed:10 / 255.0 green:82 / 255.0 blue:104 / 255.0 alpha:1.0]];
     [self addSubview:sendButton];
     
     for (int row = 0; row < maxRow; row++) {
     for (int col = 0; col < maxCol; col++) {
     int index = row * maxCol + col;
     if (index < [_faces count]) {
     UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
     [button setBackgroundColor:[UIColor clearColor]];
     [button setFrame:CGRectMake(col * itemWidth, row * itemHeight, itemWidth, itemHeight)];
     [button.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:29.0]];
     [button setTitle: [_faces objectAtIndex:(row * maxCol + col)] forState:UIControlStateNormal];
     button.tag = row * maxCol + col;
     [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
     [self addSubview:button];
     }
     else{
     break;
     }
     }
     }*/
}


-(void)selected:(UIButton*)bt
{
    if (bt.tag == 10000 && _delegate) {
        [_delegate deleteSelected:nil];
    }else{
        NSString *str = [_faces objectAtIndex:bt.tag];
        if (_delegate) {
            [_delegate selectedFacialView:str];
        }
    }
}

- (void)sendAction:(id)sender
{
    if (_delegate) {
        [_delegate sendFace];
    }
}


@end
