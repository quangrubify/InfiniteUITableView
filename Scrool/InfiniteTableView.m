
#import "InfiniteTableView.h"

@interface InfiniteTableView () {
    NSMutableArray *visibleLabels;
    UIView         *labelContainerView;
}

@property(nonatomic, retain)  NSMutableArray *visibleLabels;
@property(nonatomic, retain)  UIView *labelContainerView;

- (void)tileLabelsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX;

@end


@implementation InfiniteTableView

@synthesize dataDelegate;
@synthesize visibleLabels, labelContainerView;


-(void)dealloc
{
    self.visibleLabels = nil;
    self.labelContainerView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame andNumberOfColumns: (NSInteger)columns andColumnWidth:(NSInteger)_width andColumnHeight:(int)_height andGap:(NSInteger)_gap{
    if ((self = [super initWithFrame:frame])) {
        
        gap = _gap;
        numberOfColounm = columns;
        leftIndex = columns-1;
        rightIndex = 0;
        currentIndex = -1;
        width = _width;
        height = _height;
        self.contentSize = CGSizeMake(5000, self.frame.size.height);
        self.visibleLabels = [[[NSMutableArray alloc] init] autorelease];
        self.labelContainerView = [[[UIView alloc] init] autorelease];
        self.labelContainerView.frame = CGRectMake(0, self.frame.size.height/2 - self.contentSize.height/2, self.contentSize.width, self.contentSize.height);
        [self addSubview:labelContainerView];
        [labelContainerView setUserInteractionEnabled:NO];
        labelContainerView.backgroundColor = [UIColor clearColor];
        // hide horizontal scroll indicator so our recentering trick is not revealed
        [self setShowsHorizontalScrollIndicator:NO];
    }
    return self;
}

#pragma mark -
#pragma mark Layout

// recenter content periodically to achieve impression of infinite scrolling
- (void)recenterIfNecessary {
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentWidth = [self contentSize].width;
    CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    if (distanceFromCenter > (contentWidth / 4.0)) {
        self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        
        // move content by the same amount so it appears to stay still
        for (UILabel *label in visibleLabels) {
            CGPoint center = [labelContainerView convertPoint:label.center toView:self];
            center.x += (centerOffsetX - currentOffset.x);
            label.center = [self convertPoint:center toView:labelContainerView];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self recenterIfNecessary];
    // tile content in visible bounds
    CGRect visibleBounds = [self convertRect:[self bounds] toView:labelContainerView];
    CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
    CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
    
    if (currentIndex != -1) {
        
        [self tileLabelsFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
    }else
    {
        [self tileLabelsFromMinXFirstTime:minimumVisibleX toMaxX:maximumVisibleX];
        currentIndex = 0;        
    }
}


#pragma mark -
#pragma mark Label Tiling

- (UILabel *)insertLabel{
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, labelContainerView.frame.size.height/2 - height/2, width, height)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    [labelContainerView addSubview:label];
    return label;
}

- (CGFloat)placeNewLabelOnRight:(CGFloat)rightEdge {
    
    
    if (currentIndex == 0) {
        
        UILabel *label = [visibleLabels lastObject];
        rightIndex = label.tag;
        NSLog(@"\nLast tag: %d\n", rightIndex);
        rightIndex++;
        if (rightIndex >= numberOfColounm) {
            rightIndex = 0;
        }
    }
    
    UILabel *label = [self insertLabel];
    
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, labelContainerView.frame.size.height/2 - height/2, width, height)] autorelease];
    if (self.dataDelegate) {
        if ([self.dataDelegate respondsToSelector:@selector(infiniteTableView:andViewForIndex:widthRect:)]) {
            view = [self.dataDelegate infiniteTableView:self andViewForIndex:rightIndex widthRect: CGRectMake(0, 0, width, height)];
        }
    }
    
    view.frame = CGRectMake(0, 0, width, height);
    [label addSubview: view];
    
    [visibleLabels addObject:label]; // add rightmost label at the end of the array
    label.tag = rightIndex;
    
    CGRect frame = [label frame];
    frame.origin.x = rightEdge + gap;
    frame.origin.y = [labelContainerView frame].size.height/2 - height/2;
    [label setFrame:frame];
        
    return CGRectGetMaxX(frame);
}

