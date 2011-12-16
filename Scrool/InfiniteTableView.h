
#import <UIKit/UIKit.h>

@class InfiniteTableView;

@protocol InfiniteTableViewDelegate <NSObject>

-(UIView*)infiniteTableView:(InfiniteTableView*)scrollView andViewForIndex:(int)index widthRect:(CGRect)rect;

@end

@interface InfiniteTableView : UIScrollView <UIScrollViewDelegate>
{
    id<InfiniteTableViewDelegate> dataDelegate;
    int numberOfColounm;    
    int currentIndex;
    int leftIndex;
    int rightIndex;
    int width, height;
    int gap;
    int centerColum;
    int selectedIndex;
    int column;
}

@property(nonatomic, assign) id<InfiniteTableViewDelegate> dataDelegate;
- (id)initWithFrame:(CGRect)frame andNumberOfColumns: (NSInteger)columns andColumnWidth:(NSInteger)_width andColumnHeight:(int)_height andGap:(NSInteger)_gap;
- (void)tileLabelsFromMinXFirstTime:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX;
-(void)setColumnAtIndex:(int)index;
-(void)setColoumToCenter:(int)column_;

@end
