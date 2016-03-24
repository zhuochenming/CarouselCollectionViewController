//
//  CarouselCollectionViewLayout.m
//  zhuochenming
//
//  Created by zhuochenming on 16/1/29.
//  Copyright © 2016年 zhuochenming. All rights reserved.
//

#import "CarouselCollectionViewLayout.h"

@interface CarouselCollectionViewLayout ()

@property(nonatomic, strong) NSIndexPath *indexPathForCenteredItem;

//cell的frame信息
@property(nonatomic, readwrite) CGRect contentRect;

@property(nonatomic, readwrite) CGFloat contentStart;

@property(nonatomic) CGFloat cellYPosition;

@end

@implementation CarouselCollectionViewLayout

#pragma mark - Preparing Layout
- (void)prepareLayout {
    [super prepareLayout];
    [self maekCellFrameMessage];
}

#pragma mark - 使Cell位于页面中间
- (void)maekCellFrameMessage {
    UICollectionView *collectionView = self.collectionView;
    
    CGSize collectionViewSize = collectionView.bounds.size;
    CGSize layoutSize = self.itemSize;
    
    CGFloat rightLeftMargin = (collectionViewSize.width - layoutSize.width) / 2.0;
    CGFloat topBottomMargin = (collectionViewSize.height - layoutSize.height) / 2.0;
    
    NSInteger numberOfItems = [collectionView numberOfItemsInSection:0];
    
    // Content rect will be the actual content minus collection view insets
    CGFloat contentWidth = numberOfItems * layoutSize.width + (numberOfItems - 1) * self.itemInterval + 2 * rightLeftMargin;
    CGFloat contentHeight = layoutSize.height + 2 * topBottomMargin;
    
    CGRect contentRect = CGRectMake(0, 0, contentWidth, contentHeight);
    self.contentRect = UIEdgeInsetsInsetRect(contentRect, collectionView.contentInset);
    
    self.contentStart = rightLeftMargin;
    self.cellYPosition = CGRectGetMidY(self.contentRect) - collectionView.contentInset.top;
}

- (CGPoint)centerForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat x = self.contentStart + indexPath.row * (self.itemSize.width + self.itemInterval) + self.itemSize.width / 2.0;
    return CGPointMake(x, self.cellYPosition);
}

- (CGPoint)centerForHeaderViewAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *firstSectionItem = [NSIndexPath indexPathForItem:0 inSection:indexPath.section];
    CGPoint firstItemCenter = [self centerForItemAtIndexPath:firstSectionItem];
    firstItemCenter.x -= self.itemSize.width / 2.0f + self.itemInterval + self.headerSize.width / 2.0f;
    return CGPointMake(firstItemCenter.x, self.cellYPosition);
}

- (CGPoint)centerForFooterViewAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:indexPath.section];
    NSIndexPath *lastSectionItem = [NSIndexPath indexPathForItem:numberOfItems - 1 inSection:indexPath.section];
    CGPoint lastItemCenter = [self centerForItemAtIndexPath:lastSectionItem];
    lastItemCenter.x += self.itemSize.width / 2.0f + self.itemInterval + self.footerSize.width / 2.0f;
    return CGPointMake(lastItemCenter.x, self.cellYPosition);
}

#pragma mark - 返回collectionView的内容的尺寸
- (CGSize)collectionViewContentSize {
    return _contentRect.size;
}

#pragma mark - 返回rect中的所有的元素的布局属性数组
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    CGFloat combinedItemWidth = self.itemSize.width + self.itemInterval;
    
    CGFloat minimalXPosition = CGRectGetMinX(rect) - self.contentStart;
    CGFloat maximalXPosition = CGRectGetMaxX(rect) - self.contentStart;
    
    CGFloat firstVisibleItem = floorf(minimalXPosition / combinedItemWidth);
    CGFloat lastVisibleItem = ceilf(maximalXPosition / combinedItemWidth);
    
    if (firstVisibleItem < 0) {
        firstVisibleItem = 0;
    }
    
    if (lastVisibleItem > [[self collectionView] numberOfItemsInSection:0]) {
        lastVisibleItem = [[self collectionView] numberOfItemsInSection:0];
    }
    
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    for (NSInteger j = (NSInteger) firstVisibleItem; j < lastVisibleItem; j++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:0];
        [layoutAttributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
    [layoutAttributes addObjectsFromArray:[self supplementaryViewLayoutAttributes]];
    
    return layoutAttributes;
}

#pragma mark - 修正对应于indexPath的位置的cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [[[self class] layoutAttributesClass] layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect bounds = CGRectZero;
    bounds.size = self.itemSize;
    
    attributes.bounds = bounds;
    attributes.center = [self centerForItemAtIndexPath:indexPath];
    
    return attributes;
}