- (CGFloat)placeNewLabelOnLeft:(CGFloat)leftEdge {
    
    
    if (currentIndex == 0) {
        
        UILabel *label = [visibleLabels objectAtIndex: 0];
        leftIndex = label.tag;
        NSLog(@"\nFirst tag: %d\n", leftIndex);
        leftIndex--;
        if (leftIndex < 0) {
            leftIndex = numberOfColounm-1;
        }
    }
    
    UILabel *label = [self insertLabel];
    
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, labelContainerView.frame.size.height/2 - height/2, width, height)] autorelease];
    if (self.dataDelegate) {
        if ([self.dataDelegate respondsToSelector:@selector(infiniteTableView:andViewForIndex:widthRect:)]) {
            view = [self.dataDelegate infiniteTableView:self andViewForIndex:leftIndex widthRect: CGRectMake(0, 0, width, height)];
        }
    }
    
    view.frame = CGRectMake(0, 0, width, height);
    [label addSubview: view];
    
    [visibleLabels insertObject:label atIndex:0]; // add leftmost label at the beginning of the array
    label.tag = leftIndex;
    
    CGRect frame = [label frame];
    frame.origin.x = leftEdge - frame.size.width - gap;
    frame.origin.y = [labelContainerView bounds].size.height/2 - height/2;
    [label setFrame:frame];
    
    return CGRectGetMinX(frame);
}

- (void)tileLabelsFromMinXFirstTime:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX {
    
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([visibleLabels count] == 0) {
        [self placeNewLabelOnRight:minimumVisibleX];
        rightIndex++;
    }
    
    // add labels that are missing on right side
    UILabel *lastLabel = [visibleLabels lastObject];
    CGFloat rightEdge = CGRectGetMaxX([lastLabel frame]);
    while (rightEdge < maximumVisibleX) {
        rightEdge = [self placeNewLabelOnRight:rightEdge];
        rightIndex++;
    }
    
    // add labels that are missing on left side
    UILabel *firstLabel = [visibleLabels objectAtIndex:0];
    CGFloat leftEdge = CGRectGetMinX([firstLabel frame]);
    while (leftEdge > minimumVisibleX) {
        
        leftIndex = numberOfColounm - 1;
        leftEdge = [self placeNewLabelOnLeft:leftEdge];
    }
    
    // remove labels that have fallen off right edge
    lastLabel = [visibleLabels lastObject];
    while ([lastLabel frame].origin.x > maximumVisibleX) {
        [lastLabel removeFromSuperview];
        [visibleLabels removeLastObject];
        lastLabel = [visibleLabels lastObject];
    }
    
    // remove labels that have fallen off left edge
    firstLabel = [visibleLabels objectAtIndex:0];
    while (CGRectGetMaxX([firstLabel frame]) < minimumVisibleX) {
        [firstLabel removeFromSuperview];
        [visibleLabels removeObjectAtIndex:0];
        firstLabel = [visibleLabels objectAtIndex:0];
    }
    
    for (int i=0; i<[visibleLabels count]; i++) {
        UILabel *l = [visibleLabels objectAtIndex:i];
        NSLog(@"\n-->>tag: %d\n", l.tag);
    }
    
    UILabel *l = [visibleLabels objectAtIndex:0];
    NSLog(@"\n-->>First tag: %d\n", l.tag);
    
    l = [visibleLabels lastObject];
    NSLog(@"\n-->>Last tag: %d\n", l.tag);
}

- (void)tileLabelsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX {
    
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([visibleLabels count] == 0) {
        [self placeNewLabelOnRight:minimumVisibleX];
    }
    
    // add labels that are missing on right side
    UILabel *lastLabel = [visibleLabels lastObject];
    CGFloat rightEdge = CGRectGetMaxX([lastLabel frame]);
    while (rightEdge < maximumVisibleX) {

        rightEdge = [self placeNewLabelOnRight:rightEdge];
        
    }
    
    // add labels that are missing on left side
    UILabel *firstLabel = [visibleLabels objectAtIndex:0];
    CGFloat leftEdge = CGRectGetMinX([firstLabel frame]);
    while (leftEdge > minimumVisibleX) {
        
        leftEdge = [self placeNewLabelOnLeft:leftEdge];
    }
    
    // remove labels that have fallen off right edge
    lastLabel = [visibleLabels lastObject];
    while ([lastLabel frame].origin.x > maximumVisibleX) {
        [lastLabel removeFromSuperview];
        [visibleLabels removeLastObject];
        lastLabel = [visibleLabels lastObject];
    }
    
    // remove labels that have fallen off left edge
    firstLabel = [visibleLabels objectAtIndex:0];
    while (CGRectGetMaxX([firstLabel frame]) < minimumVisibleX) {
        [firstLabel removeFromSuperview];
        [visibleLabels removeObjectAtIndex:0];
        firstLabel = [visibleLabels objectAtIndex:0];
    }
}

@end