#pragma mark - 返回对应于indexPath的位置的追加视图的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes;
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader] && !CGSizeEqualToSize(self.headerSize, CGSizeZero)) {
        attributes = [[[self class] layoutAttributesClass] layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        attributes.size = self.headerSize;
        attributes.center = [self centerForHeaderViewAtIndexPath:indexPath];
    }
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionFooter] && !CGSizeEqualToSize(self.footerSize, CGSizeZero)) {
        attributes = [[[self class] layoutAttributesClass] layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        attributes.size = self.footerSize;
        attributes.center = [self centerForFooterViewAtIndexPath:indexPath];
    }
    
    return attributes;
}

#pragma mark - Layout Attributes Helpers
- (NSArray *)supplementaryViewLayoutAttributes {
    NSMutableArray *supplementaryViewLayoutAttributes = [NSMutableArray new];
    
    UICollectionViewLayoutAttributes *headerLayoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    if (headerLayoutAttributes) {
        [supplementaryViewLayoutAttributes addObject:headerLayoutAttributes];
    }
    
    UICollectionViewLayoutAttributes *footerLayoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    if (footerLayoutAttributes) {
        [supplementaryViewLayoutAttributes addObject:footerLayoutAttributes];
    }
    
    return [supplementaryViewLayoutAttributes copy];
}

#pragma mark - 自动对齐到网格位置
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGPoint targetContentOffset = proposedContentOffset;
    UICollectionViewLayoutAttributes *layoutAttributesForItemToCenterOn = [self layoutAttributesForUserFingerMovingWithVelocity:velocity proposedContentOffset:proposedContentOffset];
    
    if (layoutAttributesForItemToCenterOn) {
        targetContentOffset.x = layoutAttributesForItemToCenterOn.center.x - self.collectionView.bounds.size.width / 2.0;
        targetContentOffset.y = 0;
        self.indexPathForCenteredItem = layoutAttributesForItemToCenterOn.indexPath;
    }
    
    return targetContentOffset;
}

#pragma mark - 根据velocity判断UICollectionViewLayoutAttributes
- (UICollectionViewLayoutAttributes *)layoutAttributesForUserFingerMovingWithVelocity:(CGPoint)velocity proposedContentOffset:(CGPoint)offset {
    UICollectionViewLayoutAttributes *layoutAttributesForItemToCenterOn = nil;
    CGRect nextVisibleBounds = [self collectionView].bounds;
    nextVisibleBounds.origin = offset;
    
    NSPredicate *itemsPredicate = [NSPredicate predicateWithFormat:@"representedElementCategory == %d", UICollectionElementCategoryCell];
    NSArray *layoutAttributesInRect = [[self layoutAttributesForElementsInRect:nextVisibleBounds] filteredArrayUsingPredicate:itemsPredicate];
    if (velocity.x > 0.0f) {
        layoutAttributesForItemToCenterOn = [layoutAttributesInRect lastObject];
    } else if (velocity.x < 0.0f) {
        layoutAttributesForItemToCenterOn = [layoutAttributesInRect firstObject];
    } else {
        CGFloat distanceToCenter = CGFLOAT_MAX;
        for (UICollectionViewLayoutAttributes *attributes in layoutAttributesInRect) {
            CGFloat midOfFrame = CGRectGetMidX(self.collectionView.frame);
            CGFloat center = self.collectionView.contentOffset.x + midOfFrame;
            
            CGFloat distance = ABS(center - attributes.center.x);
            
            if (distance < distanceToCenter) {
                distanceToCenter = distance;
                layoutAttributesForItemToCenterOn = attributes;
            }
        }
    }
    return layoutAttributesForItemToCenterOn;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:self.indexPathForCenteredItem];
    CGPoint targetContentOffset = proposedContentOffset;
    
    if (attributes) {
        targetContentOffset.x = attributes.center.x - self.collectionView.bounds.size.width / 2.0;
        targetContentOffset.y = 0;
    }
    
    return targetContentOffset;
}

#pragma mark - 当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !CGSizeEqualToSize(self.collectionView.bounds.size, newBounds.size);
}

#pragma mark - Overridden Setters
- (void)setItemSize:(CGSize)itemSize {
    if (!CGSizeEqualToSize(_itemSize, itemSize)) {
        _itemSize = itemSize;
        [self invalidateLayout];
    }
}

- (void)setHeaderSize:(CGSize)headerSize {
    if (!CGSizeEqualToSize(_headerSize, headerSize)) {
        _headerSize = headerSize;
        [self invalidateLayout];
    }
}

@end
